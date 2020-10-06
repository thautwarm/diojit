from jit import prims, dynjit, types, stack
from jit.intrinsics import i_isinstance
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.pe import PE
from typing import cast


@register_dispatch(i_isinstance, 2)
def spec(self: PE, args, s, p):
    infer = self.infer
    l: dynjit.AbstractValue = args[0]
    r: dynjit.AbstractValue = args[1]
    if isinstance(l.type, types.TopT):
        return NO_SPECIALIZATION
    elif r.type is not types.type_t:

        return NO_SPECIALIZATION
    elif not isinstance(r.repr, dynjit.S):
        return NO_SPECIALIZATION
    val = issubclass(l.type.to_py_type(), cast(type, r.repr.c))
    repr = dynjit.S(val)
    abs_val = dynjit.AbstractValue(repr, types.bool_t)
    s = stack.cons(abs_val, s)
    yield from infer(s, p + 1)
