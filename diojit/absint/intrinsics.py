from __future__ import annotations
import sys
import operator
from typing import Callable, Optional

__all__ = ["intrinsic", "Intrinsic"]


def setup():
    pass


def _mk(name, bases, ns):
    global setup
    t = type(name, bases, ns)

    def setup():
        for n, v in ns["__annotations__"].items():
            if n.startswith("_"):
                continue
            setattr(t, n, intrinsic(n))

    return t


class Intrinsic(metaclass=_mk):
    _callback: Optional[Callable] = None
    _name: str
    J: object

    @property
    def name(self):
        return self._name

    def __repr__(self):
        return f"{self._name}"

    def __eq__(self, other):
        return (
            isinstance(other, Intrinsic) and self._name is other._name
        )

    def __hash__(self):
        return id(self._name)

    Py_TYPE: Intrinsic

    # hints: implemented by
    # 1. PyObject_CallFunctionObjArgs()
    # 2. PyObject_CallNoArgs()
    # 3. PyObject_CallOneArg()
    Py_CallFunction: Intrinsic

    # 1. PyObject_CallMethodNoArgs()
    # 2. PyObject_CallMethodOneArg()
    # 3. PyObject_CallMethodObjArgs()
    Py_CallMethod: Intrinsic

    Py_LoadGlobal: Intrinsic

    Py_StoreGlobal: Intrinsic

    Py_StoreAttr: Intrinsic

    Py_LoadAttr: Intrinsic

    Py_BuildTuple: Intrinsic

    Py_BuildList: Intrinsic

    Py_Raise: Intrinsic

    Py_AddressCompare = operator.is_
    Py_Not = operator.__not__

    Py_Pow = operator.__pow__
    Py_Mul = operator.__mul__
    Py_Matmul = operator.__matmul__
    Py_Floordiv = operator.__floordiv__
    Py_Truediv = operator.__truediv__
    Py_Mod = operator.__mod__
    Py_Add = operator.__add__
    Py_Sub = operator.__sub__
    Py_Getitem = operator.__getitem__
    Py_Lshift = operator.__lshift__
    PY_Rshift = operator.__rshift__
    Py_And = operator.__and__
    Py_Xor = operator.__xor__
    Py_Or = operator.__or__

    Py_Lt = operator.__lt__
    Py_Gt = operator.__gt__
    Py_Le = operator.__le__
    Py_Ge = operator.__ge__
    Py_Ne = operator.__ne__
    Py_Eq = operator.__eq__


_cache = {}


def intrinsic(name: str) -> Intrinsic:
    name = sys.intern(name)
    if o := _cache.get(name):
        return o
    o = Intrinsic.__new__(Intrinsic)
    o._name = name
    _cache[name] = o
    return o


setup()
