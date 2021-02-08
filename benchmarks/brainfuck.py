"""
jit time 140.34073400497437
pure py time 244.5001037120819
23280 ==? 23280
"""
import platform
import socket
import sys
import time

import os
import itertools
from pathlib import Path
import diojit as jit
import typing

sys.setrecursionlimit(2000)
print("brainfuck".center(50, "="))


INC = 1
MOVE = 2
LOOP = 3
PRINT = 4

OP = 0
VAL = 1


@jit.eagerjit
class Op(object):
    op: int
    val: typing.Union[int, list]

    def __init__(self, op, val):
        assert isinstance(op, int) and isinstance(val, (int, list))
        self.op = op
        self.val = val


@jit.eagerjit
class Tape(object):
    tape: list
    pos: int

    def __init__(self):
        self.tape = [0]
        self.pos = 0

    def get(self):
        return self.tape[self.pos]

    def inc(self, x):
        self.tape[self.pos] += x

    def move(self, x):
        self.pos += x
        while self.pos >= len(self.tape):
            self.tape.extend(itertools.repeat(0, len(self.tape)))


@jit.eagerjit
class Printer(object):
    sum1: int
    sum2: int
    quiet: bool

    def __init__(self, quiet):
        self.sum1 = 0
        self.sum2 = 0
        self.quiet = quiet

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


@jit.eagerjit
def _run(program, tape, p):
    i = 0
    n = len(program)
    while i < n:
        op = program[i]
        i += 1
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
                print_dio_ir=print,
            )
            _run_jit(self.ops, Tape(), p)
        else:
            _run(self.ops, Tape(), p)


p1 = Printer(True)
p2 = Printer(True)

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
