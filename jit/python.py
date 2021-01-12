from jit.core import *
from jit.client import eager_jit, jit_spec_call
import typing as _t
import operator


def display_corecpy(func):
    ufunc: StAbsVal = STATIC_VALUE_MAPS[func]
    in_def = In_Def.UserCodeDyn[ufunc.ts[0]]
    in_def.show()


any_pack = RuntimeWrap(PrimAbsVal.AnyPack)
get_field = RuntimeWrap(PrimAbsVal.GetField)
ccall = RuntimeWrap(PrimAbsVal.CallC)
coerce = RuntimeWrap(PrimAbsVal.Coerce)
get_type_field = RuntimeWrap(PrimAbsVal.GetTypeField)
ucall = RuntimeWrap(PrimAbsVal.CallU)
get_class = RuntimeWrap(PrimAbsVal.GetClass)
untyped = _t.cast(_t.Type[object], RuntimeWrap(A_bot))


@eager_jit
def type_new(cls, *_):
    o = get_field(cls, "__new__")(cls, ...)
    if isinstance(o, cls):
        get_field(cls, "__init__")(o, ...)
        return o
    return o


@eager_jit
def type_call(cls, a, *_):
    if cls is type:
        return get_class(a)

    return type_new(cls, a, ...)


shape_class = A_class.shape()
shape_class.fields["__call__"] = from_runtime(type_call)
shape_class.fields["__new__"] = from_runtime(type_new)


@eager_jit
def add(a, b):
    a = a.__add__(b)
    if a is NotImplemented:
        return b.__radd__(a)
    return a


Bin.add.shape().fields["__call__"] = from_runtime(add)


@eager_jit
def sub(a, b):
    a = a.__sub__(b)
    if a is NotImplemented:
        return b.__rsub__(a)
    return a


Bin.sub.shape().fields["__call__"] = from_runtime(sub)


@eager_jit
def init_do_nothing(self, a):
    pass


@eager_jit
def int_add(self, b):
    if isinstance(b, int) and isinstance(self, int):
        return ccall(int, "c_int_add", self, b)
    return NotImplemented


A_int.shape().fields["__add__"] = from_runtime(int_add)


@eager_jit
def float_add(self, b):
    if isinstance(self, float):
        b = float(b)
        b = ccall(float, "c_float_add", self, b)
        return b

    return NotImplemented


@eager_jit
def float_type_new(cls, a):
    if isinstance(a, int):
        return ccall(float, "c_int_to_float", a)
    if isinstance(a, float):
        return a
    if isinstance(a, str):
        return ccall(float, "c_parse_float", a)
    return NotImplemented


A_float.shape().fields["__add__"] = from_runtime(float_add)
A_float.shape().fields["__new__"] = from_runtime(float_type_new)
A_float.shape().fields["__init__"] = from_runtime(init_do_nothing)


# A_int.shape().fields.update(
#     __add__=int_add,
#     __sub__=int_sub,
# )
# A_float.shape().fields.update(__add__=float_add, __sub__=float_sub)


# print(in_def.glob)


@eager_jit
def test():
    return float.__new__("1")


in_def = In_Def.UserCodeDyn[from_runtime(test).ts[0]]
in_def.show()


print(jit_spec_call(test))
print()
for each in reversed(Out_Def.GenerateCache):
    each.show()
