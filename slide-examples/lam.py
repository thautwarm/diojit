import platform
import socket
import sys
import time

import os
import itertools
from pathlib import Path
import diojit as jit


@jit.jit
def print(self, n):
    if self.quiet:
        self.sum1 = (self.sum1 + n) % 255
        self.sum2 = (self.sum2 + self.sum1) % 255
    else:
        sys.stdout.write(chr(n))
        sys.stdout.flush()



INC = 1
MOVE = 2
LOOP = 3
PRINT = 4

OP = 0
VAL = 1


class Op(object):
    def __init__(self, op, val):
        self.op = op
        self.val = val


jit.create_shape(Op, oop=True)


@jit.register(Op, attr="__getattr__")
def call_op_getattr(self, *args: jit.AbsVal):
    if len(args) != 2:
        return NotImplemented
    subject, attr = args
    if attr.is_s() and attr.is_literal() and isinstance(attr.base, str):
        attr_o = attr.base
        if attr_o in ("op", "val"):
            ret_types = jit.S(int)
            func = jit.S(jit.intrinsic("PyObject_GetAttr"))
            return jit.CallSpec(None, func(subject, attr), ret_types)
    return NotImplemented


class Tape(object):
    def __init__(self):
        self.tape = [0]
        self.pos = 0

    @jit.jit
    def get(self):
        return self.tape[self.pos]

    @jit.jit(fixed_references=[])
    def inc(self, x):
        self.tape[self.pos] += x

    @jit.jit(fixed_references=["len"])
    def move(self, x):
        self.pos += x
        while self.pos >= len(self.tape):
            self.tape.extend(itertools.repeat(0, len(self.tape)))


Tape_shape = jit.create_shape(Tape, oop=True)
Tape_shape.fields["move"] = jit.S(Tape.move)
Tape_shape.fields["inc"] = jit.S(Tape.inc)
Tape_shape.fields["get"] = jit.S(Tape.get)


@jit.register(Tape, attr="__getattr__")
def call_op_getattr(self, *args: jit.AbsVal):
    if len(args) != 2:
        return NotImplemented

    subject, attr = args
    if attr.is_s() and attr.is_literal() and isinstance(attr.base, str):
        attr_o = attr.base
        if t := {"tape": list, "pos": int}.get(attr_o):
            ret_types = (jit.S(t),)
            func = jit.S(jit.intrinsic("PyObject_GetAttr"))
            return jit.CallSpec(None, func(subject, attr), ret_types)
    return NotImplemented


class Printer(object):
    def __init__(self, quiet):
        self.sum1 = 0
        self.sum2 = 0
        self.quiet = quiet

    @jit.jit
    def print(self, n):
        if self.quiet:
            self.sum1 = (self.sum1 + n) % 255
            self.sum2 = (self.sum2 + self.sum1) % 255
        else:
            sys.stdout.write(chr(n))
            sys.stdout.flush()

    @property
    def checksum(self):
        return (self.sum2 << 8) | self.sum1


Printer_shape = jit.create_shape(Printer, oop=True)
Printer_shape.fields["print"] = jit.S(Printer.print)


@jit.register(Printer, attr="__getattr__")
def call_op_getattr(self, *args: jit.AbsVal):
    if len(args) != 2:
        return NotImplemented

    subject, attr = args
    if attr.is_s() and attr.is_literal() and isinstance(attr.base, str):
        attr_o = attr.base
        if t := {"sum1": int, "sum2": int, "quiet": bool}.get(attr_o):
            ret_types = (jit.S(t),)
            func = jit.S(jit.intrinsic("PyObject_GetAttr"))
            return jit.CallSpec(None, func(subject, attr), ret_types)
    return NotImplemented


def parse(iterator):
    res = []
    while True:
        try:
            c = iterator.__next__()
        except StopIteration:
            break

        if c == "+":
            res.append(Op(INC, 1))
        elif c == "-":
            res.append(Op(INC, -1))
        elif c == ">":
            res.append(Op(MOVE, 1))
        elif c == "<":
            res.append(Op(MOVE, -1))
        elif c == ".":
            res.append(Op(PRINT, 0))
        elif c == "[":
            res.append(Op(LOOP, parse(iterator)))
        elif c == "]":
            break

    return res


@jit.jit(fixed_references=["INC", "MOVE", "LOOP", "PRINT", "_run"])
def _run(program, tape, p):
    for op in program:
        if op.op == INC:
            tape.inc(op.val)
        elif op.op == MOVE:
            tape.move(op.val)
        elif op.op == LOOP:
            while tape.get() > 0:
                _run(op.val, tape, p)
        elif op.op == PRINT:
            p.print(tape.get())


class Program(object):
    def __init__(self, code):
        self.ops = parse(iter(code))

    def run(self, p, use_jit: bool):
        if use_jit:
            _run_jit = jit.jit_spec_call(
                _run,
                jit.oftype(list),
                jit.oftype(Tape),
                jit.oftype(Printer),
            )
            _run_jit(self.ops, Tape(), p)
        else:
            _run(self.ops, Tape(), p)


jit.jit_spec_call(
    Tape.move,
    jit.oftype(Tape),
    jit.oftype(int),
    print_dio_ir=print,
)

p1 = Printer(False)
p2 = Printer(False)

prog = Program(
    """>++[<+++++++++++++>-]<[[>+>+<<-]>[<+>-]++++++++
[>++++++++<-]>.[-]<<>++++++++++[>++++++++++[>++
++++++++[>++++++++++[>++++++++++[>++++++++++[>+
+++++++++[-]<-]<-]<-]<-]<-]<-]<-]++++++++++."""
)
n = time.time()
prog.run(p2, use_jit=True)
print("jit time", time.time() - n)

n = time.time()
prog.run(p1, use_jit=False)
print("pure py time", time.time() - n)


print(p1.checksum, "==?", p2.checksum)
