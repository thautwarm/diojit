type 'a sset = 'a list
let rec add : 'a -> 'a sset -> 'a sset = fun a ->
    function
    | [] -> [a]
    | x::_ as l when a = x -> l
    | x::xs -> x::add a xs

let mem : 'a -> 'a sset -> bool = List.mem