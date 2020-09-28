from jit.CoreCPY import *
from jit.pe import Compiler
from jit import types, dynjit


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

__fix__ = ['ff', 'g']


def ff():
    return "a"


def g(x, y):
    if x < 3:
        return x + y
    return ff()


for e in from_pyc(dis.Bytecode(g)):
    print(e)
#
m = c.specialise(g, types.none_t, types.int_t, types.int_t)
dj = m.method.repr.c.__jit__
dynjit.pprint(dj)
print(m.return_type)

print('+++++++++++++++++++++++++')

def g(x, y):
    if x < 3:
        return x + y
    return g(2, y)


for e in from_pyc(dis.Bytecode(g)):
    print(e)
#
m = c.specialise(g, types.none_t, types.int_t, types.int_t)
dj = m.method.repr.c.__jit__
dynjit.pprint(dj)
print(m.return_type)
