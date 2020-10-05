from jit import types, dynjit
from jit.pe import Compiler
from jit.ll.closure import Closure
from jit.codegen.cython_loader import compile_module


c = Compiler()

__fix__ = ["int", "pp", "isinstance", "float", "Closure"]


@c.aware
def pp(x):
    j = 2
    while x < 20:
        j = j + x
        x = x + 3
    return j


m = c.specialise(pp, types.int_t)
f = m.method.repr.c
print(f(12))
print(f(19))


print(pp(12))
print(pp(19))

mod = compile_module("""
cpdef int pp(int x):
    j = 2
    while x < 20:
        print(x)
        j = j + x
        x = x + 3
    return j
""")

from timeit import timeit

print(timeit('pp(1)', globals=dict(pp=f)))
print(timeit('pp(1)', globals=dict(pp=pp)))
print(timeit('pp(1)', globals=dict(pp=mod.pp)))
