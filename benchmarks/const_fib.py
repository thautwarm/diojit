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
    if a.is_s() and b.is_s():
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
def fib(x):
    if x <= 2:
        return 1
    return fib(x + -1) + fib(x + -2)


jit_fib = jit.spec_call(fib, jit.oftype(int))


@jit.eagerjit
def try_const_fib(x):
    if try_const_le(x, 2):
        return 1
    return try_const_add(
        try_const_fib(
            try_const_add(x, -1),
        ),
        try_const_fib(
            try_const_add(x, -2),
        ),
    )


try_const_fib = jit.spec_call(try_const_fib, jit.ofval(20))


def bench(kind, f, number=2000):
    print(
        kind,
        timeit.timeit(
            "fib(x)",
            globals=dict(fib=f, x=20),
            number=number,
        ),
    )


print(fib(20))
print(jit_fib(20))
print(try_const_fib(20))

bench("pure py fib", fib)
bench("jit fib", jit_fib)
bench("jit fib_fast", try_const_fib)
