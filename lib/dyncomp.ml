(**
   this is based on https://github.com/stedolan/linkage
   whose author is Stephen Dolan(mu@netsoc.tcd.ie, https://github.com/stedolan)
 *)
type ('a, 'b) result = Ok of 'a | Error of 'b
type plugin = ..

exception Loaded of string * plugin

let provide p =
  raise (Loaded 
    ("This module is a plugin, and should not be run directly", p))


type error =
| Dynlink_error of Dynlink.error
| Not_a_linkage_plugin
| Wrong_plugin_type of plugin


let load s =
  let s =
    if Filename.check_suffix s ".cma" ||
       Filename.check_suffix s ".cmo" then
      Dynlink.adapt_filename s
    else
      s in
  match Dynlink.loadfile_private s with
  | () ->
     Error Not_a_linkage_plugin
  | exception (Loaded (_, p)) ->
     Ok p
  | exception Dynlink.Error e ->
     Error (Dynlink_error e)

(* By putting a string in the exception, the default
   exception printer will do a better job *)
exception Error of string * error

let raise_error r =
  let err = match r with
    | Ok p ->
       Wrong_plugin_type p
    | Error e ->
       e in
  let text = match err with
    | Dynlink_error e -> Dynlink.error_message e
    | Not_a_linkage_plugin -> "Not a Linkage plugin"
    | Wrong_plugin_type p ->
       "Wrong plugin type " ^
       Obj.(extension_name (extension_slot p)) in
  raise (Error (text, err))
