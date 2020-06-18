open Dynjit.Parser
open Dynjit.Lexer
open Printf
open Lexing

let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let run_parser lexbuf =
  try
    prog read lexbuf
  with
  | Error ->
    fprintf stderr "%a: syntax error\n" print_position lexbuf;
    exit @@ -1

let parse() =
  let buf = Lexing.from_channel stdin in
  run_parser buf
