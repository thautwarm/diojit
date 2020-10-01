from jit import prims, dynjit, types, stack, intrinsics
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.pe import PE
from typing import cast


@register_dispatch(intrinsics.i_getitem, 2)
def spec(self: PE, args, s, p):
    infer = self.infer
    l: dynjit.AbstractValue = args[0]
    r: dynjit.AbstractValue = args[1]

    if isinstance(l.type, types.RecordT) and r.type is types.str_t:
        if isinstance(l.repr, dynjit.S) and isinstance(
            r.repr, dynjit.S
        ):

            dictionary = cast(dict, l.repr.c)
            fix_keys = l.type.fix
            key = cast(str, r.repr.c)
            if key not in fix_keys:
                # TODO: insert raise exception in runtime
                raise KeyError(key)
            repr = dynjit.S(dictionary[key])
            typ = fix_keys[key]
            abs_val = dynjit.AbstractValue(repr, typ)
            s = stack.cons(abs_val, s)
            yield from infer(s, p + 1)
            return
    elif isinstance(l.type, types.TupleT) and r.type is types.int_t:
        if isinstance(l.repr, dynjit.S) and isinstance(
            r.repr, dynjit.S
        ):
            i = cast(int, r.repr.c)
            repr = cast(tuple, l.repr.c)[i]
            typ = l.type.xs[i]
            abs_val = dynjit.AbstractValue(repr, typ)
            s = stack.cons(abs_val, s)
            yield from infer(s, p + 1)
            return
        else:
            # TODO: tuple split for n < THRESHOLD
            # e.g.:
            # xs: (t1, t2, t3), i: int
            # xs[i] : t1 | t2 | t3
            n = stack.size(s)
            repr = dynjit.D(n)
            abs_val = dynjit.AbstractValue(repr, types.TopT())
            yield dynjit.Assign(
                abs_val, dynjit.Call(prims.v_tupleget, [l, r])
            )
            s = stack.cons(abs_val, s)
            yield from infer(s, p + 1)
            return

    return NO_SPECIALIZATION
