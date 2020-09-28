from __future__ import annotations
from typing import Sequence, Union, Dict, Tuple, Set
from dataclasses import dataclass
import ctypes
import types as pytypes

CellType = type((lambda x: lambda: x)(1).__closure__[0])
NoneType = type(None)


class JitClosure(ctypes.Structure):
    _fields_ = [("free", ctypes.py_object), ('fptr', ctypes.py_object)]


@dataclass(frozen=True)
class RefT:
    x: T

    @staticmethod
    def to_py_type():
        return CellType

    def __repr__(self):
        return f'ref<{self.x!r}>'


@dataclass(frozen=True, unsafe_hash=True)
class RecordT:
    xs: Sequence[Tuple[str, SurfT]]

    @staticmethod
    def to_py_type():
        return dict

    def __repr__(self):
        return '{{{}}}'.format(','.join(f'{k}: {t!r}' for k, t in self.xs))


@dataclass(frozen=True, unsafe_hash=True)
class TupleT:
    xs: Sequence[SurfT]

    @staticmethod
    def to_py_type():
        return tuple

    def __repr__(self):
        return '<{}>'.format(','.join(map(repr, self.xs)))


@dataclass(frozen=True)
class ClosureT:
    celltype: T
    func: object

    @staticmethod
    def to_py_type():
        return JitClosure

    def __repr__(self):
        return f'closure<{self.celltype!r}, {self.func.__name__}>'


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
    members: Dict[str, T]
    static_members: Dict[str, T]

    def __init__(self, name: type, members: Dict[str, T], static_members: Dict[str, T]):
        self.name = name
        self.members = members
        self.static_members = static_members

    def to_py_type(self):
        return self.name

    def __repr__(self):
        return f'{self.name.__module__}.{self.name.__name__}'


@dataclass(frozen=True)
class PrimT:
    o: object

    def to_py_type(self):
        return type(self.o)

    def __repr__(self):
        # noinspection PyTypeChecker
        # if isinstance(self.o, (pytypes.FunctionType, pytypes.BuiltinFunctionType)):
        #     s = self.o.__name__
        return f'{self.o.__name__}'


@dataclass(frozen=True)
class TopT:

    @staticmethod
    def to_py_type():
        return object

    def __repr__(self):
        return 'top'


@dataclass(frozen=True)
class TypeT:
    type: SurfT

    @staticmethod
    def to_py_type():
        return type

    def __repr__(self):
        return f'type<{self.type}>'


@dataclass(frozen=True)
class UnionT:
    alts: Sequence[T]

    @staticmethod
    def to_py_type():
        return TypeError

    def __repr__(self):
        return '|'.join(map(repr, self.alts))


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

noms = {
        dict: dict_t, int: int_t, float: float_t, str: str_t, tuple: tuple_t, bool: bool_t, NoneType: none_t
}

T = Union[RefT, TupleT, RecordT, ClosureT, NomT, PrimT, TopT, UnionT, TypeT]
SurfT = Union[RefT, ClosureT, NomT, PrimT, TopT]
