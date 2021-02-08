"""
pure py: 2.6820188
jit: 0.8471317999999997
"""
import diojit as jit
from inspect import getsource
import timeit
from diojit.runtime.julia_rt import splice, jl_eval


@jit.jit
def f(x):
    x = 1 + x
    y = 1 + x
    z = 1 + y
    x = 1 + z
    y = 1 + x
    z = 1 + y
    x = 1 + z
    return x


jit_f = jit.jit_spec_call(f, jit.oftype(int), print_jl=print)

print(jit_f(10))
print('pure py:', timeit.timeit("f(10)", globals=dict(f=f), number=11111111))
print('jit:', timeit.timeit("f(10)", globals=dict(f=jit_f), number=11111111))
