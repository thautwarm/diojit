from jit import prims, dynjit, types, stack, intrinsics
from jit.pe import PE
from jit.call_prims import register_dispatch, NO_SPECIALIZATION


@register_dispatch(intrinsics.i_store, 2)
def spec(self: PE, args, s, p):
    infer = self.infer
    l: dynjit.Abs = args[0]
    r: dynjit.Abs = args[1]
    n = stack.size(s)

    if isinstance(l.type, types.TopT) or not isinstance(
        r.type, types.TypeT
    ):
        return NO_SPECIALIZATION

    val = isinstance(l.type.to_py_type(), r.type.type.to_py_type())
    repr = dynjit.S(val)
    abs_val = dynjit.Abs(repr, types.bool_t)
    s = stack.cons(abs_val, s)
    yield from infer(s, p + 1)
