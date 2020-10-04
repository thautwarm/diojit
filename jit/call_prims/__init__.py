from collections import defaultdict
from typing import Optional
NO_SPECIALIZATION = True
primitive_table = defaultdict(dict)


def register_dispatch(intrinsic: object, argc: Optional[int]):
    def ap(func):
        primitive_table[intrinsic][argc] = func
        return func

    return ap


def dispatch(intrinsic: object, argc: int):
    m1 = primitive_table.get(intrinsic)
    if not m1:
        return
    f1 = m1.get(argc)
    if not f1:
        return m1.get(None)
    return f1


def setup_primitives():
    from jit.call_prims import (
        p_add,
        p_callint,
        p_getitem,
        p_globals,
        p_inst,
        p_mkfunc,
        p_storeref,
        p_attr,
        p_datastructures,
        p_closure
    )
