module type Show = sig
    type t
    val show : t -> string
end

let show {S: Show} (value: S.t) = S.show value

implicit module Show_int = struct
    type t = int
    let show = string_of_int
end

(** TODO: escape string *)
implicit module Show_string = struct
    type t = string
    let show x = x
end

implicit module Show_bool = struct
    type t = bool
    let show = function
        | true -> "true"
        | false -> "false"
end

implicit module Show_float = struct
    type t = string
    let show = string_of_float
end

implicit module Show_list {Show_a: Show} = struct
    type t = Show_a.t list
    let show xs = "[" ^ String.concat "," (List.map Show_a.show xs) ^ "]"
end

module type Eq = sig
    type t
    val equal : t -> t -> bool
end