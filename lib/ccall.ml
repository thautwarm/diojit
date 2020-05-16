type pyo
type load = int64
type i32
type b32
type start_sym
external mkint : int -> i32 = "mkint" [@@noalloc]

external _mkint_start_sym : int -> start_sym = "mkint" [@@noalloc]

let cPy_single_input = _mkint_start_sym 256
let cPy_file_input = _mkint_start_sym 257
let cPy_eval_input = _mkint_start_sym 258

external cPyRun_String : string -> start_sym -> pyo -> pyo -> pyo =  "PyRun_String" [@@noalloc]
external cPyObject_CallObject : pyo -> pyo -> unit = "PyObject_CallObject" [@@noalloc]
external cPyDict_New : unit -> pyo = "PyDict_New" [@@noalloc]
external cPyErr_Clear : unit -> unit = "PyErr_Clear" [@@noalloc]
external cPyErr_Print : unit -> unit = "PyErr_Print" [@@noalloc]
external cPyErr_SyntaxLocationEx : string -> i32 -> i32 -> unit = "PyErr_SyntaxLocationEx" [@@noalloc]
external cPyErr_SyntaxLocation : string -> i32 -> unit = "PyErr_SyntaxLocation" [@@noalloc]
external cPyErr_Occurred : unit -> pyo = "PyErr_Occurred" [@@noalloc]
external cPyErr_ExceptionMatches : pyo -> b32 = "PyErr_ExceptionMatches" [@@noalloc]
external cPyErr_GivenExceptionMatches : pyo -> pyo -> b32 = "PyErr_GivenExceptionMatches" [@@noalloc]

external cPyEval_EvalCode : pyo -> pyo -> pyo -> pyo = "PyEval_EvalCode" [@@noalloc]
external cPy_Initialize : unit -> unit = "Py_Initialize" [@@noalloc]
external cPy_CompileString : string -> string -> start_sym -> pyo = "Py_CompileString"
external cPyEval_GetBuiltins : unit -> pyo = "PyEval_GetBuiltins" [@@noalloc]

let _is_initialzed = ref false
type pyhelpers = {
    none : pyo;
    builtins : pyo;
  }

let _pyhelpers : pyhelpers ref = ref (Obj.magic 0)

module Py() = struct
  let helpers : pyhelpers =
    if !_is_initialzed then begin
        !_pyhelpers
      end
    else 
      let _ = cPy_Initialize() in
      let _ = (_is_initialzed := true) in
      let tb = cPyEval_GetBuiltins() in  (* temporary builtins *)
      let eval_expr code = cPyRun_String code cPy_eval_input tb tb in
      _pyhelpers := {
          none = eval_expr "None";
          builtins = eval_expr "__import__('builtins').__dict__"
        };
      !_pyhelpers
end
                      

let main() =
  let module Py = Py() in
  let _ = cPyErr_Print() in
  let c = cPy_CompileString "print('good')" "a.py" cPy_file_input in
  let _ = cPyEval_EvalCode c Py.helpers.builtins Py.helpers.builtins in
  cPyErr_Print()
