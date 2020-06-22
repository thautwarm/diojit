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
      let main, fdefs = parse filename in
      
      begin
      match main with
      | None -> failwith "no main function found"
      | Some {entry={globals; fn_bounds}; body=body} ->
       let open Pe in
      let pe_state = init_pe_state fdefs in
      let suite, t =
        specialise
          pe_state
          { args=[]
          ; kwargs=[]
          ; meth_bounds=fn_bounds
          ; globals=globals
          }
          body
      in
      print_endline @@ "main returns" ^ show_t t;
      (flip List.iter suite @@ fun x ->
        print_endline @@ show_ir "" x);
      print_newline();
      (flip List.iter (M_int.bindings !(pe_state.meth_defs))
        @@ fun (meth_id, (meth_def, t)) ->
          Printf.printf "method id : %d\n" meth_id;
          Printf.printf "returns : %s\n" @@ show_t t;
          flip List.iter meth_def.body @@ fun ir ->
            print_endline @@ show_ir "" ir
      ) 
      (* flip List.iter fdefs @@  fun (_, s) ->
          print_endline @@ show_func_def s *)
      end
  | args -> 
    print_endline @@ "invalid arguments : " ^ String.concat " " args

let () = main()