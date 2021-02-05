"""
hypot (pure py) bench time: 0.7044676000000001
hypot (jit) bench time: 0.4247455999999996
"""
import diojit as jit
from inspect import getsource
import timeit
from math import sqrt


@jit.jit(fixed_references=["sqrt", "str", "int", "isinstance"])
def hypot(x, y):
    if isinstance(x, str):
        x = int(x)

    if isinstance(y, str):
        y = int(y)

    return sqrt(x ** 2 + y ** 2)


print(getsource(hypot))


# print("Direct Translation From Stack Instructions".center(70, "="))

# jit.absint.In_Def.UserCodeDyn[hypot].show()
# print("After JITing".center(70, "="))


jit_func_name = repr(
    jit.jit_spec_call_ir(
        hypot, jit.S(int), jit.S(int)
    ).e_call.func
)


hypot_spec = jit.jit_spec_call(
    hypot,
    jit.oftype(int),
    jit.oftype(int),
    # print_jl=print,
    # print_dio_ir=print,
)
# #
# libjl = jit.runtime.julia_rt.get_libjulia()
# libjl.jl_eval_string(f'using InteractiveUtils;@code_llvm {jit_func_name}(PyO.int, PyO.int)'.encode())
# jit.runtime.julia_rt.check_jl_err(libjl)

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
