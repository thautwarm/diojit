from jit import types, pe
from timeit import timeit

c = pe.Compiler()
print("2 fields".center(50, "="))


class Point:
    __slots__ = ["x", "y"]

    def __init__(self, x, y):
        self.x = x
        self.y = y


@c.assume(Point)
def _(nom: types.NomT):
    nom.members["x"] = types.int_t
    nom.members["y"] = types.int_t


@c.aware
def sum_data(x: Point):
    return x.x + x.y


data_t = types.noms[Point]
sum_data_typed = c.optimize_by_shapes(sum_data, data_t)
data = Point(1, 2)
print(sum_data_typed(data))
print(sum_data(data))

print(
    timeit(
        "sum_data(data)",
        globals=dict(data=data, sum_data=sum_data_typed),
        number=1000000,
    ),
    "s/1000000 call",
)


print(
    timeit(
        "sum_data(data)",
        globals=dict(data=data, sum_data=sum_data),
        number=1000000,
    ),
    "s/1000000 call",
)

print("5 fields".center(50, "="))


class Data:
    __slots__ = ["a1", "a2", "a3", "a4", "a5"]

    def __init__(self, a1, a2, a3, a4, a5):
        self.a1 = a1
        self.a2 = a2
        self.a3 = a3
        self.a4 = a4
        self.a5 = a5


c = pe.Compiler()


@c.assume(Data)
def _(nom: types.NomT):
    nom.members["a1"] = types.int_t
    nom.members["a2"] = types.int_t
    nom.members["a3"] = types.int_t
    nom.members["a4"] = types.int_t
    nom.members["a5"] = types.int_t


@c.aware
def sum_data(x: Data):
    return x.a1 + x.a2 + x.a3 + x.a4 + x.a5


data_t = types.noms[Data]
sum_data_typed = c.optimize_by_shapes(sum_data, data_t)
data = Data(1, 2, 3, 4, 5)
print(sum_data_typed(data))
print(sum_data(data))

print(
    timeit(
        "sum_data(data)",
        globals=dict(data=data, sum_data=sum_data_typed),
        number=1000000,
    ),
    "s/1000000 call",
)


print(
    timeit(
        "sum_data(data)",
        globals=dict(data=data, sum_data=sum_data),
        number=1000000,
    ),
    "s/1000000 call",
)
