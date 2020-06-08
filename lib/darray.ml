exception IndexExceeded of int
exception GrowShorter
exception AccessingEmptyList

let exp n = 1 + n lsl 2
type 't darray = {mutable data: 't array; mutable len: int}
let from_array xs = {data = xs; len = Array.length xs}

let make n elt = {data=Array.make n elt; len = n}
let len {len; _} = len
let empty () : 'a darray = make 0 (Obj.magic 0)
let update i elt darray =
    if i < darray.len then
        Array.unsafe_set darray.data i elt
    else
        raise @@ IndexExceeded i
let get i darray =
    if i < darray.len then darray.data.(i)
    else raise @@ IndexExceeded i

let grow darray n =
    if darray.len > n then raise GrowShorter
    else
    let data = Array.make (exp n) (Obj.magic 0) in
    begin
        for ith = 0 to n-1 do
        Array.unsafe_set data ith @@
        Array.unsafe_get darray.data ith
        done;
        darray.data <- data
    end

let append darray elt =
    let len = darray.len in
    begin if len >= Array.length darray.data then
        grow darray len
    else
        ()
    end;
    darray.len <- len + 1;
    Array.unsafe_set darray.data len elt

let pop darray =
    if darray.len <= 1 then
        raise @@ AccessingEmptyList 
    else
        darray.len <- darray.len - 1
