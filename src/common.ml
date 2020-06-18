module List = struct
    include List
    let unzip xs =
        let rec go fsts snds = function
            | (x, y)::tl -> go (x::fsts) (y::snds) tl
            | [] -> (List.rev fsts, List.rev snds)
        in go [] [] xs
    
    let rec unwrap_seq = function
        | [] -> []
        | Some x::xs -> x::unwrap_seq xs
        | None::xs -> unwrap_seq xs
    
    let zip xs ys =
        let rec go res xs ys =
            match xs, ys with
            | x::xs, y::ys -> go ((x, y)::res) xs ys
            | [], _ | _, [] -> List.rev res
        in go [] xs ys
end


module Array = struct
    include Array
    let update i e xs =
        let xs = Array.copy xs in
        xs.(i) <- e; xs
end

let flip f x y = f y x

let rec sequence : 'a list list -> 'a list list =
    function
    | [g] -> flip List.map g (fun x -> [x])
    | g1::gs ->
        let tls = sequence gs in
        List.concat @@
        flip List.map tls @@ fun tl ->
            flip List.map g1 @@ flip List.cons tl
    | [] -> []