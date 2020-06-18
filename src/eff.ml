open Core
open Common

let type_union : t -> t -> t = fun a b ->
    match a, b with
    | TopT, _ | _, TopT -> TopT
    | BottomT, BottomT -> failwith "type_union cannot be used on 2 undefined items."
    | BottomT, a | a, BottomT -> a
    | UnionT xs, UnionT ys ->
        UnionT (List.sort_uniq compare @@ xs @ ys)
    | UnionT xs, y | y, UnionT xs ->
        UnionT (Sset.add y xs)
    | x, y when x = y -> x
    | x, y -> UnionT [x; y]
    

let bool_t = NomT "bool"
let int_t =  NomT "int"
let float_t =  NomT "float"
let string_t =  NomT "string"

let rec type_of_const : const -> t = function
    | NoneL -> NoneT
    | UndefL -> BottomT
    | IntL _ -> int_t
    | BoolL _ -> bool_t
    | FloatL _ -> float_t
    | StrL _  -> string_t
    | TupleL xs -> TupleT (List.map type_of_const xs)
    | InstrinsicL c -> IntrinsicT c
    | TypeL t       -> TypeT t


module type St = sig
    module X : sig val x :  pe_state end
    val it : pe_state
    val assign_vars : (var * var) list -> unit
    val assign : var -> repr -> unit
    val mark_reached : label -> unit
    val has_reached : label -> bool
    val with_local : (unit -> 'b) -> 'b
    val dynamicalize_all : unit -> unit
    val narrow : var -> t -> repr
    val enter_block: (label * instr Darray.darray) -> unit
    val add_instr : instr -> unit
    val add_return_type : t -> unit
    val genlbl : unit -> label
    val genvar : unit -> var
    val union_types : unit -> (int * t) list list
    val create_block : label -> instr Darray.darray
    val add_config : (label * value array) -> (label * instr Darray.darray) -> unit
    val dynamic_values : value array
    val make_config : unit -> (label * value array)
    val lookup_config : (label * value array) ->  (label * instr Darray.darray) option

end

module MkSt(X : sig val x : pe_state end) : St = struct
    let it = X.x
    module X = X
    let assign_vars vs =
        let slots' = Array.copy it.slots in
        flip List.iter vs @@ fun (v1, v2) ->
            let i1 = Smap.find v1 it.n2i in
            let i2 = Smap.find v2 it.n2i in
            let s2 = slots'.(i2) in
            match s2 with
            | {value = S _; _} ->
                it.slots.(i1) <- s2
            | _ ->
                Darray.append it.cur_block (Assign(v1, D v2));
                it.slots.(i1) <- {s2 with value = D v1}
                                
    let assign target =
        let i_target = Smap.find target it.n2i in
        let s_target = it.slots.(i_target) in
        match s_target.typ with
        | TopT -> fun repr -> Darray.append it.cur_block (Assign(target, repr))
        | _ ->
        function
        | D var ->
            let i_var = Smap.find var it.n2i in
            let s = it.slots.(i_var) in
            begin match s with
            | {typ = BottomT; _} ->
                failwith @@ "undefined variable " ^ snd var
            | {value = S _; _} ->
                it.slots.(i_target) <- s
            | _ ->
                Darray.append it.cur_block (Assign(target, D var));
                it.slots.(i_target) <- {s with value = D target}
            end
        | S lit as static ->
            it.slots.(i_target) <- {typ = type_of_const lit; value = static}
    
    let mark_reached lbl = it.reached <- Sset.add lbl it.reached

    let has_reached lbl = Sset.mem lbl it.reached
    
    let with_local = fun do_it ->
        let slots', slots = Array.copy it.slots, it.slots in
        let reached = it.reached in
        let cur_lbl = it.cur_lbl in
        let cur_block = it.cur_block in
        let _ = it.slots <- slots' in
        let ret = do_it() in
        it.slots <- slots;
        it.reached <- reached;
        it.cur_block <- cur_block;
        it.cur_lbl <- cur_lbl;
        ret
    
    let add_instr instr = Darray.append it.cur_block instr

    (* this applies when a type-unstable loop detected *)
    let dynamicalize_all () =
        List.iter (
            fun (n, i) ->
            let v = it.slots.(i) in
            it.slots.(i) <- {typ = TopT; value = D n};
            match v with
            | {typ = BottomT; _} -> failwith "TODO"
            | {typ = TopT; _} | {typ = UnionT _; _} -> ()
            | {typ; value} ->
                add_instr @@ Call(
                    None,
                    S (InstrinsicL Upcast),
                    [S(TypeL typ); value],
                    []
                )
        ) it.n2i


    let enter_block label block =
        it.cur_block <- block;
        it.cur_lbl <- label
    
    let add_return_type t =
        it.ret <- type_union it.ret t

    let genlbl () = 
        let v = it.lbl_count in
        it.lbl_count <- v + 1; (it.scope_level, string_of_int v)
    let genvar () = 
        let v = it.var_count in
        it.var_count <- v + 1; (it.scope_level, string_of_int v)

    let union_types () : (int * t) list list =
        let unions = 
            List.unwrap_seq @@
            Array.to_list @@
            Array.mapi
            (fun i ->
                function
                | {typ = UnionT ts; _} -> Some (i, ts)
                | _ -> None)
            it.slots
        in
        let indices, tss = List.unzip unions in
        let tss = sequence tss in
        List.map (List.zip indices) tss
        
    let create_block lbl =
        let config = lbl, Array.copy it.slots in
        let new_lbl = genlbl() in
        let block = Darray.from_array [|Label new_lbl|] in
        it.out_bbs <- M_state.add config (new_lbl, block) it.out_bbs;
        block
    
    let narrow var t =
        let i = Smap.find var it.n2i in
        match it.slots.(i) with
        | {typ = t'} when t' = t -> S (BoolL true)
        | {value = S _} -> failwith "TODO"
        | a -> 
            it.slots.(i) <- {a with typ = t};
            let check_var = genvar() in
            add_instr @@ Call (
                Some check_var,
                S (InstrinsicL Downcast),
                [S(TypeL t); D var],
                []
            );
            D check_var
    
    let add_config config labelled_block =
        it.out_bbs <- M_state.add config labelled_block it.out_bbs

    let dynamic_values =
        let revmap = List.map (fun (a, b) -> b, a) it.n2i in
        Array.init (Array.length it.slots) (fun i ->
            {value=D (Smap.find i revmap); typ=TopT}
        )
    let make_config () = it.cur_lbl, Array.copy (it.slots)

    let lookup_config config = M_state.find_opt config it.out_bbs
end

module CopySt(S: St) = MkSt(S.X)

