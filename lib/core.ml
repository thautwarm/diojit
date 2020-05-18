type srcpos = {line: int; col: int; filename: string}
type funcinfo = {
    name : string;
    argnames : string list;
    freevars : string list;
    cellvars: string list;
    boundvars: string list
}

type argtype = Cell | Pos | Kw
module type PyExp = sig
    type repr
    val app      : repr (* func *) -> repr (* postional arguments *) -> repr (* keyword arguments *) -> repr
    val var      : string -> repr
    val assign   : string -> repr -> repr -> repr
    val cells    : repr
    val arg      : argtype -> repr
    val func     : funcinfo -> repr (* closure cells *) -> repr (* function body *) -> repr
    val loc      : srcpos -> repr -> repr
end

let app {M : PyExp} f args kwargs = M.app f args kwargs
let var {M : PyExp} varname = M.var varname
let assign {M : PyExp} varname value body = M.assign varname value body
let arg  {M : PyExp} argtype = M.arg argtype
let func {M: PyExp} fi clos body = M.func fi clos body



