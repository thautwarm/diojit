from jit import types, dynjit
from jit.pe import Compiler
from jit.ll.closure import Closure
from jit.codegen.cython_loader import compile_module


c = Compiler()

__fix__ = ["pp", "float"]


@c.aware
def pp(x):
    j = 2.0
    while x < 20.0:
        j = j + x
        x = x + 3.0
    return j


pp_float = c.optimize_by_args(pp, 1.0)
print(pp_float(12.0))
print(pp_float(19.0))

print(pp(12.0))
print(pp(19.0))

mod = compile_module(
    """
cpdef float pp(double x):
    cdef double j = 2.0
    while x < 20.0:
        j = j + x
        x = x + 3.0
    return j
"""
)

from timeit import timeit


print(
    timeit("pp(1.0)", globals=dict(pp=pp_float), number=1000000),
    "s/10000 call",
)


print(
    timeit("pp(1.0)", globals=dict(pp=pp), number=1000000), "s/1000000 call"
)


print(
    timeit("pp(1.0)", globals=dict(pp=mod.pp), number=1000000),
    "s/10000 call",
)
