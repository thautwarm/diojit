from jit import prims, dynjit, types, stack, intrinsics
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.pe import PE
from typing import cast


@register_dispatch(intrinsics.i_getattr, 2)
def spec1(self: PE, args, s, p):
    infer = self.infer
    l: dynjit.AbstractValue = args[0]
    r: dynjit.AbstractValue = args[1]
    n = stack.size(s)
    if r.type is types.str_t and isinstance(r.repr, dynjit.S):
        r_val = cast(str, r.repr.c)
        l_type = l.type
        # print(l_type, '<>', r, r_val in l_type.members, l_type.members)
        if isinstance(l_type, types.NomT):
            if r_val in l_type.members:
                unbound_method = l_type.members[r_val]
                meth_t = types.MethT(l.type, unbound_method.type)
                abs_val = dynjit.AbstractValue(dynjit.D(n), meth_t)
                yield dynjit.Assign(abs_val, dynjit.Call(prims.v_mkmethod, [l, unbound_method], type=meth_t))
                s = stack.cons(abs_val, s)
                yield from infer(s, p + 1)
                return
            elif r_val in l_type.static_members:
                static_method = l_type.static_members[r_val]
                s = stack.cons(static_method, s)
                yield from infer(s, p + 1)
                return
    return NO_SPECIALIZATION

