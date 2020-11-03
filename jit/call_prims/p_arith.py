from jit import prims, dynjit, types, stack
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.pe import PE
import operator

from jit.prims import mk_v_const_sym


@register_dispatch(operator.sub, 2)
def spec_sub(self: PE, args, s, p):
    l: dynjit.Abs = args[0]
    r: dynjit.Abs = args[1]
    n = stack.size(s)
    repr = dynjit.D(n)

    if l.type is types.int_t and r.type is types.int_t:
        abs_val = dynjit.Abs(repr, types.int_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_isub, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    elif l.type is types.float_t and r.type is types.float_t:
        abs_val = dynjit.Abs(repr, types.float_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_fsub, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    elif l.type is types.int_t and r.type is types.float_t:
        abs_val = dynjit.Abs(repr, types.float_t)
        yield dynjit.Assign(abs_val, prims.v_fsub(prims.v_i2f(l), r))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    elif r.type is types.int_t and l.type is types.float_t:
        abs_val = dynjit.Abs(repr, types.float_t)
        yield dynjit.Assign(abs_val, prims.v_fsub(l, prims.v_i2f(r)))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    else:
        # TODO: __sub__, __rsub__
        abs_val = dynjit.Abs(repr, types.TopT())
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_sub, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)


@register_dispatch(operator.add, 2)
def spec_add(self: PE, args, s, p):
    l: dynjit.Abs = args[0]
    r: dynjit.Abs = args[1]
    n = stack.size(s)
    repr = dynjit.D(n)

    if l.type is types.int_t and r.type is types.int_t:
        abs_val = dynjit.Abs(repr, types.int_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_iadd, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    elif l.type is types.float_t and r.type is types.float_t:
        abs_val = dynjit.Abs(repr, types.float_t)
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_fadd, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    elif l.type is types.int_t and r.type is types.float_t:
        abs_val = dynjit.Abs(repr, types.float_t)
        yield dynjit.Assign(abs_val, prims.v_fadd(prims.v_i2f(l), r))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    elif l.type is types.float_t and r.type is types.int_t:
        abs_val = dynjit.Abs(repr, types.float_t)
        yield dynjit.Assign(abs_val, prims.v_fadd(l, prims.v_i2f(r)))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)

    elif l.type is types.str_t and r.type is types.str_t:
        abs_val = dynjit.Abs(repr, types.str_t)
        yield dynjit.Assign(
            abs_val, dynjit.Call(prims.v_sconcat, [l, r])
        )
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
    else:
        # TODO: __add__, __radd__
        abs_val = dynjit.Abs(repr, types.TopT())
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_add, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)


@register_dispatch(operator.lt, 2)
def spec_lt(self: PE, args, s, p):
    l: dynjit.Abs = args[0]
    r: dynjit.Abs = args[1]
    n = stack.size(s)
    repr = dynjit.D(n)
    lt_flag = mk_v_const_sym("Py_LT")
    lt_func = operator.lt

    def constexpr(s):
        abs_val = dynjit.Abs(
            dynjit.S(lt_func(l.repr.c, r.repr.c)), types.bool_t
        )
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)

    if l.type is types.int_t and r.type is types.int_t:
        if isinstance(l.repr, dynjit.S) and isinstance(
            r.repr, dynjit.S
        ):
            yield from constexpr(s)
        else:
            abs_val = dynjit.Abs(repr, types.bool_t)
            yield dynjit.Assign(
                abs_val, dynjit.Call(prims.v_irichcmp, [l, r, lt_flag])
            )
            s = stack.cons(abs_val, s)
            yield from self.infer(s, p + 1)
    elif l.type is types.float_t and r.type is types.float_t:
        if isinstance(l.repr, dynjit.S) and isinstance(
            r.repr, dynjit.S
        ):
            yield from constexpr(s)
        else:
            abs_val = dynjit.Abs(repr, types.bool_t)
            yield dynjit.Assign(
                abs_val, dynjit.Call(prims.v_frichcmp, [l, r, lt_flag])
            )
            s = stack.cons(abs_val, s)
            yield from self.infer(s, p + 1)
    elif l.type is types.float_t and r.type is types.int_t:
        if isinstance(l.repr, dynjit.S) and isinstance(
            r.repr, dynjit.S
        ):
            yield from constexpr(s)
        else:
            abs_val = dynjit.Abs(repr, types.bool_t)
            yield dynjit.Assign(
                abs_val,
                dynjit.Call(
                    prims.v_frichcmp,
                    [l, (prims.v_i2f, [r]), lt_flag],
                ),
            )
            s = stack.cons(abs_val, s)
            yield from self.infer(s, p + 1)
    elif l.type is types.int_t and r.type is types.float_t:
        if isinstance(l.repr, dynjit.S) and isinstance(
            r.repr, dynjit.S
        ):
            yield from constexpr(s)
        else:
            abs_val = dynjit.Abs(repr, types.bool_t)
            yield dynjit.Assign(
                abs_val,
                dynjit.Call(
                    prims.v_frichcmp,
                    [dynjit.Call(prims.v_i2f, [l]), r, lt_flag],
                ),
            )
            s = stack.cons(abs_val, s)
            yield from self.infer(s, p + 1)
    elif l.type is types.str_t and r.type is types.str_t:
        if isinstance(l.repr, dynjit.S) and isinstance(
            r.repr, dynjit.S
        ):
            yield from constexpr(s)
        else:
            abs_val = dynjit.Abs(repr, types.bool_t)
            yield dynjit.Assign(
                abs_val, dynjit.Call(prims.v_srichcmp, [l, r, lt_flag])
            )
            s = stack.cons(abs_val, s)
            yield from self.infer(s, p + 1)
    else:
        # TODO: __lt__
        abs_val = dynjit.Abs(repr, types.TopT())
        yield dynjit.Assign(abs_val, dynjit.Call(prims.v_lt, [l, r]))
        s = stack.cons(abs_val, s)
        yield from self.infer(s, p + 1)
