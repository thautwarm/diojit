from typing import Sequence
from collections import deque


def rotate_stack(S, n: int):
    assert n > 0
    (h, S) = S
    xs = []
    for i in range(n - 1):
        (t, S) = S
        xs.append(t)
    xs.append(h)
    while xs:
        (S) = (xs.pop(), S)
    return S


def cons(hd, tl):
    return hd, tl


def single(e):
    return e, ()


def first_opt(S):
    if len(S) is 2:
        return S[0]

    return None


def decons_opt(S):
    if len(S) is 2:
        return S


def construct(args: Sequence):
    s = ()
    for i in reversed(args):
        s = (i, s)
    return s


def to_list(S):
    xs = []
    while S:
        (h, S) = S
        xs.append(h)
    return xs


def peek(S, n):
    while n:
        (_, S) = S
        n -= 1

    return S[0]


def pop(S):
    return S


def index_rev(S, n: int):
    n = n + 1
    xs = deque(maxlen=n)
    while S:
        (a, S) = S
        xs.append(a)
    assert len(xs) == n
    return xs[0]


def store_rev(S, n: int, v):
    xs = deque()
    while S:
        (a, S) = S
        xs.append(a)
    xs[-n - 1] = v
    return construct(xs)


def size(S):
    n = 0
    while S:
        n += 1
        (_, S) = S

    return n
