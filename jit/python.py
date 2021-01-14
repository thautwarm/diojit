from jit.core import *
from jit.client import eager_jit, jit_spec_call
import typing as _t
import operator


def display_corecpy(func):
    ufunc: StAbsVal = STATIC_VALUE_MAPS[func]
    in_def = In_Def.UserCodeDyn[ufunc.ts[0]]
    in_def.show()


any_pack = RuntimeWrap(PrimAbsVal.AnyPack)
elim_type_vars = RuntimeWrap(PrimAbsVal.ElimTypeVars)
get_field = RuntimeWrap(PrimAbsVal.GetField)
ccall = RuntimeWrap(PrimAbsVal.CallC)
is_static = RuntimeWrap(PrimAbsVal.IsStatic)
static_call = RuntimeWrap(PrimAbsVal.CallS)
coerce = RuntimeWrap(PrimAbsVal.Coerce)
get_type_field = RuntimeWrap(PrimAbsVal.GetTypeField)
ucall = RuntimeWrap(PrimAbsVal.CallU)
get_class = RuntimeWrap(PrimAbsVal.GetClass)
bottom = _t.cast(_t.Type[object], RuntimeWrap(A_bot))
top = _t.cast(_t.Type[object], RuntimeWrap(A_top))


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
def init_do_nothing(self, *_):
    pass


@eager_jit
def int_add(self, b):
    if isinstance(b, int) and isinstance(self, int):
        return ccall(int, "c_int_add", self, b)
    return NotImplemented


@eager_jit
def int_sub(self, b):
    if isinstance(b, int) and isinstance(self, int):
        return ccall(int, "c_int_sub", self, b)
    return NotImplemented


@eager_jit
def int_lt(self, b):
    if isinstance(b, int) and isinstance(self, int):
        return ccall(bool, "c_int_lt", self, b)
    return coerce(bool, operator.lt(self, b))


A_int.shape().fields["__add__"] = from_runtime(int_add)
A_int.shape().fields["__sub__"] = from_runtime(int_sub)
A_int.shape().fields["__lt__"] = from_runtime(int_lt)


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


@eager_jit
def bool_type_new(cls, a):
    if isinstance(a, bool):
        return a
    if isinstance(a, float):
        return coerce(bool, a != 0.0)
    if isinstance(a, int):
        return coerce(bool, a != 0)
    if isinstance(a, str):
        return a == ""
    return ucall(bool, a)


A_bool.shape().fields["__new__"] = from_runtime(bool_type_new)
A_bool.shape().fields["__init__"] = from_runtime(init_do_nothing)


@eager_jit
def dict_getitem(self, key):
    if is_static(key):
        return ccall(
            top,
            "PyDict_GetItem_KnownHash",
            self,
            key,
            static_call(hash, key),
        )
    return ccall(top, "PyDict_GetItemWithError", self, key)


A_dict.shape().fields["__getitem__"] = from_runtime(dict_getitem)


@eager_jit
def tuple_getitem(self, key):
    c = get_class(self)
    if (
        elim_type_vars(c) is tuple
        and is_static(key)
        and isinstance(key, int)
    ):
        t = get_type_field(get_class(self), key)
        if t is not top and t is not bottom:
            return ccall(t, "PyTuple_GET_ITEM", self, key)
    return ccall(top, "PyTuple_GetItem", self, key)


A_tuple.shape().fields["__getitem__"] = from_runtime(tuple_getitem)


# A_int.shape().fields.update(
#     __add__=int_add,
#     __sub__=int_sub,
# )
# A_float.shape().fields.update(__add__=float_add, __sub__=float_sub)


# print(in_def.glob)
