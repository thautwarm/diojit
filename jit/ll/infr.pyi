from typing import Generic, TypeVar

C = TypeVar("C")
F = TypeVar("F")

class Closure(Generic[C, F]):
    def __init__(self, c: C, f: F):
        self.c = c
        self.f = f
    def __call__(self, *args):
        return self.f(self.c, *args)
    @property
    def __closure__(self) -> C:
        raise NotImplemented
    @property
    def __func__(self) -> F:
        raise NotImplemented
