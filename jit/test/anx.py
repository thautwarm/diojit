from jit import stack, types
from jit.prims import ct
import unittest


def f(x):
    pass


def clo_f(x):
    return lambda: x


clo_f = clo_f(1)


class TestAnx(unittest.TestCase):

    def test_anx(self):
        self.assertEquals(stack.rotate_stack(stack.construct([1, 2, 3]), 3), stack.construct([2, 3, 1]))
        self.assertEquals(stack.rotate_stack(stack.construct([1, 2]), 2), stack.construct([2, 1]))
        t = ct(f)
        self.assertTrue(isinstance(t, types.ClosureT))
        self.assertTrue(t.celltype, types.none_t)

        print(ct(clo_f))


if __name__ == '__main__':
    unittest.main()
