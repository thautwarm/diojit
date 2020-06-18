open Dynjit.Common
let () =
  flip List.iter [1; 2] @@ print_int;
  print_endline "a"
