type 'a scoped = int * 'a
let scope_of : 'a scoped -> int = fun (a, _) -> a
let unwrap_scope : 'a scoped -> 'a = fun (_, a) -> a

type label = string scoped

type var = string scoped
type instrinsic = Make_closure 
                | Make_cell
                | Deref
                | IsTypeOf
type const =
| NoneL
| UndefL
| IntL of int
| BoolL of bool
| FloatL of float
| StrL of string (* becomes char array after prototyping *)
| TupleL of const list
| InstrinsicL of instrinsic


type repr = Var of var | Const of const
type abs_value = S of const | D

type instr =
| GotoIf : repr * label * label -> instr
| Goto   : label -> instr
| Assign : var * repr -> instr
| Return : repr -> instr
| Call   : var option (* bound to *)*
           repr (* func *) * repr (* args *) * repr (* kwargs *)
           -> instr

type basic_block = {
    suite: instr list;
    phi : (label, (var, var) Smap.smap) Smap.smap
}

type basic_blocks = (label, basic_block) Smap.smap

module MState = struct
    type ('s, 'a) state = {run_state : 's -> ('a * 's)}
    let return a = {run_state = fun s -> (a, s)}
    let (>>=) m k = {run_state = fun s -> let (a, s) = m.run_state s in (k a).run_state s}        
    let (>>) m1 m2 = {run_state = fun s -> let (_, s) = m1.run_state s in m2.run_state s}
    let get = {run_state = fun s -> (s, s)}
    let gets f = {run_state = fun s -> (f s, s)}
    let modify f = {run_state = fun s -> (), f s}
    let put s = {run_state = fun _ -> (), s}
    let forM_ ms k = List.fold_left (fun a b -> a >> (b >>= k)) (return ()) ms >> return ()
    
    let forM ms k = 
        let f a b = a >>= k >>= fun a -> b >>= fun b -> return (a::b) in
        List.fold_right f ms (return [])
end


type t =
| ClosureT of t * int (* function number *)
| TupleT of t list
| TypeT of t
| CellT of t
| NomT of string
| NoneT
| RecordT of (string, t) Smap.smap
| UnionT of t list
| ObjectT of int (* object type number *)
| IntrinsicT of instrinsic
| TopT
| BottomT

type value = {typ: t; value: abs_value}
and value_ref = int

type config = label * value array
module M_state = Map.Make(struct
    type t = config
    let compare = compare
end)

module M_int = Map.Make(Int)

(* todo: to avoid infinite configutions, add a set of reached labels*)
type pe_state = {
    n2i : (var, int) Smap.smap;
    i2f : func_def M_int.t;
    
    slots : value array;
    reached : (label * instr Darray.darray) M_state.t;
    bb_count : int ref;
}

and func_entry = {
    args : (var, t) Smap.smap;
    kwargs : (var, t) Smap.smap;
    closure : (var, t) Smap.smap;

    other_bounds : (var, t) Smap.smap; (* shall be all undefined *)
}

and func_def = {
    func_entry : func_entry;
    body : basic_blocks
}

let type_union : t -> t -> t = fun a b ->
    match a, b with
    | BottomT, BottomT -> failwith "type_union cannot be used on 2 undefined items."
    | BottomT, a | a, BottomT -> a
    | UnionT xs, UnionT ys ->
        UnionT (List.sort_uniq compare @@ xs @ ys)
    | UnionT xs, y | y, UnionT xs ->
        UnionT (Sset.add y xs)
    | x, y when x = y -> x
    | x, y -> UnionT [x; y]
    
    
let rec type_of_const : const -> t = function
    | NoneL -> NoneT
    | UndefL -> BottomT
    | IntL _ -> NomT "int"
    | BoolL _ -> NomT "bool"
    | FloatL _ -> NomT "float"
    | StrL _  -> NomT "string"
    | TupleL xs -> TupleT (List.map type_of_const xs)
    | InstrinsicL c -> IntrinsicT c

let rec type_less : t -> t -> bool = fun a b ->
    match a, b with
    | _, TopT -> true
    | BottomT, _ -> true
    | UnionT xs, UnionT ys ->
        List.for_all (fun x -> List.exists (type_less x) ys) xs
    | x, UnionT xs ->
        List.exists (type_less x) xs
    | _ -> false

let rec specialise_bb : basic_blocks -> label -> (pe_state, label) MState.state =
    fun blocks cur_lbl ->
    let {suite; phi} = Smap.find cur_lbl blocks in
    let open MState in
    get >>= fun ({slots; n2i; reached; bb_count; _} as st) ->
    let slots' = Array.copy slots in
    let instrs = Darray.empty() in
    let prepare_phi : (var, var) Smap.smap -> unit =
        let iter_do (reg, from) =
            let _ = Darray.append instrs (Assign (reg, Var from)) in
            let i_reg, i_from = Smap.find reg n2i, Smap.find from n2i in
            let v1 = slots'.(i_reg) in
            let v2 = slots.(i_from) in
            if v2.typ = BottomT
            then failwith "NameError detected"
            else
            if v1.typ = BottomT
            then slots'.(i_reg) <- v2
            else
            slots'.(i_reg) <- {
                typ = type_union v1.typ v2.typ;
                value=v2.value
            }
        in List.iter iter_do
    in
    let _ = prepare_phi @@ Smap.find cur_lbl phi in
    let config = (cur_lbl, slots') in
    match M_state.find_opt config reached with
    | Some (lbl, _) -> return lbl
    | None ->
        let _ = incr bb_count in
        let gen_lbl = (0, string_of_int !bb_count) in
        let reached = M_state.add config (gen_lbl, instrs) reached in        
        put {st with slots = slots'; reached = reached} >>= fun () ->
        (* TODO: union split here *)
        let _ = specialise_instrs blocks suite in
        return gen_lbl
    
and specialise_instrs : basic_blocks -> instr list -> (pe_state, instr list) MState.state =
    let open MState in
    fun blocks ->
    function
    | [] -> return []
    | instr::xs ->
    let get_tailm() = specialise_instrs blocks xs in
    match instr with
    | Goto lbl | GotoIf (Const (BoolL true), lbl, _) ->
        specialise_bb blocks lbl >>= fun lbl ->
        return @@ [Goto lbl]

    | GotoIf (Const (BoolL false), _, lbl) ->
        specialise_bb blocks lbl >>= fun lbl ->
        return @@ [Goto lbl]

    | GotoIf (Const _, _, _) ->
        failwith "internal error"

    | GotoIf (Var var, l1, l2) ->
        get >>= fun ({slots; n2i;_}) ->
        let i = Smap.find var n2i in
        let v1 = slots.(i) in begin
        match v1.value with
        | S (BoolL true) ->
            specialise_bb blocks l1 >>= fun lbl ->
            return @@ [Goto lbl]
        | S (BoolL false) ->
            specialise_bb blocks l2 >>= fun lbl ->
            return @@ [Goto lbl]
        | _ ->
            specialise_bb blocks l1 >>= fun l1 ->
            specialise_bb blocks l2 >>= fun l2 ->
            get_tailm() >>= fun tl -> return @@ GotoIf(Var var, l1, l2)::tl
        end
    | Return _ ->
        return [instr]
    
    | Assign(var, Const const) ->
        get >>= fun ({slots; n2i;_} as pe_state) ->
        let ty = type_of_const const in
        let i1 = Smap.find var n2i in
        let v1 = slots.(i1) in
        let v2 = {typ = ty; value=S const} in
        if v1 = v2 then
            get_tailm()
        else
            let slots' = Array.copy slots in
            (if v1.typ = BottomT then
                slots'.(i1) <- v2
            else
                (* so far no register allocation optim,
                   hence reusing variables cause inefficiency.
                *)
                slots'.(i1) <- {typ = type_union v1.typ v2.typ; value=v2.value}
            );
            put {pe_state with slots = slots'} >>
            (* we can later optimize unused variables *)
            get_tailm() >>= fun tl -> return @@ instr::tl
    
    | Assign(var, Var from) ->
        get >>= fun ({slots; n2i;_} as pe_state) ->
        let i1, i2 = Smap.find var n2i, Smap.find from n2i in
        let v1, v2 = slots.(i1), slots.(i2) in
        if v1 = v2 then
            get_tailm ()
        else
            let slots' = Array.copy slots in
            let _ = slots'.(i1) <- v2 in
            put {pe_state with slots = slots'} >>
            (get_tailm() >>= fun tl -> return @@ instr::tl)
        
    | Call(Some bound, Const (InstrinsicL IsTypeOf), (Var var), Const UndefL) ->
        get >>= fun ({slots; n2i;_} as pe_state) ->
        let bi, vi = Smap.find bound n2i, Smap.find var n2i in
        let vv = slots.(vi) in begin
        match vv.typ with
        | TypeT ty ->
            let test = S (BoolL (type_less ty vv.typ)) in
            let slots' = Array.copy slots in
            let _ = slots'.(bi) <- {typ = type_union slots.(bi).typ ty; value=test} in
            put {pe_state with slots=slots'} >> get_tailm ()
        | _ ->
            get_tailm() >>= fun tl -> return @@ instr :: tl
        end
        
    | Call(_, _, _, _) ->
        failwith "TODO"


and specialise :  func_def (* current function *)
    -> func_def M_int.t (* all function pointers *)
    -> (label * instr list) list (* specialized body *)
    = fun { func_entry={args; kwargs; closure; other_bounds}; body } f_defs ->
    let mk = List.map (fun (_, t) ->  {typ = t; value=D}) in
    let ns = args @ kwargs @ closure @ other_bounds in
    let n2i = List.mapi (fun i (x, _) -> (x, i)) ns in
    let states = Array.of_list @@ mk ns in
    let init_state = {slots = states ; n2i = n2i; reached = M_state.empty; i2f = f_defs; bb_count = ref 0} in
    let m = specialise_bb body (0, "entry") in
    let (_, {reached; _}) = m.run_state init_state in 
    List.map
        (fun (_, (lbl, bb)) -> lbl, Darray.to_list bb)
        @@ M_state.bindings reached
