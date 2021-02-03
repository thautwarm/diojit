from math import sqrt
import operator
import timeit
import diojit

GenerateCache = diojit.Out_Def.GenerateCache


@diojit.jit(fixed_references=["isinstance", "str"])
def trans(x):

    if isinstance(x, str):
        return 1
    return 2


callspec = diojit.jit_spec_call_ir(trans, diojit.oftype(str))

for each in GenerateCache.values():
    each.show(print)
print("".center(100, "="))


@diojit.jit(fixed_references=["sqrt", "str", "int", "isinstance"])
def hypot(x, y):
    if isinstance(x, str):
        x = int(x)

    if isinstance(y, str):
        y = int(y)

    return sqrt(x ** 2 + y ** 2)


# print("Direct Translation From Stack Instructions".center(70, "="))

# diojit.absint.In_Def.UserCodeDyn[hypot].show()
# print("After JITing".center(70, "="))


jit_func_name = repr(
    diojit.jit_spec_call_ir(hypot, diojit.S(int), diojit.S(int)).e_call.func
)


hypot_spec = diojit.jit_spec_call(
    hypot,
    diojit.oftype(int),
    diojit.oftype(int),  # print_jl=print, print_dio_ir=print
)
# #
# libjl = diojit.runtime.julia_rt.get_libjulia()
# libjl.jl_eval_string(f'using InteractiveUtils;@code_llvm {jit_func_name}(PyO.int, PyO.int)'.encode())
# diojit.runtime.julia_rt.check_jl_err(libjl)

print("diojit func result = ", hypot_spec(1, 2))
print("pure py func result = ", hypot(1, 2))
print(
    "pure py time:",
    timeit.timeit("f(1, 2)", number=1000000, globals=dict(f=hypot)),
)
print(
    "diojit time:",
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


# diojit.In_Def.UserCodeDyn[append3].show()
jit_append3 = diojit.jit_spec_call(append3, diojit.oftype(list), diojit.Top)
xs = [1]
jit_append3(xs, 3)
print("test diojit func, [1] append 3 for 3 times:", xs)


xs = []
print(
    "diojit func time:",
    timeit.timeit(
        "f(xs, 1)", globals=dict(f=jit_append3, xs=xs), number=10000000
    ),
)
xs = []
print(
    "pure py func time:",
    timeit.timeit(
        "f(xs, 1)", globals=dict(f=append3, xs=xs), number=10000000
    ),
)