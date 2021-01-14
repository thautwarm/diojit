from pyximport import install
from timeit import timeit
import string

install()
_hash = hash("constant-key")
data = dict(a=1, kkkkk=2)
data["constant-key"] = 50


def empty1(_):
    pass


def empty2(_, __):
    pass


print("dict non-constant key".center(100, "="))
import dict_nonconstant_key

print(dict_nonconstant_key.test(data, "constant-key"))


def test_py(data, k):
    return data[k]


print(
    timeit(
        "f(data, k)",
        number=1900000,
        globals=dict(
            f=dict_nonconstant_key.test, data=data, k="constant-key"
        ),
    )
)
print(
    timeit(
        "f(data, k)",
        number=1900000,
        globals=dict(f=test_py, data=data, k="constant-key"),
    )
)

print(
    timeit(
        "f(data, k)",
        number=1900000,
        globals=dict(f=empty2, data=data, k="constant-key"),
    )
)


code = string.Template(
    open("dict_constant_key.pyx.in").read()
).substitute(hash=_hash)
with open("dict_constant_key.pyx", "w") as f:
    f.write(code)

import dict_constant_key

print(dict_constant_key.test(data))
print("dict constant key".center(100, "="))


def get_const_item(data):
    a = data["constant-key"]
    return a


print(
    timeit(
        "f(data)",
        number=1900000,
        globals=dict(f=dict_constant_key.test, data=data),
    )
)
print(
    timeit(
        "f(data)",
        number=1900000,
        globals=dict(f=get_const_item, data=data),
    )
)
print(
    timeit("f(data)", number=1900000, globals=dict(f=empty1, data=data))
)
print("sum n".center(100, "="))
import sum_n


def sum_n_py(n):
    i = 0
    S = 0
    while i < n:
        S = S + i
        i = i + 1
    return S


print(sum_n.test(10) == sum_n_py(10))
print(
    timeit(
        "f(data)", number=1900000, globals=dict(f=sum_n.test, data=10)
    )
)
print(
    timeit("f(data)", number=1900000, globals=dict(f=sum_n_py, data=10))
)
print(
    timeit("f(data)", number=1900000, globals=dict(f=empty1, data=10))
)

print(
    timeit(
        "f(data)", number=1900000, globals=dict(f=sum_n.test, data=100)
    )
)
print(
    timeit(
        "f(data)", number=1900000, globals=dict(f=sum_n_py, data=100)
    )
)
print(
    timeit("f(data)", number=1900000, globals=dict(f=empty1, data=100))
)

import parse_float

print("parse float".center(100, "="))
print(parse_float.test_str("1.20"))

print(
    timeit(
        "f(data)",
        number=1900000,
        globals=dict(f=parse_float.test_str, data="123.456"),
    )
)
print(
    timeit(
        "f(data)", number=1900000, globals=dict(f=float, data="123.456")
    )
)
print(
    timeit(
        "f(data)",
        number=1900000,
        globals=dict(f=empty1, data="123.456"),
    )
)

print(
    timeit(
        "f(data)",
        number=1900000,
        globals=dict(f=parse_float.test_str, data="123456.111111"),
    )
)
print(
    timeit(
        "f(data)",
        number=1900000,
        globals=dict(f=float, data="123456.111111"),
    )
)
print(
    timeit(
        "f(data)",
        number=1900000,
        globals=dict(f=empty1, data="123456.111111"),
    )
)

import many_assignments

print("many assignments".center(100, "="))

print(many_assignments.test8_0())


def test8():
    a1 = 1
    a2 = a1
    a3 = a2
    a4 = a3
    a5 = a4
    a6 = a5
    a7 = a6
    a8 = a7
    return a8


def no_arg_empty():
    pass


print(
    timeit(
        "test8()",
        number=1900000,
        globals=dict(test8=many_assignments.test8_0),
    )
)
print(timeit("test8()", number=1900000, globals=dict(test8=test8)))
print(
    timeit("test8()", number=1900000, globals=dict(test8=no_arg_empty))
)


def test16():
    a1 = 1
    a2 = a1
    a3 = a2
    a4 = a3
    a5 = a4
    a6 = a5
    a7 = a6
    a8 = a7
    a9 = a8
    a10 = a9
    a11 = a10
    a12 = a11
    a13 = a12
    a14 = a13
    a15 = a14
    a16 = a15
    return a16


def test24():
    a1 = 1
    a2 = a1
    a3 = a2
    a4 = a3
    a5 = a4
    a6 = a5
    a7 = a6
    a8 = a7
    a9 = a8
    a10 = a9
    a11 = a10
    a12 = a11
    a13 = a12
    a14 = a13
    a15 = a14
    a16 = a15
    a17 = a16
    a18 = a17
    a19 = a18
    a20 = a19
    a21 = a20
    a22 = a21
    a23 = a22
    a24 = a23
    return a24


print(
    timeit(
        "test16()",
        number=1900000,
        globals=dict(test16=many_assignments.test16_0),
    )
)
print(timeit("test16()", number=1900000, globals=dict(test16=test16)))
print(
    timeit(
        "test16()", number=1900000, globals=dict(test16=no_arg_empty)
    )
)

print(
    timeit(
        "test24()", number=1900000, globals=dict(test24=test24)
    )
)

