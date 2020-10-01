from jit import prims, dynjit, types, stack, intrinsics
from jit.call_prims import register_dispatch
from jit.pe import PE


@register_dispatch(intrinsics.i_buildlist, None)
def spec(self: PE, args, s, p):
    ret_t = types.list_t
    n = stack.size(s)
    a_dyn = dynjit.AbstractValue(dynjit.D(n), ret_t)
    s_new = stack.cons(a_dyn, s)
    yield dynjit.Assign(a_dyn, dynjit.Call(prims.v_buildlist, args))
    yield from self.infer(s_new, p + 1)


@register_dispatch(list.append, 2)
def spec(self: PE, args, s, p):
    n = stack.size(s)
    a_dyn = dynjit.AbstractValue(dynjit.D(n), types.none_t)
    s_new = stack.cons(a_dyn, s)
    yield dynjit.Assign(a_dyn, dynjit.Call(prims.v_listappend, args))
    yield from self.infer(s_new, p + 1)
