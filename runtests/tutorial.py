from math import sqrt
import operator
import timeit
import builtins
import diojit
from inspect import getsource
from diojit.runtime.julia_rt import check_jl_err
from diojit.codegen.julia import splice

GenerateCache = diojit.Out_Def.GenerateCache

import diojit as jit
import timeit
from operator import add

libjl = jit.runtime.julia_rt.get_libjulia()


def jl_eval(s: str):
    libjl.jl_eval_string(s.encode())
    check_jl_err(libjl)


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
jit_fib_fix_typed = jit.jit_spec_call(
    fib_fix, jit.oftype(int)
)
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

print("hypot".center(70, "="))


@diojit.jit(fixed_references=["sqrt", "str", "int", "isinstance"])
def hypot(x, y):
    if isinstance(x, str):
        x = int(x)

    if isinstance(y, str):
        y = int(y)

    return sqrt(x ** 2 + y ** 2)


print(getsource(hypot))


# print("Direct Translation From Stack Instructions".center(70, "="))

# diojit.absint.In_Def.UserCodeDyn[hypot].show()
# print("After JITing".center(70, "="))


jit_func_name = repr(
    diojit.jit_spec_call_ir(
        hypot, diojit.S(int), diojit.S(int)
    ).e_call.func
)


hypot_spec = diojit.jit_spec_call(
    hypot,
    diojit.oftype(int),
    diojit.oftype(int),
    # print_jl=print,
    # print_dio_ir=print,
)
# #
# libjl = diojit.runtime.julia_rt.get_libjulia()
# libjl.jl_eval_string(f'using InteractiveUtils;@code_llvm {jit_func_name}(PyO.int, PyO.int)'.encode())
# diojit.runtime.julia_rt.check_jl_err(libjl)

print("hypot(1, 2) (jit) = ", hypot_spec(1, 2))
print("hypot(1, 2) (pure py) = ", hypot(1, 2))
print(
    "hypot (pure py) bench time:",
    timeit.timeit("f(1, 2)", number=1000000, globals=dict(f=hypot)),
)
print(
    "hypot (jit) bench time:",
    timeit.timeit(
        "f(1, 2)", number=1000000, globals=dict(f=hypot_spec)
    ),
)

diojit.create_shape(list, oop=True)


@diojit.register(list, attr="append")
def list_append_analysis(self: diojit.Judge, *args: diojit.AbsVal):
    if len(args) != 2:
        # rollback to CPython's default code
        return NotImplemented
    lst, elt = args

    return diojit.CallSpec(
        instance=None,  # return value is not static
        e_call=diojit.S(diojit.intrinsic("PyList_Append"))(lst, elt),
        possibly_return_types=tuple({diojit.S(type(None))}),
    )


@diojit.jit
def append3(xs, x):
    xs.append(x)
    xs.append(x)
    xs.append(x)


print("append3".center(70, "="))
print(getsource(append3))

# diojit.In_Def.UserCodeDyn[append3].show()
jit_append3 = diojit.jit_spec_call(
    append3, diojit.oftype(list), diojit.Top
)
xs = [1]
jit_append3(xs, 3)
print("test jit func: [1] append 3 for 3 times =", xs)


xs = []
print(
    "append3 (jit) bench time:",
    timeit.timeit(
        "f(xs, 1)", globals=dict(f=jit_append3, xs=xs), number=10000000
    ),
)
xs = []
print(
    "append3 (pure py) bench time:",
    timeit.timeit(
        "f(xs, 1)", globals=dict(f=append3, xs=xs), number=10000000
    ),
)
