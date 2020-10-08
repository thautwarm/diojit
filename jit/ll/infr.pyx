from cpython cimport PyObject
from libc cimport stdint
cdef binaryfunc dynjit_long_add = dynjit_helper_nb_add(dynjit_helper_tp_as_number(int))

# slow:
# cdef binaryfunc dynjit_float_add = dynjit_helper_nb_add(dynjit_helper_tp_as_number(float))
cdef object _dynjit_float_add(object f1, object f2):
     return PyFloat_FromDouble(PyFloat_AS_DOUBLE(f1) + PyFloat_AS_DOUBLE(f2))
cdef binaryfunc dynjit_float_add = _dynjit_float_add

cdef richcmpfunc dynjit_long_richcmp = dynjit_helper_tp_richcompare(int)

cdef object _dynjit_float_richcmp(object f1, object f2, int op):
    cdef:
        double l = PyFloat_AS_DOUBLE(f1)
        double r = PyFloat_AS_DOUBLE(f2)
    if op == Py_EQ:
        return True if l == r else False
    elif op == Py_NE:
        return True if l != r else False
    elif op == Py_LT:
        return True if l < r else False
    elif op == Py_GT:
        return True if l > r else False
    elif op == Py_LE:
        return True if l <= r else False
    elif op == Py_GE:
        return True if l >= r else False
    else:
        PyErr_SetObject(ValueError, "unknown rich compare operator")
        return dynjit_py_err()

cdef richcmpfunc dynjit_float_richcmp = _dynjit_float_richcmp # dynjit_helper_tp_richcompare(float)
cdef richcmpfunc dynjit_str_richcmp = dynjit_helper_tp_richcompare(str)

def _long_add(a, b):
    return dynjit_long_add(a, b)

def _float_add(a, b):
    return dynjit_float_add(a, b)

def test():

    dynjit_tuple_getitem_int_inbounds((1, 2), 0)
    dynjit_tuple_getitem_int((1, 2), 0)

    dynjit_object_getattr([], 'count')
    dynjit_object_setattr(lambda x: x, 'attr', 0)

    dynjit_list_getitem_int([1], 0)
    dynjit_list_getitem_int_inbounds([1], 0)

    dynjit_list_setitem_int([1], 0, 1)
    dynjit_list_setitem_int_inbounds([1], 0, 1)

    dynjit_list_append([], 1)
    dynjit_list_extend([], [1, 2])

    print(dynjit_str_concat("123", "23"))
    dynjit_method_new(lambda self: 1, object())

    print(dynjit_float_richcmp(1.0, 2.0, Py_LE))
    print(dynjit_float_richcmp(2.0, 1.0, Py_LE))
    print(dynjit_int_to_float(-1))
    print(dynjit_long_richcmp(0, 20, Py_LT))


cdef class JitFunction0:
    def __cinit__(self, stdint.uint64_t fptr):
        self.fptr = <cfunc0>fptr
    def __call__(self):
        return self.fptr()
    @property
    def addr(self):
        return <stdint.uint64_t> self.fptr

cdef class JitFunction1:
    def __cinit__(self, stdint.uint64_t fptr):
        self.fptr = <cfunc1>fptr
    def __call__(self, a):
        return self.fptr(a)
    @property
    def addr(self):
        return <stdint.uint64_t> self.fptr

cdef class JitFunction2:
    def __cinit__(self, stdint.uint64_t fptr):
        self.fptr = <cfunc2>fptr
    def __call__(self, a1, a2):
        return self.fptr(a1, a2)
    @property
    def addr(self):
        return <stdint.uint64_t> self.fptr

cdef class JitFunction3:
    def __cinit__(self, stdint.uint64_t fptr):
        self.fptr = <cfunc3>fptr
    def __call__(self, a1, a2, a3):
        return self.fptr(a1, a2, a3)
    @property
    def addr(self):
        return <stdint.uint64_t> self.fptr


cdef class JitFunction4:
    def __cinit__(self, stdint.uint64_t fptr):
        self.fptr = <cfunc4>fptr
    def __call__(self, a1, a2, a3, a4):
        return self.fptr(a1, a2, a3, a4)
    @property
    def addr(self):
        return <stdint.uint64_t> self.fptr

cdef class JitFunction5:
    def __cinit__(self, stdint.uint64_t fptr):
        self.fptr = <cfunc5>fptr
    def __call__(self, a1, a2, a3, a4, a5):
        return self.fptr(a1, a2, a3, a4, a5)
    @property
    def addr(self):
        return <stdint.uint64_t> self.fptr


NJitFunctions = {
    0: JitFunction0,
    1: JitFunction1,
    2: JitFunction2,
    3: JitFunction3,
    4: JitFunction4,
    5: JitFunction5
}


cdef class Closure:
    def __cinit__(self, cell, fptr):
        self.cell = cell
        self.func = fptr

    def __call__(self, *args):
        return self.func(self.cell, *args)
