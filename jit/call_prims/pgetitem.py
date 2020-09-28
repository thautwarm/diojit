from jit import prims, dynjit, types, stack, intrinsics
from jit.call_prims import NO_SPECIALIZATION
from typing import cast
import operator


def cond(prim_func, args):
    return prim_func is intrinsics.i_getitem and len(args) == 2


def spec(infer, args, s, p):
    l: dynjit.AbstractValue = args[0]
    r: dynjit.AbstractValue = args[1]
    n = stack.size(s)

    if isinstance(l.type, types.RecordT) and r.type is types.str_t:
        if isinstance(l.repr, dynjit.S) and isinstance(r.repr, dynjit.S):

            dictionary = cast(dict, l.repr.c)
            key = r.repr.c
            if key not in dictionary:
                # TODO: insert raise exception in runtime
                raise NotImplemented
            repr = dictionary[key]
            typ = next(t for (k, t) in l.type.xs if k == key)
            abs_val = dynjit.AbstractValue(repr, typ)
            s = stack.cons(abs_val, s)
            yield from infer(s, p + 1)
        else:
            raise NotImplemented
    elif isinstance(l.type, types.TupleT) and r.type is types.int_t:
        if isinstance(l.repr, dynjit.S) and isinstance(r.repr, dynjit.S):
            i = cast(int, r.repr.c)
            repr = cast(tuple, l.repr.c)[i]
            typ = l.type.xs[i]
            abs_val = dynjit.AbstractValue(repr, typ)
            s = stack.cons(abs_val, s)
            yield from infer(s, p + 1)
        else:
            # TODO: tuple split for n < THRESHOLD
            # e.g.:
            # xs: (t1, t2, t3), i: int
            # xs[i] : t1 | t2 | t3
            n = stack.size(s)
            repr = dynjit.D(n)
            abs_val = dynjit.AbstractValue(repr, types.TopT())
            yield dynjit.Assign(abs_val, dynjit.Call(prims.v_tupleget, [l, r]))
            s = stack.cons(abs_val, s)
            yield from infer(s, p + 1)
    else:
        return NO_SPECIALIZATION







