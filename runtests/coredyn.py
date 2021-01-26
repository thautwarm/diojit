from jit import translate
from jit import core


def f(x):
    a = x + 1
    if a < 2:
        return 3
    return a


pyc = translate.PyC(f)
core.print_in_blocks(pyc.make())
