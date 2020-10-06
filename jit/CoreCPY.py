from __future__ import annotations
from dataclasses import dataclass
from typing import Union
from types import CodeType
import dis
import jit.opname as opname


Symbol = object


@dataclass(frozen=True)
class Label:
    lbl: Symbol


@dataclass(frozen=True)
class Constant:
    c: object


@dataclass(frozen=True)
class Load:
    sym: Symbol


@dataclass(frozen=True)
class Store:
    sym: Symbol


@dataclass(frozen=True)
class JumpIf:
    """
    TOS = pop()
    if expect == TOS:
        if keep:
            push(TOS)
        goto lbl
    """

    expect: bool
    keep: bool
    lbl: Symbol


@dataclass(frozen=True)
class Jump:
    lbl: Symbol


@dataclass(frozen=True)
class Call:
    narg: int


@dataclass(frozen=True)
class Rot:
    narg: int


@dataclass(frozen=True)
class Pop:
    pass


@dataclass(frozen=True)
class Peek:
    n: int


@dataclass(frozen=True)
class Return:
    pass


Instr = Union[
    Return, Peek, Pop, Call, Jump, JumpIf, Store, Load, Constant, Label
]


def from_pyc(co: dis.Bytecode):
    from jit.from_pyc import _from_pyc

    codeobj = co.codeobj
    for each in co:
        each: dis.Instruction = each
        if each.is_jump_target:
            yield Label(each.offset)

        if each.opcode is opname.EXTENDED_ARG:
            # dis.Bytecode handles EXTENDED_ARG
            continue

        yield from _from_pyc(each, codeobj)
