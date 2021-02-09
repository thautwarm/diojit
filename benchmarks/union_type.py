from __future__ import annotations
import diojit as jit
import typing
import timeit


@jit.eagerjit
class Node:
    next: typing.Union[type(None), Node]
    val: int

    def __init__(self, n, val):
        self.next = n
        self.val = val


@jit.eagerjit
def sum_chain(n: Node):
    a = 0
    while n is not None:
        a += n.val
        n = n.next

    return a


n = Node(None, 0)
for i in range(100):
    n = Node(n, (i + 2) * 5)

jit_sum_chain = jit.spec_call(
    sum_chain, jit.oftype(Node), print_dio_ir=print
)
print(jit_sum_chain(n), sum_chain(n))


def bench(kind, f, number=1000000):
    print(
        kind,
        timeit.timeit(
            "f(x)",
            globals=dict(f=f, x=n),
            number=number,
        ),
    )


bench("jit", jit_sum_chain)
bench("pure py", sum_chain)
