from jit import translate
from jit import core
from jit.client import jit, jit_call, display_corecpy
import operator


@jit(glob={"isinstance": core.PrimAbsVal.IsInstance})
def type_new(t, *_):
    o = t.__new__(...)
    if isinstance(o, t):
        t.__init__(o, ...)
        return o
    return o


@jit(
    glob={
        "any_pack": core.PrimAbsVal.AnyPack,
        "type_new": core.from_runtime(type_new),
        "type": core.A_class,
        "get_class": core.PrimAbsVal.GetClass,
    }
)
def type_call(cls, a, *_):

    if cls is type:
        # if any_pack(): TODO: create new type
        #
        return get_class(a)

    return type_new(a, ...)


shape_class = core.A_class.shape()
shape_class.fields["__call__"] = core.from_runtime(type_call)


shape_add = core.Bin.A_add.shape()


@jit
def add(a, b):
    return a.__add__(b)


shape_add.fields["__call__"] = core.from_runtime(add)


@jit(
    glob={
        "callc": core.PrimAbsVal.CallC,
        "object": core.A_top,
        "type": core.A_class,
        "int": core.A_int,
    }
)
def int_add(self, b):
    if type(b) is int:
        return callc(int, "c_int_add", self, b)
    return callc(object, "py_add", self, b)


shape_int = core.A_int.shape()
shape_int.fields["__add__"] = core.from_runtime(int_add)


@jit
def f(x):
    a = x + 1
    if a < 2:
        return 3
    return a


display_corecpy(type_call)
print("".center(100, "="))

m, e = jit_call(type, 1)
print(m)
print(e)

print("".center(100, "="))
for each in core.Out_Def.GenerateCache:
    each.show()
