from jit import types
from jit.pe import Compiler, DEBUG
from timeit import timeit

c = Compiler()

__fix__ = [
    "pp",
    "float",
    "isinstance",
    "one",
    "pp",
    "int",
    "float",
    "str",
]
c.debug.add(DEBUG.print_dynjit_ir)
c.debug.add(DEBUG.print_generated_cython)


@c.aware
def one(x):
    if isinstance(x, float):
        return 1.0
    elif isinstance(x, str):
        return "-"
    elif isinstance(x, int):
        return 1


@c.aware
def pp(x, n):
    j = 0
    s = x
    while j < n:
        s = s + one(s)
        j = j + 1
    return s


# pp_int = c.optimize_by_shapes(pp, types.int_t, types.int_t)
pp_int = c.optimize_by_shapes(pp, types.int_t, types.int_t)
print(pp_int(0, 10))
print(pp(0, 10))


print(
    timeit("pp(0, 10)", globals=dict(pp=pp_int), number=1000000),
    "s/1000000 call",
)


print(
    timeit("pp(0, 10)", globals=dict(pp=pp), number=1000000),
    "s/1000000 call",
)
