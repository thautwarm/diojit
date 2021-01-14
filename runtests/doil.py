from jit import translate
from jit import core
import operator
import jit.python as jit
import sys

sys.setrecursionlimit(2000)


@jit.eager_jit
def test(a):
    t = (1, 2, 3)
    i = 0
    while i < a:
        t = (t[1], t[2], t[0])
        i = i + t[0]
    return i


in_def = jit.In_Def.UserCodeDyn[jit.from_runtime(test).ts[0]]
in_def.show()


print(jit.jit_spec_call(test, 50000))
print()
for each in reversed(jit.Out_Def.GenerateCache):
    each.show()
