let f x = string_of_int x ^ "oo"                                                                          
external id : 'a -> 'b = "%identity"                                                                      
let _ = Dynjit.Linkage.provide (id f)
