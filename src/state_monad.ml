module MState = struct
    type ('s, 'a) state = {run_state : 's -> ('a * 's)}
    let return a = {run_state = fun s -> (a, s)}
    let (>>=) m k = {run_state = fun s -> let (a, s) = m.run_state s in (k a).run_state s}        
    let (>>) m1 m2 = {run_state = fun s -> let (_, s) = m1.run_state s in m2.run_state s}
    let get = {run_state = fun s -> (s, s)}
    let gets f = {run_state = fun s -> (f s, s)}
    let modify f = {run_state = fun s -> (), f s}
    let put s = {run_state = fun _ -> (), s}
    let forM_ xs k =
        List.fold_left (fun a b -> a >> k b) (return ()) xs >> return ()
    
    let rec forM xs k = 
        match xs with
        | [] -> return []
        | x::xs -> k x >>= fun hd' -> forM xs k >>= fun tl' -> return (hd' :: tl')

    let with_st : ('a, 's) state -> ('a, 's) state = fun m ->
        get >>= fun old ->
        m >>= fun a ->
        put old >> return a

    let run_state {run_state} s = run_state s
end