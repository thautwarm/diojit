from jit.dynjit import *
from jit import types, dynjit
from dataclasses import dataclass
from typing import Optional, Union, Iterable

del TypeCheck
del If


@dataclass(frozen=True)
class TypeCheck:
    expr: Expr
    type: types.T
    jmp: Symbol


@dataclass(frozen=True)
class If:
    cond: Expr
    jmp: Symbol


Instr = Union[Assign, Goto, Label, Return, TypeCheck, If]


def gen_label(lbls: list):
    n = len(lbls)
    s = "genlabel{}".format(n)
    lbls.append(s)
    return s


def linearize(stmts: Iterable[Stmt]):
    labels = []
    for each in stmts:
        yield from linearize_each(each, labels)


def linearize_each(stmt: Stmt, labels: list):
    if isinstance(stmt, dynjit.If):
        tag_true = gen_label(labels)
        tag_final = gen_label(labels)

        yield If(stmt.cond, tag_true)
        for each in stmt.arm2:
            yield from linearize_each(each, labels)
        yield Goto(tag_final)
        yield Label(tag_true)

        for each in stmt.arm1:
            yield from linearize_each(each, labels)
        yield Label(tag_final)
    elif isinstance(stmt, dynjit.TypeCheck):
        tag_true = gen_label(labels)
        tag_final = gen_label(labels)

        yield TypeCheck(stmt.expr, stmt.type, tag_true)
        for each in stmt.arm2:
            yield from linearize_each(each, labels)
        yield Goto(tag_final)
        yield Label(tag_true)

        for each in stmt.arm1:
            yield from linearize_each(each, labels)
        yield Label(tag_final)
    else:
        yield stmt


def pprint(xs: Sequence[Instr], io=sys.stdout.write):
    for each in xs:
        pretty_instr(io, each, 0)


def pretty_instr(io, stmt, indent):
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
        io(prefix0)
        io(f"    {stmt.jmp}\n")

    elif isinstance(stmt, TypeCheck):
        io("typecase ")
        io(repr(stmt.expr))
        io(" hastype ")
        io(repr(stmt.type))
        io("\n")
        io(prefix0)
        io(f"    {stmt.jmp}\n")

    elif isinstance(stmt, Goto):
        io("goto ")
        io(repr(stmt.lbl))
        io("\n")
    else:
        raise TypeError(stmt)
