
open Core
open Common
open Eff


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


let intrinsic_eq go_tl (module S: St) bound l r =
    S.set_type (bound, bool_t);
    Ir_assign(bound, Ir_call(Ir_s (ieval PolyEq), [Ir_s l; Ir_s r], []))::go_tl()

let intrinsic_build_tuple go_tl (module S: St) bound elts =
    let types = List.map (fun {typ} -> typ) elts in
    let tuple_t = TupleT types in
    let rec get_constants = function
        | {value = S c} :: tl ->
            begin match get_constants tl with
            | Some tl -> Some (c :: tl)
            | None -> None
            end
        | {value = D _} :: _ -> None
        | [] -> Some []
    in match get_constants elts with
    | Some elts ->
        S.set_var bound (fun _ -> {value = S (TupleL elts); typ = tuple_t});
        go_tl()
    | None ->
        S.set_type (bound, tuple_t);
        let elts = List.map (fun x -> Ir_s x) elts in
        Ir_assign(bound, Ir_call(Ir_s (ieval BuildTuple), elts, []))::go_tl()    
    

let intrinsic_add go_tl (module S: St) bound l r =
  let t, add = match l, r with
  | {typ=lt}, {typ=rt} when lt = int_t && rt = int_t ->
    int_t, Ir_call(Ir_s (ieval IntIntAdd), [Ir_s l; Ir_s r], [])
  | {typ=lt}, {typ=rt} when lt = float_t && rt = float_t ->
    float_t, Ir_call(Ir_s (ieval FloatFloatAdd), [Ir_s l; Ir_s r], [])
  | (({typ=lt} as l), ({typ=rt} as r)) | (({typ=rt} as r), ({typ=lt} as l))
    when lt = int_t && rt = float_t ->
    float_t, Ir_call(Ir_s (ieval IntFloatAdd), [Ir_s l; Ir_s r], [])
  | _ ->
    TopT, Ir_call(Ir_s (ieval PolyAdd), [Ir_s l; Ir_s r], [])
  in 
  S.set_type(bound, t);
  Ir_assign(bound, add)::go_tl()

let intrinsic_isinstance go_tl (module S: St) bound l r t =
  try 
  let test = type_less l.typ t in
        let _ = S.set_var bound @@ fun _ -> {value=S(BoolL test); typ=bool_t}
        in go_tl()
  with NonStaticTypeCheck ->
    let rt_tyck =
        Ir_call(
            Ir_s (ieval IsInstanceOf),
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
                fun _ -> {l with typ=t}
            in go_tl()
        in
        let false_clause =
            (* TODO: type difference *)
            S.with_local @@ fun () ->
            let _ = S.set_var bound @@
                fun _ -> {value = S(BoolL false); typ=bool_t}
            in go_tl()
        in [Ir_if(rt_tyck, Ir_block true_clause, Ir_block false_clause)]
    | _ -> failwith "TODO 10"
    end (* match *)
        