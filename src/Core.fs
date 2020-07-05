module DynJIT.Core

type addr (* address *) = int
type intrinsic =
| IsInstance
| Upcast
| Downcast

and t =
| TNom of addr
| TTuple of t list
| TUnion of t list
| TFPtr of addr
| TMeth of addr
| TIntr of intrinsic
| TTop
| TBot
| TNone