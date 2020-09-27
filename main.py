from jit.CoreCPY import *
from jit.pe import Compiler
from jit import types


def f(x):
    y = 1
    if y:
        return 1 + y
    return [(y, [y])]


import dis


def f():
    # x : 0
    x = 1


c = Compiler()


def g(x, y):
    if x < 3:
        return x + y
    return "a"


for e in from_pyc(dis.Bytecode(g)):
    print(e)
#
m = c.specialise(g, types.none_t, types.int_t, types.int_t)
for e in (m.method.repr.c.__jit__):
    print(e)
print(m.return_type)
