type 'a scoped = int * 'a
let scope_of : 'a scoped -> int = fun (a, _) -> a
let unwrap_scope : 'a scoped -> 'a = fun (_, a) -> a

type label = string scoped

type var = string scoped
type instrinsic =
| IsInstanceOf
| TypeOf
| BuildTuple
| Upcast
| Downcast
| PolyAdd
| IntIntAdd
| FloatFloatAdd
| IntFloatAdd
| PolyEq


type const =
| NoneL
| UndefL
| IntL of int
| BoolL of bool
| FloatL of float
| StrL of string (* becomes char array after prototyping *)
| TupleL of const list
| IntrinsicL of instrinsic
| FPtrL of fptr
| MethL of int
| TypeL of t

and t =
| ClosureT of t * int (* function number *)
| TupleT of t list
| TypeT of t
| CellT of t
| NomT of string
| UnionT of t list
| FPtrT of fptr (* object type number *)
| MethT of int
| IntrinsicT of instrinsic
| TopT
| BottomT
| NoneT

and fptr = int

type repr = S of const | D of var
type value = {typ: t; value: repr}

type instr =
| GotoIf : repr * label * label -> instr
| Goto   : label -> instr
| Assign : var * repr -> instr
| Return : repr -> instr
| Call   : var option (* bound to *) *
           repr (* func *) *
           repr list (* args *) *
           (string * repr) list (* kwargs *)
           -> instr

type ir_expr =
| Ir_s of value
| Ir_call of ir_expr * ir_expr list * (string * ir_expr) list

type ir =
| Ir_switch     of ir_expr * (t * ir) list (* todo: default branch? *)
| Ir_if         of ir_expr * ir * ir
| Ir_gotoif     of ir_expr * label * label
| Ir_goto       of label 
| Ir_assign     of var * ir_expr
| Ir_return     of ir_expr
| Ir_do         of ir_expr
| Ir_label      of label
| Ir_block      of ir list

type basic_block = {
    suite: instr list;
    phi : (label, (var, var) Smap.smap) Smap.smap
}

type basic_blocks = (label, basic_block) Smap.smap

type config = label * value array
module M_state = Map.Make(struct
    type t = config
    let compare = compare
end)

module M_int = Map.Make(Int)

type fn_entry
    = { args : var list
      ; kwargs : var list
      ; globals : (var, t) Smap.smap
      ; fn_bounds : var list
      }

type ('entry, 'body) def = {
    entry : 'entry;
    body : 'body
}

type meth_entry
    = { args : (var, t) Smap.smap
      ; kwargs : (var, t) Smap.smap
      ; globals : (var, t) Smap.smap
      ; meth_bounds : var list
      }

module M_func_entry = Map.Make(struct
    type t = (fptr * meth_entry)
    let compare = compare
end)

(* todo: to avoid infinite configutions, add a set of reached labels*)
type pe_state = {
    (* global states *)
    meth_refs : int M_func_entry.t ref;
    meth_defs : ((meth_entry, ir list) def * t) M_int.t ref;
    
    mutable out_bbs : (label * ir Darray.darray) M_state.t;
    mutable lbl_count : int;
    mutable meth_count : int;
    mutable ret: t;

    (* local states *)
    mutable slots : value array;
    mutable reached : label Sset.sset;
    mutable cur_block : ir Darray.darray;
    mutable cur_lbl : label;
    
    (* immutable info *)
    n2i : (var, int) Smap.smap;
    i2f : (fn_entry, basic_blocks) def M_int.t;
    scope_level : int; (* for inline use *)

}


let entry_label = (0, "entry")

type meth_def = (meth_entry, ir list) def
type fn_def = (fn_entry, basic_blocks) def

let ieval : instrinsic -> value = fun i ->
  {typ = IntrinsicT i; value = S (IntrinsicL i)}

let teval : t -> value = fun t ->
  {typ = TypeT t; value = S (TypeL t)}