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
    val set_type : (var * t) -> unit
    val enter_block: ir Darray.darray -> unit
    val add_instr : ir -> unit
    val add_return_type : t -> unit
    val genlbl : unit -> label

    val union_types : unit -> (int * t list) list
    val create_block : label -> ir Darray.darray
    val add_config : (label * value array) -> (label * ir Darray.darray)
    val make_config : unit -> (label * value array)
    val lookup_config : (label * value array) ->  (label * ir Darray.darray) option
    val repr_eval : repr -> value

    val set_var : var -> (value -> value) -> unit
end

module MkSt(X : sig val x : pe_state end) : St = struct
    module X = X
    let it = X.x
    
    let repr_eval = function
        | S c as a -> {value=a; typ=type_of_const c}
        | D var ->
            let i = Smap.find var it.n2i in
            it.slots.(i)

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
                Darray.append it.cur_block (Ir_assign(v1, Ir_s s2));
                it.slots.(i1) <- {s2 with value = D v1}
                                
    let assign target =
        let i_target = Smap.find target it.n2i in
        let s_target = it.slots.(i_target) in
        match s_target.typ with
        | TopT -> fun repr ->
            let value = repr_eval repr in
            Darray.append it.cur_block @@ Ir_assign(target, Ir_s value)
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
                Darray.append it.cur_block @@ 
                    Ir_assign(target, Ir_s s);
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
            | {typ = BottomT; _} -> failwith "TODO7"
            | {typ = TopT; _} | {typ = UnionT _; _} -> ()
            | {typ; value} ->
                let func = repr_eval @@ S (InstrinsicL Upcast) in
                let args = List.map repr_eval [S(TypeL typ); value] in
                add_instr @@ Ir_assign(
                    n, 
                    Ir_call(
                        Ir_s func,
                        List.map (fun x -> Ir_s x) args,
                        []
                    )
                )
        ) it.n2i


    let enter_block block =
        it.cur_block <- block
    
    let add_return_type t =
        it.ret <- type_union it.ret t

    let genlbl () = 
        let v = it.lbl_count in
        it.lbl_count <- v + 1; (it.scope_level, string_of_int v)

    let union_types () =
            List.unwrap_seq @@
            Array.to_list @@
            Array.mapi
            (fun i ->
                function
                | {typ = UnionT ts; _} -> Some (i, ts)
                | _ -> None)
            it.slots
        
        
    let create_block lbl =
        let config = lbl, Array.copy it.slots in
        let new_lbl = genlbl() in
        let block = Darray.from_array [|Ir_label new_lbl|] in
        it.out_bbs <- M_state.add config (new_lbl, block) it.out_bbs;
        block
    
    let add_config config =
        let label = genlbl() in
        let block = Darray.from_array [|Ir_label label|] in
        it.out_bbs <- M_state.add config (label, block) it.out_bbs;
        label, block

    let make_config () = it.cur_lbl, Array.copy (it.slots)

    let lookup_config config = M_state.find_opt config it.out_bbs
    
    let set_type (var, t) =
        let i = Smap.find var it.n2i in
        it.slots.(i) <- {it.slots.(i) with typ = t}

    
    let set_var var lens =
        let i = Smap.find var it.n2i in
        it.slots.(i) <- lens @@ it.slots.(i)

end

module CopySt(S: St) = MkSt(S.X)

