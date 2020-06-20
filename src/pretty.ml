open Core
open Common

let show_sym (_, n) = n

let show_repr = function
  | D (_, n) -> n
  | S (IntL i) -> string_of_int i
  | S (FloatL f) -> string_of_float f
  | S (StrL s) -> "str[" ^ s ^ "]"
  | S (BoolL true) -> "true"
  | S (BoolL false) -> "false"
  | S _ -> "<unsupported>"

let show_instr =
  function
  | Call(None, f, args, []) ->
      "call " ^ show_repr f ^
         "(" ^
            String.concat "," (List.map show_repr args) ^
          ")"
  | Call(Some (_, n), f, args, []) ->
    n ^ " = " ^
    "call " ^ show_repr f ^
         "(" ^
            String.concat "," (List.map show_repr args) ^
          ")"
  | Assign((_, n), r) ->
      n ^ " = " ^ show_repr r
  | GotoIf(r, (_, t), (_, f)) ->
      "if " ^ show_repr r ^ " goto " ^ t ^ " goto " ^ f
  | Goto((0, l)) ->
      "goto " ^ l
  | Return r ->
      "return " ^ show_repr r
  | _ -> "<unsupported>"
  
let show_phi : (label * (var * var) list) list -> string =  function
    | [] -> ""
    | xs ->
      "\n " ^
    let rec show_phi_each_source : (var * var) list -> string list = function
      | [] -> []
      | ((_, target), (_, from))::tl ->
          ("  " ^ target ^ " <- " ^ from ) :: show_phi_each_source tl
    in
    let content =
      String.concat "\n|" @@ flip List.map xs @@ fun ((_, from_lbl), source) ->
        from_lbl ^ ":\n" ^
        String.concat ",\n" (show_phi_each_source source)
    in content ^ "\n"

let show_bb ((_, l), {suite; phi}) =
    "LABEL " ^ l ^ ":\n" ^
    "PHI [" ^
    show_phi phi ^
    "]\n" ^
    String.concat ";\n" (List.map show_instr suite)

            
let rec show_t = function
  | NomT s -> "@" ^ s
  | TypeT t -> "type[" ^ show_t t ^ "]"
  | UnionT ts -> "(" ^ String.concat " | " (List.map show_t ts) ^ ")"
  | BottomT -> "bot"
  | TopT -> "top"
  | FPtrT i -> "fptr[" ^ string_of_int i ^ "]"
  | _ -> failwith "TODO"

let show_ann ((_, n), t) = n ^ ": " ^ show_t t

let show_func_def {func_entry={args; globals; other_bounds; _}; body=body} =
    let body = String.concat "\n" @@ List.map show_bb body in
    let args = String.concat ", " @@ List.map show_ann args in
    let globals = String.concat ", " @@ List.map show_ann globals in
    let bounds  = String.concat ", " @@ List.map show_ann other_bounds in
    "func (" ^ args ^ ")\n" ^
    "bound [" ^ bounds ^ "]\n" ^
    "global [" ^ globals ^ "]\n" ^
    body

let rec show_ir_repr = function
  | Ir_s v -> show_repr v.value ^ ": " ^ show_t v.typ
  | Ir_call(func, args, []) ->
    show_ir_repr func ^
      "(" ^ 
        String.concat ", " (List.map show_ir_repr args) ^
      ")"
  | _ -> failwith "TODO"


let incr_ind x = x ^ "  "
let rec show_ir indent_prefix ir =
  indent_prefix ^
  match ir with
  | Ir_switch(v, cases) ->
    "switch " ^ show_ir_repr v ^ "\n" ^
    String.concat "\n" (List.map (show_ir_case @@ incr_ind indent_prefix) cases)
  | Ir_if(cond, t, f) ->
    let indent_prefix' = incr_ind indent_prefix in
    "if " ^ show_ir_repr cond ^ "\n" ^
    show_ir indent_prefix' t ^ "\n" ^
    show_ir indent_prefix' f
  | Ir_gotoif(cond, t, f) ->
    Printf.sprintf "if %s goto %s goto %s"
                   (show_ir_repr cond)
                   (show_sym t)
                   (show_sym f)
  | Ir_goto l ->
    Printf.sprintf "goto %s" (show_sym l)
  | Ir_label l ->
    Printf.sprintf "label %s:" (show_sym l)
  | Ir_assign(target, from) ->
    Printf.sprintf "%s = %s"
                   (show_sym target)
                   (show_ir_repr from)
  | Ir_return r ->
    Printf.sprintf "return %s" (show_ir_repr r)
  | Ir_block suite ->
      let xs = List.map (show_ir @@ incr_ind indent_prefix) suite in
      "block:\n" ^ String.concat "\n" xs
  | Ir_unreachable -> "unreachable"
and show_ir_case indent_prefix = fun (t, v) ->
  indent_prefix ^ show_t t ^ ":\n" ^
  show_ir (indent_prefix ^ "  ") v
