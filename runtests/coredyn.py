from jit.stack2reg import translate
from jit import absint


def f(x):
    a = x + 1
    if a < 2:
        return 3
    return a


pyc = translate.PyC(f)
absint.print_in_blocks(pyc.make())
