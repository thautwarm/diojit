from jit.CoreCPY import *
from jit.pe import Compiler
from jit import types, dynjit, prims, flat
from jit.ll.closure import Closure

#
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

__fix__ = ["ff", "g"]


@c.aware
def ff():
    return "a"


@c.aware
def g(x, y):
    if x < 3:
        return x + y
    return ff()


print("CORE CPY".center(100, "-"))
for e in from_pyc(dis.Bytecode(g)):
    print(e)
print("DYNJIT IR".center(100, "-"))
#
m = c.specialise(g, types.int_t, types.int_t)
dj = m.method.repr.c.__jit__
dynjit.pprint(dj)
print(m.return_type)

print("=".center(100, "="))


@c.aware
def g(x, y):
    if x < 3:
        return x + y
    return g(2, y)


print("CORE CPY".center(100, "-"))
for e in from_pyc(dis.Bytecode(g)):
    print(e)
print("DYNJIT IR".center(100, "-"))
#
m = c.specialise(g, types.int_t, types.int_t)
dj = m.method.repr.c.__jit__
dynjit.pprint(dj)
print(m.return_type)

print("=".center(100, "="))


@c.aware
def ff(x):
    if x < 0:
        return "a"
    else:
        return 1


@c.aware
def g(x, y):
    if x < 3:
        return x + y
    return ff(5)


print("CORE CPY".center(100, "-"))
for e in from_pyc(dis.Bytecode(g)):
    print(e)
print("DYNJIT IR".center(100, "-"))
#
m = c.specialise(g, types.int_t, types.int_t)
dj = m.method.repr.c.__jit__
dj = list(flat.linearize(dj))
flat.pprint(dj)
print(m.return_type)

__fix__ = ["int", "pp", "isinstance", "float", "S", "Closure"]

c = Compiler()


class S:
    @c.aware
    def f_dyn(self):
        return 2

    @staticmethod
    @c.aware
    def f_sta():
        return 1


def mk_member_(d, f: types.NomT, attr: str):
    o = getattr(f.name, attr)
    t = prims.ct(o)
    d[attr] = dynjit.AbstractValue(dynjit.S(o), t)


@c.assume(S)
def _(f: types.NomT):
    mk_member_(f.methods, f, "f_dyn")
    mk_member_(f.static_methods, f, "f_sta")


print(id(types.noms[list]))


@c.assume(list)
def _(f: types.NomT):
    mk_member_(f.methods, f, "append")
    mk_member_(f.static_methods, f, "pop")


print(id(types.noms[list]))


@c.aware
def pp(x):
    j = 1

    while j < 0:
        y = S()
        a = y.f_dyn()
        b = y.f_sta()
        c = []
        c.append(1)
        j = j + 1


print("CORE CPY".center(100, "-"))
for e in from_pyc(dis.Bytecode(pp)):
    print(e)
print("DYNJIT IR".center(100, "-"))
#
m = c.specialise(pp, types.int_t)
dj = m.method.repr.c.__jit__
dynjit.pprint(dj)
# xs = []
# dj = list(flat.linearize(dj))
# flat.pprint(dj)
print(m.return_type)


__fix__ += ["fptr"]


@c.aware
def fptr(x, y, z):
    return x + y + z


@c.aware
def ppp(x):
    f = Closure(x, fptr)
    return f(2, 3)


print("CORE CPY".center(100, "-"))
for e in from_pyc(dis.Bytecode(ppp)):
    print(e)
print("DYNJIT IR".center(100, "-"))
#
m = c.specialise(ppp, types.int_t)
dj = m.method.repr.c.__jit__
dynjit.pprint(dj)
# xs = []
# dj = list(flat.linearize(dj))
# flat.pprint(dj)
print(m.return_type)
