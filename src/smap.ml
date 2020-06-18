type ('a, 'b) smap = ('a * 'b) list

let find = List.assoc

(* before 4.05 *)
let rec find_opt key = function
    | (a, b)::_ when a = key -> Some b
    | _::xs -> find_opt key xs
    | _ -> None

let find_default a key map =
    match find_opt key map with
    | Some a -> a
    | _ -> a

let mem = List.mem_assoc

let remove = List.remove_assoc

let add : 'k -> 'v -> ('k, 'v) smap -> ('k, 'v) smap = fun k v xs ->
    (k, v) :: xs

let empty = []

let diffkeys : ('a, 'b) smap  -> ('a, 'c) smap -> ('a, 'b) smap = fun xs1 xs2 ->
    let pred (e, _) = not @@ List.mem_assoc e xs2 in
    List.filter pred xs1

let intersect : ('b -> 'c -> 'd) -> ('a, 'b) smap  -> ('a, 'c) smap -> ('a, 'd) smap = fun f xs1 xs2 ->
    List.fold_right (
        fun (ak, av) b ->
        match find_opt ak xs2 with
        | Some v' -> (ak, f av v')::b
        | _ -> b
     ) xs1 []

let is_empty xs = (xs = [])

let len = List.length

let rec map f =
    function
    | [] -> []
    | (k, v) :: tl -> (k, f v):: map f tl
