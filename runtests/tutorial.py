import jit
from math import sqrt
import operator

GenerateCache = jit.Out_Def.GenerateCache


# @jit.jit
# def trans(x):
#     y = x
#     z = y
#     a = z
#     return a
#
#
# callspec = jit.jit_spec_call_ir(trans, jit.Val(20))
# for each in reversed(jit.absint.Out_Def.GenerateCache):
#     each.show()
# GenerateCache.clear()
# print("".center(100, "="))


@jit.register(isinstance, create_shape=True)
def spec_isinstance(self: jit.Judge, l: jit.AbsVal, r: jit.AbsVal):
    if (
        isinstance(l.type, jit.S)
        and isinstance(r, jit.S)
        and isinstance(r.base, type)
    ):
        const = l.type == r or l.type.base in r.base.__bases__
        return jit.CallSpec(jit.S(const), jit.S(const), tuple({jit.Values.A_Bool}))
    return NotImplemented


@jit.register(operator.__pow__, create_shape=True)
def spec_pow(self: jit.Judge, l: jit.AbsVal, r: jit.AbsVal):
    if l.type == jit.Values.A_Int:
        if r.type == jit.Values.A_Int:
            py_int_power_int = jit.S(jit.intrinsic("Py_IntPowInt"))
            return_types = tuple({jit.Values.A_Int})
            constant_result = None  # no constant result
            return jit.CallSpec(
                constant_result, py_int_power_int(l, r), return_types
            )
    return NotImplemented


@jit.register(operator.__add__, create_shape=True)
def spec_add(self: jit.Judge, l: jit.AbsVal, r: jit.AbsVal):
    if l.type == jit.Values.A_Int:
        if r.type == jit.Values.A_Int:
            py_int_add_int = jit.S(jit.intrinsic("Py_IntAddInt"))
            return_types = tuple({jit.Values.A_Int})
            constant_result = None  # no constant result
            return jit.CallSpec(
                constant_result, py_int_add_int(l, r), return_types
            )
    return NotImplemented
#
#
# @jit.register(sqrt, create_shape=True)
# def spec_sqrt(self: jit.Judge, a: jit.AbsVal):
#     if a.type == jit.Values.A_Int:
#         int_sqrt = jit.S(jit.intrinsic("Py_IntSqrt"))
#         return jit.CallSpec(None, int_sqrt(a), tuple({jit.Values.A_Float}))
#     return NotImplemented


@jit.jit(fixed_references=["sqrt", "str", "int", "isinstance"])
def hypot(x, y):
    if isinstance(x, str):
        x = int(x)
    if isinstance(y, str):
        y = int(y)

    return sqrt(x ** 2 + y ** 2)


print("Direct Translation From Stack Instructions".center(70, "="))

jit.absint.In_Def.UserCodeDyn[hypot].show()
print("After JITing".center(70, "="))

callspec = jit.jit_spec_call_ir(hypot, jit.S(int), jit.S(int))
for each in reversed(jit.absint.Out_Def.GenerateCache):
    each.show()
print("".center(70, "="))

for each in jit.Out_Def.GenerateCache:
    print(jit.codegen.julia.Codegen(each).get())

