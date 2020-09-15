module CoreCPY

type slot = int
type name = string
type varkind =
| Localonly
| Cell
| Free
| Global
type var = {name: name; kind:varkind}

type constant =
| BoolC of bool
| IntC of int
| FloatC of float
| TupleC of constant list
| ListC of constant list
| DictC of (constant, constant) Map

// type blockkind =
// | AnyBlock
// | Except
// | Try

type t =
| Const of constant
| Load of var
| Store of var
| JumpIfTrue of slot
| Call of int
| Rot of int
| Pop
| Dup
| Return
// | PushBlock of blockkind
// | PopBlock of blockkind
// | Unwind