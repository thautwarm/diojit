from jit import types, dynjit
from jit.intrinsics import *

prim_types = {}


def ct2(ac):
    a = types.noms.get(type(ac))
    if a is not None:
        return a

    a = prim_types.get(ac)
    if a is not None:
        return a

    return types.TopT()


def ct(ac):
    if isinstance(ac, tuple):
        return types.TupleT(tuple(map(ct2, ac)))
    return ct2(ac)


def define_prim(o):
    t = types.PrimT(o)
    v = dynjit.AbstractValue(dynjit.S(o), t)
    prim_types[o] = t
    return v


v_isinstance = define_prim(i_isinstance)
v_get_cells = define_prim(i_getcells)
v_py_call = define_prim(i_pycall)
v_getattr = define_prim(i_getattr)
v_add = define_prim(operator.add)
v_iadd = define_prim(i_iadd)
v_fadd = define_prim(i_fadd)
v_sconcat = define_prim(i_sconcat)
v_sext = define_prim(i_sext)
v_asbool = define_prim(i_asbool)
v_beq = define_prim(i_beq)
