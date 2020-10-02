import ctypes
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
        ctypes.POINTER(ctypes.py_object)
    ).contents
    print(a.value)
