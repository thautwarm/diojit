(* open Dynjit
module Core = Core
(* let (raise_error, load) = Linkage.(raise_error, load)
external id : 'a -> 'b = "%identity"

let f =
    match load "../../../test/ddd.cma" with
    | Ok f -> let f : int -> string = id f in f
    | e -> raise_error e

let _ = print_endline @@ f 1 *)

let _ =
    let module TC = (val Infer.tcstate(Darray.empty())) in
    let open TC in
    let open Tt in
    let open Class in
    let open Instances in
    let i32 = new_type "int32" in
    let v = new_tvar() in
    let a1 = Forall(["a"], Tuple[i32; Fresh "a"]) in
    let a2 = Forall(["b"], Tuple[v; Fresh "b"]) in
    assert (unify a1 a2);
    let v = prune v in
    print_endline "\nshall be int32:";
    print_endline @@ show v

let _ =
    let module TC = (val Infer.tcstate(Darray.empty())) in
    let open TC in
    let open Tt in
    let open Class in
    let open Instances in
    let i32 = new_type "int32" in
    let v = new_tvar() in
    let a1 = Forall(["a"], Tuple[i32; Fresh "a"]) in
    let a2 = Forall(["c"], Tuple[v; Fresh "b"]) in
    assert (not @@ unify a1 a2)

let _ =
    let module TC = (val Infer.tcstate(Darray.empty())) in
    let open TC in
    let open Tt in
    let open Class in
    let open Instances in
    let i32 = new_type "int32" in
    let a = new_tvar() in
    let b = new_tvar() in
    let is_ok = unify (Tuple [a; a]) (Tuple [i32; b]) in
    assert (is_ok && prune a = i32 && prune b = i32);
    let rho = new_tvar() in
    let record1 = Record(record ["f1", i32] (RowPoly rho)) in
    let record2 = Record(record ["f2", i32; "f1", a] RowMono) in
    let is_ok = unify record1 record2 in
    assert is_ok;
    let rho = prune rho in
    print_endline "\nfield f shall be int32:";
    print_endline @@ show rho;
    assert begin
    match rho with
    | Record rowt -> begin
        match extract_row rowt with
        | fields, None ->
            Smap.mem "f2" fields && Smap.len fields = 1
        | _ -> false
        end
    | _ -> false
    end *)