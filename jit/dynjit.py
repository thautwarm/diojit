from __future__ import annotations
from typing import (
    NamedTuple,
    Union,
    Sequence,
    Optional,
    TYPE_CHECKING,
    TypeVar,
)
from dataclasses import dataclass, field
import sys

if TYPE_CHECKING:
    from jit import types

Symbol = object

T = TypeVar("T")


@dataclass(frozen=True)
class S:
    c: object

    def __repr__(self):
        import types

        # noinspection PyTypeChecker
        if isinstance(
            self.c, (types.FunctionType, types.BuiltinFunctionType)
        ):
            return self.c.__name__
        return repr(self.c)


@dataclass(frozen=True)
class D:
    n: Symbol

    def __repr__(self):
        return f"D{self.n}"


Repr = Union[S, D]


@dataclass(frozen=True, eq=True, order=True)
class AbstractValue:
    repr: Repr
    type: types.T

    def __post_init__(self):
        assert isinstance(self.repr, (S, D))

    def __repr__(self):
        return f"<{self.type}>{self.repr}"

    def with_type(self, ty: types.T):
        return AbstractValue(self.repr, ty)


@dataclass(frozen=True)
class Call:
    f: Expr
    args: Sequence[Expr]
    type: types.T = field(default=None)

    def __post_init__(self):
        assert isinstance(self.f, (Call, AbstractValue)) and all(
            isinstance(e, (Call, AbstractValue)) for e in self.args
        )

    def __repr__(self):
        return "{}({})".format(
            repr(self.f), ", ".join(map(repr, self.args))
        )

    def with_type(self, ty: types.T):
        return Call(self.f, self.args, ty)


Expr = Union[Call, AbstractValue]


@dataclass(frozen=True)
class Assign:
    target: Optional[AbstractValue]
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
        pretty_stmt(io, each, 0)


def pretty_stmt(io, stmt, indent):
    prefix0 = " " * indent
    io(prefix0)
    if isinstance(stmt, Assign):
        io("{} = {}\n".format(repr(stmt.target), repr(stmt.expr)))

    elif isinstance(stmt, Goto):
        io("goto ")
        io(repr(stmt.lbl))
        io("\n")

    elif isinstance(stmt, Label):
        io("label ")
        io(repr(stmt.lbl))
        io("\n")

    elif isinstance(stmt, Return):
        io("return ")
        io(repr(stmt.expr))
        io("\n")

    elif isinstance(stmt, If):
        io("if ")
        io(repr(stmt.cond))
        io("\n")
        for each in stmt.arm1:
            pretty_stmt(io, each, indent + 2)
        io(prefix0)

        io("else\n")
        for each in stmt.arm2:
            pretty_stmt(io, each, indent + 2)
        if not stmt.arm2:
            io("\n")

    elif isinstance(stmt, TypeCheck):
        io("typecase ")
        io(repr(stmt.expr))
        io(" hastype ")
        io(repr(stmt.type))
        io("\n")
        for each in stmt.arm1:
            pretty_stmt(io, each, indent + 2)
        io(prefix0)

        io("else\n")
        for each in stmt.arm2:
            pretty_stmt(io, each, indent + 2)
        if not stmt.arm2:
            io("\n")
    elif isinstance(stmt, Goto):
        io("goto ")
        io(repr(stmt.lbl))
        io("\n")
    else:
        raise TypeError(stmt)
