from __future__ import annotations
from typing import Sequence, Dict, Set
from typing import Union, TYPE_CHECKING
from dataclasses import dataclass
import ctypes
import types as pytypes

if TYPE_CHECKING:
    from jit import dynjit

cell = CellType = type((lambda x: lambda: x)(1).__closure__[0])
NoneType = type(None)


class JitClosure(ctypes.Structure):
    _fields_ = [("free", ctypes.py_object), ("fptr", ctypes.py_object)]


@dataclass(eq=True, frozen=True)
class RefT:
    x: T

    @staticmethod
    def to_py_type():
        return CellType

    def __repr__(self):
        return f"ref<{self.x!r}>"


@dataclass(eq=True, frozen=True, unsafe_hash=True)
class RecordT:
    fix: Dict[str, SurfT]

    @staticmethod
    def to_py_type():
        return dict

    def __repr__(self):
        return "{{{}}}".format(
            ",".join(f"{k}: {t!r}" for k, t in self.fix.items())
        )


@dataclass(eq=True, frozen=True, unsafe_hash=True)
class TupleT:
    xs: Sequence[SurfT]

    @staticmethod
    def to_py_type():
        return tuple

    def __repr__(self):
        return "<{}>".format(",".join(map(repr, self.xs)))


@dataclass(frozen=True, eq=True)
class FPtrT:
    func: pytypes.FunctionType

    @staticmethod
    def to_py_type():
        return pytypes.FunctionType

    def __repr__(self):
        return f"{self.func.__name__}"


@dataclass(frozen=True, eq=True)
class MethT:
    self: T
    func: T

    @staticmethod
    def to_py_type():
        # TODO: a cython structure
        return pytypes.MethodType

    def __repr__(self):
        return f"{self.func!r}({self.self!r})"


@dataclass(frozen=True, eq=True)
class ClosureT:
    cell: T
    func: T

    @staticmethod
    def to_py_type():
        # TODO: a cython structure
        from jit.ll.closure import Closure
        return Closure

    def __repr__(self):
        return f"{self.func!r}[{self.cell!r}]"


#
# @dataclass(frozen=True)
# class DefaultT:
#     """
#     specify default arguments of functions
#     """
#     defaults: Sequence[T]
#     func: object


class NomT:
    name: type
    members: Dict[str, dynjit.Expr]
    static_members: Dict[str, dynjit.Expr]

    def __init__(
        self,
        name: type,
        members: Dict[str, dynjit.Expr],
        static_members: Dict[str, dynjit.Expr],
    ):
        self.name = name
        self.members = members
        self.static_members = static_members

    def to_py_type(self):
        return self.name

    def __repr__(self):
        return f"{self.name.__module__}.{self.name.__name__}"


@dataclass(eq=True, frozen=True)
class PrimT:
    o: object

    def to_py_type(self):
        return type(self.o)

    def __repr__(self):
        # noinspection PyTypeChecker
        # if isinstance(self.o, (pytypes.FunctionType, pytypes.BuiltinFunctionType)):
        #     s = self.o.__name__
        return f"{self.o.__name__}"


@dataclass(eq=True, frozen=True)
class BottomT:
    @staticmethod
    def to_py_type():
        raise NotImplementedError

    def __repr__(self):
        return "bot"


@dataclass(eq=True, frozen=True)
class TopT:
    @staticmethod
    def to_py_type():
        return object

    def __repr__(self):
        return "top"


@dataclass(eq=True, frozen=True)
class TypeT:
    type: SurfT

    @staticmethod
    def to_py_type():
        return type

    def __repr__(self):
        return f"type<{self.type}>"


@dataclass(eq=True, frozen=True)
class UnionT:
    alts: Set[T]

    @staticmethod
    def to_py_type():
        return TypeError

    def __repr__(self):
        return "|".join(map(repr, self.alts))


bool_members = {}
bool_static_members = {}
bool_t = NomT(bool, bool_members, bool_static_members)

int_members = {}
int_static_members = {}
int_t = NomT(int, int_members, int_static_members)

float_members = {}
float_static_members = {}
float_t = NomT(float, float_members, float_static_members)

str_members = {}
str_static_members = {}
str_t = NomT(str, str_members, str_static_members)

tuple_members = {}
tuple_static_members = {}
tuple_t = NomT(tuple, tuple_members, tuple_static_members)

dict_members = {}
dict_static_members = {}
dict_t = NomT(dict, dict_members, dict_static_members)

none_members = {}
none_static_members = {}
none_t = NomT(NoneType, none_members, none_static_members)

list_members = {}
list_static_members = {}
list_t = NomT(list, list_members, list_static_members)

cell_members = {}
cell_static_members = {}
cell_t = NomT(cell, cell_members, cell_static_members)

type_members = {}
type_static_members = {}
type_t = NomT(type, type_members, type_static_members)

noms = {
    dict: dict_t,
    int: int_t,
    float: float_t,
    str: str_t,
    tuple: tuple_t,
    bool: bool_t,
    NoneType: none_t,
    cell: cell_t,
    type: type_t,
    list: list_t,
}

T = Union[
    RefT,
    TupleT,
    RecordT,
    FPtrT,
    NomT,
    PrimT,
    TopT,
    UnionT,
    TypeT,
    BottomT,
    MethT,
    ClosureT
]
SurfT = Union[RefT, FPtrT, NomT, PrimT, TopT, BottomT, MethT, ClosureT]
