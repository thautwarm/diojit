from jit import stack
import unittest


class TestAnx(unittest.TestCase):

    def test_anx(self):
        self.assertEquals(stack.rotate_stack(stack.construct([1, 2, 3]), 3), stack.construct([2, 3, 1]))
        self.assertEquals(stack.rotate_stack(stack.construct([1, 2]), 2), stack.construct([2, 1]))


if __name__ == '__main__':
    unittest.main()
