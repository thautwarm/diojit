from jit import types, pe
from jit.ll.closure import Closure
from timeit import timeit

print("closure(call once)".center(50, "="))

__fix__ = ["nest", "jit_main", "Closure"]

c = pe.Compiler()


@c.aware
def nest(closure, z):
    x = closure[0]
    y = closure[1]
    return x + y + z


@c.aware
def jit_main(x, y):
    clo = Closure((x, y), nest)
    # 3.0 * 3 + 4 + 5 + 6 = 24
    return clo(
        4.0
    )  # + clo(5.0) + clo(6.0) + clo(7.0) + clo(8.0) + clo(9.0)


def purepy_main(x, y):
    clo = lambda z: x + y + z

    # 3.0 * 3 + 4 + 5 + 6 = 24
    return clo(
        4.0
    )  # + clo(5.0) + clo(6.0) + clo(7.0) + clo(8.0) + clo(9.0)


c.debug.add(pe.DEBUG.print_dynjit_ir)
c.debug.add(pe.DEBUG.print_generated_cython)

jit_main_float_float = c.optimize_by_args(jit_main, 1.0, 2.0)
print(jit_main_float_float(1.0, 2.0))
print(purepy_main(1.0, 2.0))


print(
    timeit(
        "f(1.0, 2.0)",
        globals=dict(f=jit_main_float_float),
        number=1000000,
    ),
    "s/1000000 call",
)

print(
    timeit(
        "f(1.0, 2.0)",
        globals=dict(f=purepy_main),
        number=1000000,
    ),
    "s/1000000 call",
)

print("closure(call 6 times)".center(50, "="))

__fix__ = ["nest", "jit_main", "Closure"]

c = pe.Compiler()


@c.aware
def nest(closure, z):
    x = closure[0]
    y = closure[1]
    return x + y + z


@c.aware
def jit_main(x, y):
    clo = Closure((x, y), nest)
    # 3.0 * 3 + 4 + 5 + 6 = 24
    return (
        clo(4.0) + clo(5.0) + clo(6.0) + clo(7.0) + clo(8.0) + clo(9.0)
    )


def purepy_main(x, y):
    clo = lambda z: x + y + z

    # 3.0 * 3 + 4 + 5 + 6 = 24
    return (
        clo(4.0) + clo(5.0) + clo(6.0) + clo(7.0) + clo(8.0) + clo(9.0)
    )


c.debug.add(pe.DEBUG.print_dynjit_ir)
c.debug.add(pe.DEBUG.print_generated_cython)

jit_main_float_float = c.optimize_by_args(jit_main, 1.0, 2.0)
print(jit_main_float_float(1.0, 2.0))
print(purepy_main(1.0, 2.0))

print("closure(call once)".center(50, "="))

print(
    timeit(
        "f(1.0, 2.0)",
        globals=dict(f=jit_main_float_float),
        number=1000000,
    ),
    "s/1000000 call",
)

print(
    timeit(
        "f(1.0, 2.0)",
        globals=dict(f=purepy_main),
        number=1000000,
    ),
    "s/1000000 call",
)
