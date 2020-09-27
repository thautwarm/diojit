from jit import prims, dynjit, types, stack
from jit.call_prims import NO_SPECIALIZATION
from jit.intrinsics import i_isinstance


def cond(prim_func, args):
    return prim_func is i_isinstance and len(args) == 2


def spec(infer, args, s, p):
    l: dynjit.AbstractValue = args[0]
    r: dynjit.AbstractValue = args[1]
    n = stack.size(s)

    if isinstance(l.type, types.TopT) or not isinstance(r.type, types.TypeT):
        return NO_SPECIALIZATION

    val = isinstance(l.type.to_py_type(), r.type.type.to_py_type())
    repr = dynjit.S(val)
    abs_val = dynjit.AbstractValue(repr, types.bool_t)
    s = stack.cons(abs_val, s)
    yield from infer(s, p + 1)
