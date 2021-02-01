# cython: infer_types=True
# cython: language_level=3str
from libc.stdint cimport int32_t
from cpython cimport PyObject

cdef extern from "Python.h":
    object PyDict_GetItemWithError(object self, object key)
    void Py_INCREF(PyObject*)

def test(d_0_top, d_1_top):
    d_2_top = dict__getitem_1(d_0_top, d_1_top)
    return d_2_top

cdef inline dict__getitem_1(d_0_top, d_1_top):
    cdef int32_t label = 1
    while True:
        if label == 1:
            label = 2
            continue
        elif label == 2:
            d_2_top = PyDict_GetItemWithError(d_0_top, d_1_top)
            Py_INCREF(<PyObject*>d_2_top)
            return d_2_top
