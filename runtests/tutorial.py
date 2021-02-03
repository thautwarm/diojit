from math import sqrt
import operator
import timeit
import jit

GenerateCache = jit.Out_Def.GenerateCache


@jit.jit(fixed_references=["isinstance", "str"])
def trans(x):

    if isinstance(x, str):
        return 1
    return 2


callspec = jit.jit_spec_call_ir(trans, jit.oftype(str))

for each in GenerateCache.values():
    each.show(print)
print("".center(100, "="))


@jit.jit(fixed_references=["sqrt", "str", "int", "isinstance"])
def hypot(x, y):
    if isinstance(x, str):
        x = int(x)

    if isinstance(y, str):
        y = int(y)

    return sqrt(x ** 2 + y ** 2)


# print("Direct Translation From Stack Instructions".center(70, "="))

# jit.absint.In_Def.UserCodeDyn[hypot].show()
# print("After JITing".center(70, "="))


jit_func_name = repr(
    jit.jit_spec_call_ir(hypot, jit.S(int), jit.S(int)).e_call.func
)


hypot_spec = jit.jit_spec_call(
    hypot,
    jit.oftype(int),
    jit.oftype(int),  # print_jl=print, print_dio_ir=print
)
# #
# libjl = jit.runtime.julia_rt.get_libjulia()
# libjl.jl_eval_string(f'using InteractiveUtils;@code_llvm {jit_func_name}(PyO.int, PyO.int)'.encode())
# jit.runtime.julia_rt.check_jl_err(libjl)

print("jit func result = ", hypot_spec(1, 2))
print("pure py func result = ", hypot(1, 2))
print(
    "pure py time:",
    timeit.timeit("f(1, 2)", number=1000000, globals=dict(f=hypot)),
)
print(
    "jit time:",
    timeit.timeit(
        "f(1, 2)", number=1000000, globals=dict(f=hypot_spec)
    ),
)

jit.create_shape(list, oop=True)


@jit.register(list, attr="append")
def list_append_analysis(self: jit.Judge, *args: jit.AbsVal):
    if len(args) != 2:
        # rollback to CPython's default code
        return NotImplemented
    lst, elt = args

    return jit.CallSpec(
        instance=None,  # return value is not static
        e_call=jit.S(jit.intrinsic("PyList_Append"))(lst, elt),
        possibly_return_types=tuple({jit.S(type(None))}),
    )


@jit.jit
def append3(xs, x):
    xs.append(x)
    xs.append(x)
    xs.append(x)


# jit.In_Def.UserCodeDyn[append3].show()
jit_append3 = jit.jit_spec_call(append3, jit.oftype(list), jit.Top)
xs = [1]
jit_append3(xs, 3)
print("test jit func, [1] append 3 for 3 times:", xs)

xs = []
print(
    "pure py func time:",
    timeit.timeit(
        "f(xs, 1)", globals=dict(f=append3, xs=xs), number=10000000
    ),
)
xs = []
print(
    "jit func time:",
    timeit.timeit(
        "f(xs, 1)", globals=dict(f=jit_append3, xs=xs), number=10000000
    ),
)
