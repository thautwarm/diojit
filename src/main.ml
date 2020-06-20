open Parser
open Lexer
open Printf
open Lexing
let print_position outx lexbuf =
  let pos = lexbuf.lex_curr_p in
  fprintf outx "%s:%d:%d" pos.pos_fname
    pos.pos_lnum (pos.pos_cnum - pos.pos_bol + 1)

let run_parser lexbuf =
    prog read lexbuf
    (* fprintf stderr "%a: syntax error\n" print_position lexbuf;
    raise e *)

let parse filename =
  let buf = Lexing.from_string @@ Node.Fs.readFileAsUtf8Sync filename in
  run_parser buf

open Core
open Common
open Pretty

let main() =
  match Array.to_list Sys.argv with
  | [_; _; filename] ->
      let fdefs = parse filename in 
      let main_def = M_int.find 0 fdefs in
      let open Pe in
      let bbs = M_state.bindings (specialise main_def fdefs).out_bbs in
      flip List.iter bbs @@ fun (_, xs) ->
        Array.iter
          (fun x -> print_endline @@ show_ir "" x)
          (Darray.to_array @@ snd xs)
      (* flip List.iter fdefs @@  fun (_, s) ->
          print_endline @@ show_func_def s *)
  | args -> 
    print_endline @@ "invalid arguments : " ^ String.concat " " args

let () = main()