"""
append3 (jit) bench time: 1.4360911
append3 (pure py) bench time: 2.9313146
"""
import diojit as jit
from inspect import getsource
import timeit


@jit.jit
def append3(xs, x):
    xs.append(x)
    xs.append(x)
    xs.append(x)


print("append3".center(70, "="))
print(getsource(append3))

# jit.In_Def.UserCodeDyn[append3].show()
jit_append3 = jit.jit_spec_call(append3, jit.oftype(list), jit.Top)
xs = [1]
jit_append3(xs, 3)
print("test jit func: [1] append 3 for 3 times =", xs)


xs = []
print(
    "append3 (jit) bench time:",
    timeit.timeit(
        "f(xs, 1)", globals=dict(f=jit_append3, xs=xs), number=10000000
    ),
)
xs = []
print(
    "append3 (pure py) bench time:",
    timeit.timeit(
        "f(xs, 1)", globals=dict(f=append3, xs=xs), number=10000000
    ),
)
