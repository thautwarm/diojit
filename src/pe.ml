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
                    S.add_instr @@ Goto def_lbl;
                    true
                | None ->
                    let (def_lbl, def_block) as def = S.add_config @@ S.make_config() in
                    S.add_instr @@ Goto def_lbl;
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
                specialise_instrs (module S: St) (bbs, suite);
                link_lbl
            | union_types ->
                flip List.iter union_types @@ fun (types_to_narrow: (int * t) list) ->
                S.with_local @@ fun () ->
                    let condition_var = S.genvar() in
                    let conditions = flip List.map (types_to_narrow) @@ fun (slot_idx, t) ->
                        match S.it.slots.(slot_idx) with
                        | {value = S _} -> failwith "TODO"
                        | {value = D var} -> S.narrow var t
        prev_jump_to
        

        

            




and specialise_instrs : (module St) -> basic_blocks * instr list -> unit  =
