from jit import prims, dynjit, types, stack
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.pe import PE
import operator


@register_dispatch(operator.add, 2)
def spec(self: PE, args, s, p):
    l: dynjit.AbstractValue = args[0]
    r: dynjit.AbstractValue = args[1]
    n = stack.size(s)
    repr = dynjit.D(n)

    if l.type is types.int_t and r.type is types.int_t:
        abs_val = dynjit.AbstractValue(repr, types.int_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_iadd, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    elif l.type is types.float_t and r.type is types.float_t:
        abs_val = dynjit.AbstractValue(repr, types.float_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_fadd, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    elif l.type is types.int_t and r.type is types.float_t:
        abs_val = dynjit.AbstractValue(repr, types.float_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_fadd, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    elif l.type is types.float_t and r.type is types.int_t:
        yield from spec(self, [r, l], s, p)
    elif l.type is types.str_t and r.type is types.str_t:
        abs_val = dynjit.AbstractValue(repr, types.str_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_sconcat, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    else:
        return NO_SPECIALIZATION
