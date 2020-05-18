let (raise_error, load) = Dynjit.Linkage.(raise_error, load)
external id : 'a -> 'b = "%identity"

let f =
    match load "../../../test/ddd.cma" with
    | Ok f -> let f : int -> string = id f in f
    | e -> raise_error e

let _ = print_endline @@ f 1


