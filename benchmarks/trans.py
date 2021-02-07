"""
fib(15) (py) bench time: 1.3318193000000003
fib(15) (jit+untyped) bench time: 0.42067140000000025
fib(15) (jit+inferred) bench time: 0.1776359000000003
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
print(timeit.timeit("f(10)", globals=dict(f=f), number=11111111))
print(timeit.timeit("f(10)", globals=dict(f=jit_f), number=11111111))
