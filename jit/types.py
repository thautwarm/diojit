from __future__ import annotations
from typing import Sequence, Dict, Set, FrozenSet
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
    x: TAbs

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
    narg: int
    func: pytypes.FunctionType

    @staticmethod
    def to_py_type():
        return pytypes.FunctionType

    def __repr__(self):
        return f"{self.func.__name__}"


@dataclass(frozen=True, eq=True)
class JitFPtrT:
    narg: int

    def to_py_type(self):
        from jit.ll.infr import NJitFunctions

        return NJitFunctions[self.narg]

    def __repr__(self):
        return f"jit/{self.narg}"


@dataclass(frozen=True, eq=True)
class MethT:
    self: TAbs
    func: TAbs

    @staticmethod
    def to_py_type():
        # TODO: a cython structure
        return pytypes.MethodType

    def __repr__(self):
        return f"{self.func!r}({self.self!r})"


@dataclass(frozen=True, eq=True)
class ClosureT:
    cell: TAbs
    func: TAbs

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
    members: Dict[str, dynjit.T]
    methods: Dict[str, dynjit.Expr]
    static_methods: Dict[str, dynjit.Expr]

    def __init__(
        self,
        name: type,
        members: Dict[str, dynjit.T],
        methods: Dict[str, dynjit.Expr],
        static_methods: Dict[str, dynjit.Expr],
    ):
        self.name = name
        self.members = members
        self.methods = methods
        self.static_methods = static_methods

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


@dataclass(eq=True, frozen=True, unsafe_hash=True)
class UnionT:
    alts: FrozenSet[TAbs]

    @staticmethod
    def to_py_type():
        return TypeError

    def __repr__(self):
        return "|".join(map(repr, self.alts))


@dataclass(eq=True, frozen=True)
class ConstT:

    def to_py_type(self):
        raise NotImplementedError

    def __repr__(self):
        return "const"


bool_methods = {}
bool_static_methods = {}
bool_t = NomT(bool, {}, bool_methods, bool_static_methods)

int_methods = {}
int_static_methods = {}
int_t = NomT(int, {}, int_methods, int_static_methods)

float_methods = {}
float_static_methods = {}
float_t = NomT(float, {}, float_methods, float_static_methods)

str_methods = {}
str_static_methods = {}
str_t = NomT(str, {}, str_methods, str_static_methods)

tuple_methods = {}
tuple_static_methods = {}
tuple_t = NomT(tuple, {}, tuple_methods, tuple_static_methods)

dict_methods = {}
dict_static_methods = {}
dict_t = NomT(dict, {}, dict_methods, dict_static_methods)

none_methods = {}
none_static_methods = {}
none_t = NomT(NoneType, {}, none_methods, none_static_methods)

list_methods = {}
list_static_methods = {}
list_t = NomT(list, {}, list_methods, list_static_methods)

cell_methods = {}
cell_static_methods = {}
cell_t = NomT(cell, {}, cell_methods, cell_static_methods)

type_methods = {}
type_static_methods = {}
type_t = NomT(type, {}, type_methods, type_static_methods)

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

TAbs = Union[
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
    ClosureT,
    JitFPtrT,
    ConstT
]
SurfT = Union[
    RefT, FPtrT, NomT, PrimT, TopT, BottomT, MethT, ClosureT, JitFPtrT, ConstT
]
