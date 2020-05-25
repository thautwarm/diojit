type srcpos = {line: int; col: int; filename: string}

type funcinfo = {
    name : string;
    argnames : string list;
    freevars : string list;
    cellvars: string list;
    boundvars: string list
}

type argtype = Cell | Pos | Kw

type 'a keywords = (string * 'a) list
module type PyExp = sig
    type repr
    val app      : repr (* func *) -> repr list (* postional arguments *) -> repr keywords (* keyword arguments *) -> repr
    val var      : string -> repr
    val assign   : string -> repr -> repr -> repr
    val arg      : argtype -> repr
    val func     : funcinfo -> repr (* closure cells *) -> repr (* function body *) -> repr
    val loc      : srcpos -> repr -> repr
end

let app {M : PyExp} f args kwargs = M.app f args kwargs
let var {M : PyExp} varname = M.var varname
let assign {M : PyExp} varname value body = M.assign varname value body
let arg  {M : PyExp} argtype = M.arg argtype
let func {M: PyExp} fi clos body = M.func fi clos body
let loc {M: PyExp} srcpos inner = M.loc srcpos inner

type pyast =
    | App of pyast * pyast list * pyast keywords
    | Var of string
    | Assign of string * pyast * pyast
    | Arg of argtype
    | Func of funcinfo * pyast * pyast
    | Loc of srcpos * pyast

implicit module PyAST = struct
    type repr = pyast
    let app f a b = App(f, a, b)
    let var n = Var n
    let assign n a b = Assign(n, a, b)
    let arg t = Arg(t)
    let func fi a b = Func(fi, a, b)
    let loc pos a = Loc(pos, a)
end

let example : pyast = app (var "+") [arg Cell] []