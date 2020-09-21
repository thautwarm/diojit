from jit.CoreCPY import *

def f(x):
    y = 1
    if y:
        return 1 + y
    return [(y, [y])]

import dis

for e in from_pyc(dis.Bytecode(f)):
    print(e)



def f():
    # x : 0
    x = 1



