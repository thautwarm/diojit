import ctypes
import jit.ll.install_cython
from types import MemberDescriptorType


class PyMemberDef(ctypes.Structure):
    _fields_ = [
        ("name", ctypes.c_char_p),
        ("type", ctypes.c_int),
        ("offset", ctypes.c_ssize_t),
        ("flag", ctypes.c_int),
        ("doc", ctypes.c_char_p),
    ]


class PyMemberDescrObject(ctypes.Structure):
    _fields_ = [
        ("base1", ctypes.c_void_p),
        ("base2", ctypes.c_void_p),
        ("d_type", ctypes.c_void_p),
        ("d_name", ctypes.py_object),
        ("d_qualname", ctypes.py_object),
        ("d_member", ctypes.POINTER(PyMemberDef)),
    ]


class PyO(ctypes.Structure):
    _fields_ = [
        ("refcnt", ctypes.c_ssize_t),
        ("ob_type", ctypes.py_object),
        ("_n", ctypes.py_object),
    ]


def get_slot_member_offset(x: MemberDescriptorType):
    a = PyMemberDescrObject.from_address(id(x))
    return a.d_member.contents.offset


if __name__ == "__main__":
    from jit.ll.infr import Closure, get_member_by_offset, set_member_by_offset


    class S:
        __slots__ = ["a", "b", "c"]

        def __init__(self, a):
            self.a = a

    import sys

    v = S(2)
    print(sys.getsizeof(v))
    print(get_slot_member_offset(S.a))
    a = ctypes.cast(
        ctypes.byref(ctypes.py_object.from_address(id(v)), 16),
        ctypes.POINTER(ctypes.py_object),
    ).contents
    print(a.value)

    v = Closure(1, lambda c, x: x + c)
    print(v(2))
    print(v.__func__)
    print(v.__closure__)

    k = 114514
    d = 'asda'
    v = S(k)
    import sys
    print('ref v', sys.getrefcount(v))
    print('ref k', sys.getrefcount(k))
    print('ref d', sys.getrefcount(d))

    off = get_slot_member_offset(S.a)
    print(get_member_by_offset(v, off))
    set_member_by_offset(v, off, d)
    print(v.a)
    print('ref v', sys.getrefcount(v))
    print('ref k', sys.getrefcount(k))
    print('ref d', sys.getrefcount(d))


