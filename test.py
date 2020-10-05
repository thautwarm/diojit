from jit import types, dynjit
from jit.pe import Compiler
from jit.ll.closure import Closure
from jit.codegen.cython_loader import compile_module


c = Compiler()

__fix__ = ["int", "pp", "isinstance", "float", "Closure"]


@c.aware
def pp(x):
    j = 2.0
    while x < 20.0:
        j = j + x
        x = x + 3.0
    return j


m = c.specialise(pp, types.float_t)
f = m.method.repr.c
print(f(12.0))
print(f(19.0))


print(pp(12.0))
print(pp(19.0))

mod = compile_module("""
cpdef float pp(float x):
    cdef float j = 2.0
    while x < 20.0:
        j = j + x
        x = x + 3.0
    return j
""")

from timeit import timeit

print(timeit('pp(1.0)', globals=dict(pp=f)))
print(timeit('pp(1.0)', globals=dict(pp=pp)))
print(timeit('pp(1.0)', globals=dict(pp=mod.pp)))
