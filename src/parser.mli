
(* The type of tokens. *)

type token = 
  | XOR
  | TYPE
  | TRUE
  | STRING of (string)
  | SEMICOLON
  | RP
  | RETURN
  | RB
  | PHI
  | NEG
  | MOVE
  | LP
  | LB
  | LABEL
  | ISA
  | INT of (int)
  | IF
  | ID of (Core.var)
  | GOTO
  | FLOAT of (float)
  | FED
  | FALSE
  | EOF
  | DEF
  | COMMA
  | COLON
  | CALL
  | BOUND
  | AT
  | ASSIGN
  | ADD

(* This exception is raised by the monolithic API functions. *)

exception Error

(* The monolithic API. *)

val prog: (Lexing.lexbuf -> token) -> Lexing.lexbuf -> (Core.fn_def option * (Core.fn_def Core.M_int.t))
