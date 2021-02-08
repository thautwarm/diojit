import diojit as jit
import operator
import timeit


def try_const_add(a, b):
    return a + b


def try_const_le(a, b):
    return a <= b


def try_const_eq(a, b):
    return a == b


@jit.register(try_const_add, create_shape=True)
def call_const_add(self: jit.Judge, *args: jit.AbsVal):
    if len(args) != 2:
        return NotImplemented
    a, b = args
    if a.is_literal() and b.is_literal():
        const = jit.S(operator.add(a.base, b.base))
        ret_types = (jit.S(type(const.base)),)
        return jit.CallSpec(const, const, ret_types)

    return self.spec(jit.S(operator.__add__), "__call__", list(args))


@jit.register(try_const_le, create_shape=True)
def call_const_le(self: jit.Judge, *args: jit.AbsVal):
    if len(args) != 2:
        return NotImplemented
    a, b = args
    if a.is_literal() and b.is_literal():
        const = jit.S(operator.__le__(a.base, b.base))
        ret_types = (jit.S(type(const.base)),)
        return jit.CallSpec(const, const, ret_types)

    return self.spec(jit.S(operator.__le__), "__call__", list(args))


@jit.register(try_const_eq, create_shape=True)
def call_const_eq(self: jit.Judge, *args: jit.AbsVal):
    if len(args) != 2:
        return NotImplemented
    a, b = args
    if a.is_literal() and b.is_literal():
        const = jit.S(operator.__eq__(a.base, b.base))
        ret_types = (jit.S(type(const.base)),)
        return jit.CallSpec(const, const, ret_types)

    return self.spec(jit.S(operator.__eq__), "__call__", list(args))


@jit.eagerjit
def fib(add, x):
    if x <= 2:
        return 1
    return add(fib(add, x + -1), fib(add, x + -2))


jit_fib = jit.jit_spec_call(fib, jit.S(try_const_add), jit.oftype(int))


@jit.eagerjit
def fib_fast(add, x):
    if try_const_le(x, 2):
        return 1
    return add(
        fib_fast(add, try_const_add(x, -1)), fib_fast(add, try_const_add(x, -2))
    )


jit_fib_fast = jit.jit_spec_call(
    fib_fast, jit.ofval(try_const_add), jit.ofval(20)
)


def bench(kind, f, number=2000):
    print(
        kind,
        timeit.timeit(
            "fib(add, x)",
            globals=dict(fib=f, add=try_const_add, x=20),
            number=number,
        ),
    )


print(fib(try_const_add, 20))
print(jit_fib(try_const_add, 20))
print(jit_fib_fast(try_const_add, 20))

bench("pure py fib", fib)
bench("jit fib", jit_fib)
bench("pure py fib_fast", fib_fast)
bench("jit fib_fast", jit_fib_fast)
