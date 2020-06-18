type 'a scoped = int * 'a
let scope_of : 'a scoped -> int = fun (a, _) -> a
let unwrap_scope : 'a scoped -> 'a = fun (_, a) -> a

type label = string scoped

type var = string scoped
type instrinsic = Make_closure 
                | Make_cell
                | Deref
                | IsTypeOf
                | TypeOf
                | BoolOr
                | Upcast    (* has effect *)
                | Downcast  (* has effect if return true *)
type const =
| NoneL
| UndefL
| IntL of int
| BoolL of bool
| FloatL of float
| StrL of string (* becomes char array after prototyping *)
| TupleL of const list
| InstrinsicL of instrinsic
| TypeL of t

and t =
| ClosureT of t * int (* function number *)
| TupleT of t list
| TypeT of t
| CellT of t
| NomT of string
| NoneT
| RecordT of (string, t) Smap.smap
| UnionT of t list
| ObjectT of int (* object type number *)
| IntrinsicT of instrinsic
| TopT
| BottomT

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
| Ir_switch     of ir_expr * (const * ir) list (* todo: default branch? *)
| Ir_if         of ir_expr * ir * ir
| Ir_gotoif     of ir_expr * label * label
| Ir_goto       of label 
| Ir_assign     of var * ir_expr
| Ir_return     of ir_expr
| Ir_label      of label
| Ir_block      of ir list
| Ir_unreachable

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

(* todo: to avoid infinite configutions, add a set of reached labels*)
type pe_state = {
    (* global states *)
    mutable out_bbs : (label * ir Darray.darray) M_state.t;
    mutable lbl_count : int;
    mutable ret: t;

    (* local states *)
    mutable slots : value array;
    mutable reached : label Sset.sset;
    mutable cur_block : ir Darray.darray;
    mutable cur_lbl : label;
    
    (* immutable info *)
    n2i : (var, int) Smap.smap;
    i2f : func_def M_int.t;
    scope_level : int; (* for inline use *)

}

and func_entry = {
    args : (var, t) Smap.smap;
    kwargs : (var, t) Smap.smap;
    closure : (var, t) Smap.smap;

    other_bounds : (var, t) Smap.smap; (* shall be all undefined *)
}

and func_def = {
    func_entry : func_entry;
    body : basic_blocks
}

let entry_label = (0, "entry")