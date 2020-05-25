open Class
open Tt

implicit module Show_t = struct
  type t = Tt.t
  let rec show x = dumpstr show x
end

implicit module Show_rowt = struct
  type t = Tt.rowt
  let show x = dumpstr_row (Show_t.show) x
end

let _ = print_endline @@ show (App(Nom "a", Nom ""))

open Core
implicit module Show_funcinfo = struct
    type t = Core.funcinfo
    let show {name; argnames; freevars; cellvars; boundvars} =
        "{" ^ show name ^ 
        "\nargnames: " ^ show argnames  ^
        "\nfreevars:" ^ show freevars ^
        "\ncellvars" ^ show cellvars  ^
        "\nboundvars" ^ show boundvars ^
        "\n}"
end

implicit module Show_argtype = struct
    type t = Core.argtype
    let show = function
        | Cell -> "Cell"
        | Pos -> "Pos"
        | Kw -> "Kw"
end

let _ = print_endline @@ (let f (x: funcinfo) = show x in f) {
        name = "f";
        argnames = ["a"; "c"];
        freevars = ["c"];
        cellvars = ["g"];
        boundvars = ["a"; "c"]
    }


