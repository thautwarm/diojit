from jit import prims, dynjit, types, stack
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.pe import PE
from jit.ll.closure import Closure


@register_dispatch(Closure, 2)
def spec(self: PE, args, s, p):
    l: dynjit.Abs = args[0]
    r: dynjit.Abs = args[1]
    n = stack.size(s)
    repr = dynjit.D(n)
    ret_t = types.ClosureT(l.type, r.type)
    abs_val = dynjit.Abs(repr, ret_t)
    s = stack.cons(abs_val, s)
    yield dynjit.Assign(abs_val, dynjit.Call(prims.v_closure, [l, r]))
    yield from self.infer(s, p + 1)
