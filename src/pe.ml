open Eff
open Core
open Common

exception NonStaticTypeCheck
let rec type_less : t -> t -> bool = fun a b ->
    match a, b with
    | TopT, _ -> raise NonStaticTypeCheck
    | _, TopT -> true
    | BottomT, _ -> true
    | UnionT xs, UnionT ys ->
        let xs = List.concat @@ List.map (fun x -> List.map (type_less x) ys) xs in
        if List.for_all (fun x -> x) xs then
            true
        else if List.for_all (fun x -> not x) xs  then
            false
        else
            raise NonStaticTypeCheck
    | x, UnionT xs ->
        List.exists (type_less x) xs
    | _ -> false

let rec specialise_bb : (module St) -> basic_blocks * label -> label =
    fun (module S: St) (bbs, jump_to) ->
    let {suite; phi} = Smap.find jump_to bbs in
    let _ = S.assign_vars @@ Smap.find S.it.cur_lbl phi in
    let config = (jump_to, Array.copy S.it.slots) in
    match S.lookup_config config  with
    | Some (lbl, _) -> lbl
    | None ->
    let (link_lbl, _) as link = S.add_config config in
    S.enter_block link;
    let is_def_generated = 
        if S.has_reached jump_to then begin
            S.dynamicalize_all ();
            match S.lookup_config (S.make_config()) with
            | Some(def_lbl, _) ->
                S.add_instr @@ Ir_goto def_lbl;
                true
            | None ->
                let (def_lbl, _) as def = S.add_config @@ S.make_config() in
                S.add_instr @@ Ir_goto def_lbl;
                S.enter_block def;
                false
            end
        else
            false
    in
    if is_def_generated
    then link_lbl
    else
    match S.union_types() with
    | [] -> (* no union split *)
        begin List.iter S.add_instr @@
                S.with_local @@ fun () ->
                specialise_instrs (module S: St) (bbs, suite)
        end; link_lbl
    | union_types ->
        let rec go = function
            | [] -> 
                Ir_block (specialise_instrs (module S: St) (bbs, suite))
            | (slot_idx, types)::tl ->
            match S.it.slots.(slot_idx).value with
            | S _ -> failwith "TODO"
            | D var  as v ->
            let cases = flip List.map types @@ fun t ->
                TypeL t, S.with_local (fun () ->
                    S.set_type (var, t); go tl)
            in
            let func = S.repr_eval (S (InstrinsicL TypeOf)) in
            let arg = S.repr_eval v in
            let expr = Ir_call(Ir_s func, [Ir_s arg], []) in
            Ir_switch(expr, cases)
        in S.add_instr @@ go union_types; link_lbl

and specialise_instrs : (module St) -> basic_blocks * instr list -> ir list  = 
    fun (module S) (bbs, instrs) ->
    let rec go = function
    | [] -> []
    | GotoIf(cond, t, f)::_ -> begin
        match S.repr_eval cond with
        | {value=D _} as cond ->
            if cond.typ != bool_t then failwith "TODO"
            else
            let t = specialise_bb (module S: St) (bbs, t) in
            let f = specialise_bb (module S: St) (bbs, f) in
            [Ir_gotoif(Ir_s cond, t, f)]
        | {value=S (BoolL true)} ->
            let t = specialise_bb (module S: St) (bbs, t) in
            [Ir_goto t]
        | {value=S (BoolL false)} ->
            let f = specialise_bb (module S: St) (bbs, f) in
            [Ir_goto f]
        | {value=S _} -> failwith "TODO"
        end
    | Goto l::_ ->
        let l = specialise_bb (module S: St) (bbs, l) in
        [Ir_goto l]
    | Return r::_ ->
        let value = S.repr_eval r in
        S.it.ret <- type_union value.typ S.it.ret;
        [Ir_return (Ir_s value)]
    | Assign(target, from)::tl ->
        let i = Smap.find target S.it.n2i in
        let from = S.repr_eval from in
        S.it.slots.(i) <- from;
        begin match from with
        | {value=S _} -> go tl
        | _ -> Ir_assign(target, Ir_s from)::go tl
        end
    | Call(Some bound, func, args, kwargs)::tl ->
        let func = S.repr_eval func in
        let args = List.map S.repr_eval args in
        let kwargs = Smap.map S.repr_eval kwargs in
        begin match func, args, kwargs with
        | {value=S(InstrinsicL IsTypeOf)},
          [{typ=t1}; {value=S (TypeL t2)}],
          [] -> begin
          try 
            let test = type_less t1 t2 in
            let _ = S.set_var bound @@ fun _ -> {value=S(BoolL test); typ=bool_t}
            in go tl
          with NonStaticTypeCheck ->
            failwith "TODO"
          end
        | _ -> failwith "TODO"
        end
    | _ -> failwith "TODO"
    in go instrs