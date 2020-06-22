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

let rec union_split (module S: St) bbs suite = fun xs ->
    let rec go = function
    | [] -> 
        Ir_block (specialise_instrs (module S: St) (bbs, suite))
    | (slot_idx, types)::tl ->
    match S.it.slots.(slot_idx).value with
    | S _ -> failwith "TODO1"
    | D var  as v ->
    let cases = flip List.map types @@ fun t ->
        t, S.with_local (fun () ->
            S.set_type (var, t); go tl)
    in
    let func = S.repr_eval (S (InstrinsicL TypeOf)) in
    let arg = S.repr_eval v in
    let expr = Ir_call(Ir_s func, [Ir_s arg], []) in
    Ir_switch(expr, cases)
    in go xs

and static_call_no_inline :
    (module St)
    -> basic_blocks * instr list
    -> var option
    -> fptr
    -> (value list * (string, value) Smap.smap)
    -> ir list =
    fun (module S: St) (bbs, tl)
    target fptr (args, kwargs) ->
    let {entry=form_entry} as fdef = M_int.find fptr S.it.i2f in
    if List.length args != List.length form_entry.args
    then failwith "TODO11-(verify args kwargs and globals)"
    else
    
    let lookup_kwargs from ((_, s) as k) =
        match Smap.find_opt s from with
        | Some v -> k, v.typ
        | None -> failwith "TODO12 invalid parameters"
    
    in let meth_entry = 
        { args = List.map2 (fun n {typ; _} -> n, typ) form_entry.args args
        ; kwargs = List.map (lookup_kwargs kwargs) form_entry.kwargs
        ; globals = form_entry.globals
        ; meth_bounds = form_entry.fn_bounds
        } 
    in let meth_spec = (fptr, meth_entry) in
    let call_with_meth_id meth_id =
            Ir_call(
               Ir_s (S.repr_eval @@ S (MethL meth_id)),
               List.map (fun x -> Ir_s x) args,
               Smap.map (fun x -> Ir_s x) kwargs
            )
    in
    let ir_expr, ret_t = match S.search_meth_id meth_spec with
        | Some meth_id ->
            let _, ret_t = S.find_meth_def meth_id in
            call_with_meth_id meth_id, ret_t
        | None ->
            let ir_lst, ret_t = specialise S.it meth_entry fdef.body in
            let def = {body = ir_lst; entry = meth_entry}, ret_t in
            let meth_id = S.new_meth meth_spec def in
            call_with_meth_id meth_id, ret_t
    in match target with
    | None -> [Ir_do ir_expr]
    | Some target ->
        Ir_assign(target, ir_expr) ::
        begin
         S.set_var target (fun _ -> {value = D target; typ = ret_t});
         match S.union_types() with
         | [] -> specialise_instrs (module S: St) (bbs, tl)
         | union_types ->
            [union_split (module S: St) bbs tl union_types]
        end

and specialise_bb : (module St) -> basic_blocks * label -> label =
    fun (module S: St) (bbs, jump_to) ->
    let {suite; phi} = Smap.find jump_to bbs in
    let _ =
        match Smap.find_opt S.it.cur_lbl phi with
        | Some xs ->
            S.assign_vars xs
        | None -> ()
    in
    let config = (jump_to, Array.copy S.it.slots) in
    match S.lookup_config config  with
    | Some (lbl, _) -> lbl
    | None ->
    let (link_lbl, link_block) = S.add_config config in
    S.enter_block link_block;
    S.it.cur_lbl <- jump_to;
    let is_def_generated = 
        if S.has_reached jump_to then begin
            S.dynamicalize_all ();
            match S.lookup_config (S.make_config()) with
            | Some(def_lbl, _) ->
                S.add_instr @@ Ir_goto def_lbl;
                true
            | None ->
                let (def_lbl, def_block) = S.add_config @@ S.make_config() in
                S.add_instr @@ Ir_goto def_lbl;
                S.enter_block def_block;
                false
            end
        else
            false
    in
    S.mark_reached jump_to;
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
        let split = union_split (module S: St) bbs suite union_types in
        S.add_instr split; link_lbl

and specialise_instrs : (module St) -> basic_blocks * instr list -> ir list  = 
    fun (module S) (bbs, instrs) ->
    let rec go = function
    | [] -> []
    | GotoIf(cond, t, f)::_ -> begin
        match S.repr_eval cond with
        | {value=D _} as cond ->
            if cond.typ != bool_t then failwith "TODO2"
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
        | {value=S _} -> failwith "TODO3"
        end
    | Goto l::_ ->
        let l = specialise_bb (module S: St) (bbs, l) in
        [Ir_goto l]
    | Return r::_ ->
        let value = S.repr_eval r in
        let open Pretty in
        print_endline @@ show_ir_repr (Ir_s value);
        S.add_return_type value.typ;
        [Ir_return (Ir_s value)]
    | Assign(target, from)::tl ->
        let from = S.repr_eval from in
        S.set_var target (const from);
        begin match from with
        | {value=S _} -> go tl
        | _ -> Ir_assign(target, Ir_s from)::go tl
        end
    | Call(bound, func, args, kwargs)::tl ->
        let func = S.repr_eval func in
        let args = List.map S.repr_eval args in
        let kwargs = Smap.map S.repr_eval kwargs in
        begin match bound, func, args, kwargs with
        | Some bound,
          {value=S(InstrinsicL IsTypeOf)},
          [{typ=t1} as l; {value=S (TypeL t2)} as r],
          [] ->
            begin try 
                let test = type_less t1 t2 in
                let _ = S.set_var bound @@ fun _ -> {value=S(BoolL test); typ=bool_t}
                in go tl
            with NonStaticTypeCheck ->
            let rt_tyck =
                Ir_call(
                    Ir_s (S.repr_eval @@ S(InstrinsicL IsTypeOf)),
                    [Ir_s l; Ir_s r],
                    []
                )
            in
            (* case split for boolean *)
            begin match l with
            | {value=D lvar} ->
                let true_clause =
                    S.with_local @@ fun () ->
                    let _ = S.set_var bound @@
                        fun _ -> {value = S(BoolL true); typ=bool_t}
                    in
                    let _ = S.set_var lvar @@
                        fun _ -> {l with typ=t2}
                    in go tl
                in
                let false_clause =
                    (* TODO: type difference *)
                    S.with_local @@ fun () ->
                    let _ = S.set_var bound @@
                        fun _ -> {value = S(BoolL false); typ=bool_t}
                    in go tl
                in [Ir_if(rt_tyck, Ir_block true_clause, Ir_block false_clause)]
            | _ -> failwith "TODO 10"
            end (* match *)
            end (* try *)
        | _, {typ=FPtrT fptr}, args, kwargs ->
            static_call_no_inline (module S: St) (bbs, tl) bound fptr (args, kwargs)
        | _ -> failwith "TODO5"
        end
    in go instrs

and specialise : pe_state
    -> meth_entry (* current function *)
    -> basic_blocks
    -> (ir list * t)  (* specialized body and return type *)
    = fun pe_state {args; kwargs; globals; meth_bounds} body ->
    let meth_bounds = List.map (fun a -> a, BottomT) meth_bounds in
    let ns = args @ kwargs @ meth_bounds @ globals in
    let mk = List.map (fun (var, t) ->  {typ = t; value=D var}) in
    let n2i = List.mapi (fun i (x, _) -> (x, i)) ns in
    let slots = Array.of_list @@ mk ns in
    let init_state =
        { pe_state with
          out_bbs = M_state.empty
        ; lbl_count = 0
        ; ret = BottomT
        ; reached = Smap.empty
        ; slots = slots
        ; cur_block = Darray.empty()
        ; cur_lbl = entry_label
        ; n2i = n2i
        }
    in
    let module S = MkSt(struct let x = init_state end) in
    let _ = specialise_bb (module S: St) (body, entry_label) in
    let {out_bbs; ret} = S.it in
    let out_irs = ref [] in
    let _ = flip List.iter (M_state.bindings out_bbs) @@ fun (_, (_, irs)) ->
        flip Darray.iter irs @@ fun ir ->
            out_irs := ir :: !out_irs
    in
    (List.rev !out_irs, ret)

let init_pe_state : fn_def M_int.t (* all function pointers *) -> pe_state =
    fun f_defs ->
    { out_bbs = M_state.empty
    ; lbl_count = 0
    ; ret = BottomT
    ; reached = Smap.empty
    ; slots = [||]
    ; cur_block = Darray.empty()
    ; cur_lbl = entry_label
    ; n2i = []
    ; i2f = f_defs
    ; scope_level = 0
    ; meth_refs = M_func_entry.empty
    ; meth_defs = M_int.empty
    ; meth_count = 0
    }