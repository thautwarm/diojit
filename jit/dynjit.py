from __future__ import annotations
from typing import NamedTuple, Union, Sequence, Type
from dataclasses import dataclass
from jit import types
import sys

Symbol = object


@dataclass(frozen=True)
class S:
    c: object

    def __repr__(self):
        import types
        # noinspection PyTypeChecker
        if isinstance(self.c, (types.FunctionType, types.BuiltinFunctionType)):
            return self.c.__name__
        return repr(self.c)


@dataclass(frozen=True)
class D:
    n: Symbol

    def __repr__(self):
        return f'D{self.n}'


Repr = Union[S, D]


class AbstractValue(NamedTuple):
    repr: Repr
    type: types.T

    def __repr__(self):
        return f'<{self.type}>{self.repr}'


@dataclass(frozen=True)
class Call:
    f: Expr
    args: Sequence[Expr]

    def __repr__(self):
        return '{}({})'.format(repr(self.f), ', '.join(map(repr, self.args)))


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


def pprint(xs: Sequence[Stmt], io=sys.stdout.write):
    for each in xs:
        pretty(io, each, 0)


def pretty(io, stmt, indent):
    io(' ' * indent)
    if isinstance(stmt, Assign):
        io("{} = {}".format(repr(stmt.target), repr(stmt.expr)))
        io('\n')

    elif isinstance(stmt, Goto):
        io("goto ")
        io(repr(stmt.lbl))
        io('\n')

    elif isinstance(stmt, Label):
        io("label ")
        io(repr(stmt.lbl))
        io('\n')

    elif isinstance(stmt, Return):
        io('return ')
        io(repr(stmt.expr))
        io('\n')

    elif isinstance(stmt, If):
        io('if ')
        io(repr(stmt.cond))
        io('\n')
        prefix = ' ' * (indent + 2)
        for each in stmt.arm1:
            io(prefix)
            pretty(io, each, indent + 2)
        io('else\n')
        for each in stmt.arm2:
            io(prefix)
            pretty(io, each, indent + 2)

    elif isinstance(stmt, TypeCheck):
        io('typecase ')
        io(repr(stmt.expr))
        io(' hastype ')
        io(repr(stmt.type))
        io('\n')
        prefix = ' ' * (indent + 2)
        for each in stmt.arm1:
            io(prefix)
            pretty(io, each, indent + 2)
        io('else\n')
        for each in stmt.arm2:
            io(prefix)
            pretty(io, each, indent + 2)

