"""
fib(py) bench time: 1.3318193000000003
fib(jit+untyped) bench time: 0.42067140000000025
fib(jit+inferred) bench time: 0.1776359000000003
"""
import diojit as jit
from inspect import getsource
import timeit


def fib(a):
    if a <= 2:
        return 1
    return fib(a - 1) + fib(a - 2)


@jit.jit(fixed_references=["fib_fix"])
def fib_fix(a):
    if a <= 2:
        return 1
    return fib_fix(a + -1) + fib_fix(a + -2)


jit_fib_fix_untyped = jit.jit_spec_call(fib_fix, jit.Top)
jit_fib_fix_typed = jit.jit_spec_call(fib_fix, jit.oftype(int))
# jl_eval(f"println(J_fib__fix_1({splice(20)}))")
# check_jl_err(libjl)
print("fib".center(70, "="))
print(getsource(fib))
print(
    "fib(15), jit_fib_fix_untyped(15), jit_fib_fix_typed(15) = ",
    (fib(15), jit_fib_fix_untyped(15), jit_fib_fix_typed(15)),
)
print(
    "fib(py) bench time:",
    timeit.timeit("f(15)", globals=dict(f=fib), number=10000),
)
print(
    "fib(jit+untyped) bench time:",
    timeit.timeit(
        "f(15)", globals=dict(f=jit_fib_fix_untyped), number=10000
    ),
)
print(
    "fib(jit+inferred) bench time:",
    timeit.timeit(
        "f(15)", globals=dict(f=jit_fib_fix_typed), number=10000
    ),
)
