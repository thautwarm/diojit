class uniq (s: string) = object method name = s end
let create_uniq s = new uniq s
type tvar =
  | Refvar of int
  | Genvar of uniq
and rowt =
  | RowCons of string * t * rowt
  | RowPoly of t
  | RowMono

and t =
  | App      of t * t
  | Arrow    of t * t
  | Var      of tvar
  | Nom      of string
  | Fresh    of string
  | Tuple    of t list
  | Forall   of string list * t
  | Record   of rowt

let record xs = List.fold_right (fun (k, v) b -> RowCons(k, v, b)) xs
let record_of_map = record

let is_simple = function
  | Var _ | Fresh _ | Nom _ | Record _ | Tuple _  -> true
  | _ -> false

let rec dumpstr show x =
  let dumpstr = dumpstr show in
  match x with
  | App(f, arg) when is_simple arg -> dumpstr f ^ " " ^ dumpstr arg
  | App(f, arg)  -> dumpstr f ^ " (" ^ dumpstr arg ^ ")"
  | Arrow(arg, ret) when is_simple arg -> dumpstr arg ^ " -> " ^ dumpstr ret
  | Arrow(arg, ret) -> "(" ^ dumpstr arg ^ ") -> " ^ dumpstr ret
  | Forall(ns, t) -> "forall {" ^ String.concat " " ns ^ "} " ^ dumpstr t
  | Tuple(elts) -> "[" ^ String.concat ", " (List.map dumpstr elts) ^ "]"
  | Record rowt -> begin match dumpstr_row show rowt with
    | xs, Some tho -> "{" ^ String.concat ", " xs ^ " | " ^ tho ^ "}"
    | xs, None     -> "{" ^ String.concat ", " xs ^ "}"
    end
  | Var (Refvar i) -> "'" ^ string_of_int i
  | Var (Genvar i) -> "#" ^ i#name
  | Nom i -> "^" ^ i
  | Fresh a -> a

and dumpstr_row show x =
  let dumpstr_row = dumpstr_row show in
  let dumpstr = dumpstr show in
  match x with
  | RowCons(n, t, rowt) ->
    let (xs, o) = dumpstr_row rowt in (n ^ ": " ^ dumpstr t)::xs, o
  | RowPoly (Record rowt) -> dumpstr_row rowt
  | RowPoly t -> [], Some (dumpstr t)
  | RowMono -> [], None

let genvar s =  Genvar (create_uniq s)