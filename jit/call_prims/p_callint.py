from jit import prims, dynjit, types, stack, intrinsics
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.pe import PE
from typing import cast
import operator


@register_dispatch(intrinsics.i_asint, 1)
def spec(self: PE, args, s, p):
    infer = self.infer
    a: dynjit.Abs = args[0]
    n = stack.size(s)
    if isinstance(a.repr, dynjit.S):
        repr = dynjit.S(int(cast(int, a.repr.c)))
        typ = types.int_t
        abs_val = dynjit.Abs(repr, typ)
        s = stack.cons(abs_val, s)
        yield from infer(s, p + 1)
    elif a.type is types.int_t:
        s = stack.cons(a, s)
        yield from infer(s, p + 1)
    elif a.type is types.float_t:
        repr = dynjit.D(n)
        abs_val = dynjit.Abs(repr, types.float_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_strunc, [a]))
        s = stack.cons(a, s)
        yield from infer(s, p + 1)
    elif a.type is types.float_t:
        repr = dynjit.D(n)
        abs_val = dynjit.Abs(repr, types.float_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_parseint, [a]))
        s = stack.cons(a, s)
        yield from infer(s, p + 1)
    else:
        return NO_SPECIALIZATION



