from jit import types, dynjit
from jit.pe import Compiler, DEBUG
from jit.ll.closure import Closure
from jit.codegen.cython_loader import compile_module


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
    _1 = one(x)
    while j < n:
        s = s + _1
        j = j + 1
    return s


# pp_int = c.optimize_by_shapes(pp, types.int_t, types.int_t)
pp_float = c.optimize_by_shapes(pp, types.float_t, types.int_t)
print(pp_float(0.0, 10))
print(pp(0, 10))

# mod = compile_module(
#     """
# cpdef float pp(double x):
#     cdef double j = 2.0
#     while x < 20.0:
#         j = j + x
#         x = x + 3.0
#     return j
# """
# )
#
from timeit import timeit


print(
    timeit("pp(0.0, 100)", globals=dict(pp=pp_float), number=1000000),
    "s/1000000 call",
)


print(
    timeit("pp(0.0, 100)", globals=dict(pp=pp), number=1000000),
    "s/1000000 call",
)
