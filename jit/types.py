from __future__ import annotations
from typing import Sequence, Union, Dict, Tuple
from dataclasses import dataclass
import ctypes

cell = type((lambda x: lambda : x)(1).__closure__[0])
NoneType = type(None)


class JitClosure(ctypes.Structure):
    _fields_ = [("free", ctypes.py_object), ('fptr', ctypes.py_object)]


@dataclass(frozen=True)
class RefT:
    x: T

    @staticmethod
    def to_py_type():
        return cell


@dataclass(frozen=True)
class RecordT:
    xs: Sequence[Tuple[str, SurfT]]

    @staticmethod
    def to_py_type():
        return dict


@dataclass(frozen=True)
class TupleT:
    xs: Sequence[SurfT]


    @staticmethod
    def to_py_type():
        return tuple


@dataclass(frozen=True)
class BoolT:
    pass

    @staticmethod
    def to_py_type():
        return bool


@dataclass(frozen=True)
class NoneT:
    pass

    @staticmethod
    def to_py_type():
        return NoneType


@dataclass(frozen=True)
class ClosureT:
    cells: T
    func: object

    @staticmethod
    def to_py_type():
        return JitClosure
#
# @dataclass(frozen=True)
# class DefaultT:
#     """
#     specify default arguments of functions
#     """
#     defaults: Sequence[T]
#     func: object


@dataclass(frozen=True)
class NomT:
    name: type
    members: Dict[str, T]
    static_members: Dict[str, T]

    def to_py_type(self):
        return self.name


@dataclass(frozen=True)
class PrimT:
    o: object


@dataclass(frozen=True)
class TopT:
    pass


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

noms = dict(
        dict=dict_t,
        int=int_t,
        float=float_t,
        str=str_t,
        tuple=tuple_t,
)
T = Union[RefT, TupleT, RecordT, BoolT, NoneT, ClosureT, NomT, PrimT, TopT]
SurfT = Union[RefT, BoolT, NoneT, ClosureT, NomT, PrimT, TopT]
