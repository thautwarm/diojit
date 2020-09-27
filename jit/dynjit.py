from __future__ import annotations
from typing import NamedTuple, Union, Sequence, Type
from dataclasses import dataclass
from jit import types

Symbol = object


@dataclass(frozen=True)
class S:
    c: object


@dataclass(frozen=True)
class D:
    n: Symbol


Repr = Union[S, D]


class AbstractValue(NamedTuple):
    repr: Repr
    type: types.T


@dataclass(frozen=True)
class Call:
    f: Expr
    args: Sequence[Expr]


Expr = Union[Call, AbstractValue]


@dataclass(frozen=True)
class Assign:
    target: AbstractValue
    expr: Expr


@dataclass(frozen=True)
class Goto:
    lbl: Symbol


@dataclass(frozen=True)
class Label:
    lbl: Symbol


@dataclass(frozen=True)
class Return:
    expr: Expr


@dataclass(frozen=True)
class TypeCheck:
    expr: Expr
    type: types.T
    arm1: Sequence[Stmt]
    arm2: Sequence[Stmt]


@dataclass(frozen=True)
class If:
    cond: Expr
    arm1: Sequence[Stmt]
    arm2: Sequence[Stmt]


Stmt = Union[Assign, Goto, Label, Return, TypeCheck, If]
