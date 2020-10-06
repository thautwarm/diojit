from jit import prims, dynjit, types, stack
from jit.intrinsics import i_isinstance
from jit.call_prims import register_dispatch
from jit.pe import PE


@register_dispatch(i_isinstance, 0)
def spec(self: PE, _, s, p):
    s = stack.cons(self.glob_val, s)
    return (yield from self.infer(s, p + 1))