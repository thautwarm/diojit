open Dynjit.Main
open Dynjit.Pretty
open Dynjit.Common
open Dynjit.Core

let () =
  let fdefs = M_int.bindings @@ parse() in
  flip List.iter fdefs @@  fun (_, s) ->
      print_endline @@ show_func_def s
