(* this is a global type environment *)
open Tt
open Smap
type tctx = t Darray.darray
let empty_tctx() = Darray.empty()

let previsit (f : 'ctx -> t -> ('ctx * t)) : 'ctx -> t -> t =
  let rec visit_t ctx' root =
    let (ctx, root) = f ctx' root in
    let rec eval_t node = visit_t ctx node
    and eval_row root =
      match root with
      | RowCons(k, t, row) -> RowCons(k, eval_t t, eval_row row)
      | RowMono            -> RowMono
      | RowPoly t          -> RowPoly(eval_t t)
    in
    match root with
    | Var _ | Nom _ | Fresh _ -> root
    | App(a, b)               -> App(eval_t a, eval_t b)
    | Arrow(a, b)             -> Arrow(eval_t a, eval_t b)
    | Tuple xs                -> Tuple(List.map eval_t xs)
    | Forall(ns, t)           -> Forall(ns, eval_t t)
    | Record rowt             -> Record(eval_row rowt)
  in visit_t

let visit_check (f : t -> bool) : t -> bool =
  let rec eval_t root =
    f root && begin
    let rec eval_row root =
      match root with
      | RowCons(_, t, row) -> eval_t t && eval_row row
      | RowMono            -> true
      | RowPoly t          -> eval_t t
    in
    match root with
    | Var _ | Nom _ | Fresh _ -> true
    | App(a, b)               -> eval_t a && eval_t b
    | Arrow(a, b)             -> eval_t a && eval_t b
    | Tuple xs                -> List.for_all eval_t xs
    | Forall(_, t)            -> eval_t t
    | Record rowt             -> eval_row rowt
    end
  in eval_t

exception IllFormedType of string
exception UnboundTypeVar of string
exception RowFieldMismatch of string
exception RowFieldDuplicatedInfer of string

module type TCState = sig
  val global : tctx
  val load_tvar : int -> t
  val mut_tvar : int -> t -> unit

  val fresh : (string, t) smap -> t -> t
  
  val new_type : string -> t
  val new_tvar : unit -> t
  val tvar_of_int : int -> t
  val int_of_tvar : t -> int option
  val typeid      : t -> string option

  val occur_in : tvar -> t -> bool
  val prune : t -> t
  val unify : t -> t -> bool
  val extract_row: rowt -> (string, t) smap * t option
end 

module MKTState(Init : sig val global: tctx end): TCState = struct
  let global = Init.global
  let load_tvar i = Darray.get i global
  let mut_tvar i a = Darray.update i a global
  let fresh =
      let visit_func freshmap = function
          | Fresh s as a -> freshmap, Smap.find_default a s freshmap
          | Forall(ns, _) as a -> List.fold_right Smap.remove ns freshmap, a
          | a -> freshmap, a
      in fun freshmap ty -> previsit visit_func freshmap ty
  let new_type x = Nom x
  let new_tvar () =
      let vid = Darray.len global in
      let tvar = Var (Refvar vid) in
      Darray.append global tvar;
      tvar
  let tvar_of_int i = Var (Refvar i)
  let int_of_tvar = function
    | Var(Refvar i) -> Some i
    | _ -> None

  let typeid = function
  | Nom s -> Some s
  | _ -> None

  let occur_in i ty =
    match ty with
    | Var (Genvar _) -> false
    | Var i' when i' = i -> false
    | _ ->
    let visit_func = function
      | Var i' when i = i' -> false
      | _ -> true
    in not @@ visit_check visit_func ty
  
  let rec prune x =
      let vfunc () a = (), match a with
        | Var (Refvar i) ->
          begin
            match load_tvar i with
            | Var (Refvar i') when i' = i -> a
            | a ->
              let t = prune a in
              mut_tvar i t; t
          end
        | _ -> a
      in previsit vfunc () x

  let extract_row =
      let rec extract_row fields =
        function
        | RowCons(k, _, _) when Smap.mem k fields ->
          raise @@ RowFieldDuplicatedInfer k
        | RowCons(k, v, rowt) ->
          let fields = Smap.add k v fields in
          extract_row fields rowt
        | RowMono -> (fields, None)
        | RowPoly (Record rowt) ->
          extract_row fields rowt
        | RowPoly t -> (fields, Some t)
      in extract_row Smap.empty
      
  let rec unify lhs rhs = match prune lhs, prune rhs with
      | Nom a, Nom b -> a = b
      | Forall(ns1, p1), Forall(ns2, p2) ->
        let subst1 =
          let fn a =
            let tvar = new_tvar() in
            a, tvar
          in List.map fn ns1
        in let subst2 =
          let fn a =
            let genvar = Var (genvar a) in
            a, genvar
          in List.map fn ns2
        in
        unify (fresh subst1 p1) (fresh subst2 p2) && 
          List.for_all
            (fun (_, x) -> match prune x with Var (Genvar _) -> true | _ -> false)
            subst1
      
      | Var a, Var b when a = b -> true
      | (Var _ as a), (Var (Refvar i) as b) -> unify b a
      | Var (Refvar i as a), b ->
        if occur_in a b
        then raise @@ IllFormedType "a = a -> b"
        else mut_tvar i b; true
      | Var (Genvar _), _ -> false
      | a, (Var _ as b) -> unify b a

      | (_, Fresh s) | (Fresh s, _) -> raise @@ UnboundTypeVar s
      | Arrow(a1, r1), Arrow(a2, r2) ->
        unify a1 a2 && unify r1 r2
      | App(f1, arg1), App(f2, arg2) ->
        unify f1 f2 && unify arg1 arg2
      | Tuple xs1, Tuple xs2 ->
        List.for_all2 unify xs1 xs2
      | Record a, Record b ->
        let (m1, ex1) = extract_row a in
        let (m2, ex2) = extract_row b in
        let common_keys =
          Smap.intersect (fun _ _ -> ()) m1 m2
        in
        let only_by1 = Smap.diffkeys m1 common_keys in
        let only_by2 = Smap.diffkeys m2 common_keys in
        let check_align (key, _) = unify (Smap.find key m1) (Smap.find key m2)
        in
        List.for_all check_align common_keys  &&
        let rec row_check row1 row2 only_by1 only_by2 =
          match (row1, row2) with
          | None, None -> Smap.is_empty only_by1 && Smap.is_empty only_by2
          | Some _, None -> row_check row2 row1 only_by2 only_by1
          | None, Some row2 ->
            (* only_by1 == {only_by2 | row2}
              where
                only_by1 \cap \only_by2 = \emptyset,
              therefore,
                only_by2 = \emptyset,
                row2 = only_by1
            *)
            Smap.is_empty only_by2 &&
            unify row2 @@ Record (record_of_map only_by1 RowMono)
          | Some row1, Some row2 ->
            (*
              {only_by1|row1} == {only_by2|row2},
              where
                only_by1 \cap \only_by2 = \emptyset,
              therefore,
                forall type in only_by2. type in row1, and
                forall type in only_by1. type in row2,
              therefore,
                t1 = {only_by1 \cup only_by2|row} = t2,
                {only_by1|row} = row2
                {only_by2|row} = row1
            *)
            let polyrow = RowPoly (new_tvar()) in
            let ex2 = Record(record_of_map only_by1 polyrow) in
            let ex1 = Record(record_of_map only_by2 polyrow) in
            unify row1 ex1 && unify row2 ex2
        in row_check ex1 ex2 only_by1 only_by2
      | _ -> false
end

let tcstate (tctx: tctx) =
  let module TC = MKTState(struct let global = tctx end) in
  (module TC: TCState)