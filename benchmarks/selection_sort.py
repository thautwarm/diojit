import diojit as jit
import timeit
from diojit.runtime.julia_rt import check_jl_err
from diojit.codegen.julia import splice

libjl = jit.runtime.julia_rt.get_libjulia()


def jl_eval(s: str):
    libjl.jl_eval_string(s.encode())
    check_jl_err(libjl)


@jit.jit
def argmin(xs, i, n):
    min_val = xs[i]
    min_i = i
    j = i + 1
    while j < n:
        e = xs[j]
        if e < min_val:
            min_i = j
            min_val = e
        j = j + 1
    return min_i


@jit.jit
def swap(xs, min_i, i):
    xs[min_i], xs[i] = xs[i], xs[min_i]


@jit.jit(fixed_references=["argmin", "swap", "len"])
def msort(ys):
    xs = ys.copy()
    n = len(xs)
    i = 0
    while i < n:
        min_i = argmin(xs, i, n)
        swap(xs, min_i, i)
        i = i + 1
    return xs


@jit.jit
def mwe(xs):
    return xs[0] < xs[2]


jit_msort = jit.jit_spec_call(
    msort,
    jit.oftype(list),
    print_dio_ir=print,
)

import numpy as np


xs = list(np.random.randint(0, 10000, 100))

print(
    "pure python",
    timeit.timeit("f(xs)", globals=dict(xs=xs, f=msort), number=10000),
)
print(
    "jit",
    timeit.timeit(
        "f(xs)", globals=dict(xs=xs, f=jit_msort), number=10000
    ),
)


jl_eval(f"println(J_msort_0({splice([1, 2, 3])}))")


## This is the specialisation that produces 600% performance gain:

# @register(operator.__getitem__, create_shape=True)
# def call_getitem(self: Judge, *args: AbsVal):
#     if len(args) != 2:
#         # 返回到默认python实现
#         return NotImplemented
#     subject, item = args
#     ret_types = (Top,)
#
#     if (
#         subject.type not in (Top, Bot)
#         and subject.type.base == list
#         and item.type not in (Top, Bot)
#         and issubclass(item.type.base, int)
#     ):
#         func = S(intrinsic("PyList_GetItem"))
#         # ret_types = tuple({Values.A_Int})
#     else:
#         func = S(intrinsic("PyObject_GetItem"))
#
#     e_call = func(subject, item)
#     instance = None
#     return CallSpec(instance, e_call, ret_types)
