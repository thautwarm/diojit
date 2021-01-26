# cython: infer_types=True
# cython: language_level=3str

from libc.stdint cimport int32_t
from cpython cimport PyObject
ctypedef object (*binaryfunc)(object, object)
ctypedef object (*richcmpfunc)(object, object, int op)

cdef extern from "Python.h":
    """
    static PyNumberMethods* c_tp_as_number(PyTypeObject* o){
        return o->tp_as_number;
    }
    static binaryfunc c_nb_add(PyNumberMethods* o){
        return o->nb_add;
    }
    static richcmpfunc c_tp_richcompare(PyTypeObject* o){
        return o->tp_richcompare;
    }
    """
    object PyLong_FromDouble(double f)
    double PyFloat_AS_DOUBLE(object o)
    object PyLong_FromUnicodeObject(object string, int base)
    void* c_tp_as_number(object o)
    binaryfunc c_nb_add(void* o)
    richcmpfunc c_tp_richcompare(object o)
    int Py_LT
    object _PyTuple_GET_ITEM "PyTuple_GET_ITEM"(object o, int i)
    void Py_INCREF(PyObject*)

cdef binaryfunc long_add = c_nb_add(c_tp_as_number(int))
cdef richcmpfunc long_richcmp = c_tp_richcompare(int)

cdef inline PyTuple_GET_ITEM(o, int i):
    a = _PyTuple_GET_ITEM(o, i)
    Py_INCREF(<PyObject*>a)
    return a

def test(n, i, s, fl):
    cdef int32_t label = 1
    while True:
        if label == 1:
            S = 0
            t = (i, s, fl)
            if long_richcmp(0, n, Py_LT):
                label = 3
                continue
            else:
                label = 2
                continue
        elif label == 2:
            return 0
        elif label == 3:
            t = (PyTuple_GET_ITEM(t, 2), PyTuple_GET_ITEM(t, 0), PyTuple_GET_ITEM(t, 1))
            S = long_add(S, PyLong_FromDouble(PyFloat_AS_DOUBLE(PyTuple_GET_ITEM(t, 0))))
            if long_richcmp(S, n, Py_LT):
                label = 5
                continue
            else:
                label = 4
                continue
        elif label == 4:
            return S
        elif label == 5:
            t = (PyTuple_GET_ITEM(t, 2), PyTuple_GET_ITEM(t, 0), PyTuple_GET_ITEM(t, 1))
            S = long_add(S, PyLong_FromUnicodeObject(PyTuple_GET_ITEM(t, 0), 10))
            if long_richcmp(S, n, Py_LT):
                label = 6
                continue
            else:
                label = 4
                continue
        elif label == 6:
            t = (PyTuple_GET_ITEM(t, 2), PyTuple_GET_ITEM(t, 0), PyTuple_GET_ITEM(t, 1))
            S = long_add(S, PyTuple_GET_ITEM(t, 0))
            if long_richcmp(S, n, Py_LT):
                label = 3
                continue
            else:
                label = 4
                continue

# def test(n, i, s, fl):
#     cdef int32_t label = 1
#     while True:
#         if label == 1:
#             S = 0
#             t = (i, s, fl)
#             if 0 < n:
#                 label = 3
#                 continue
#             else:
#                 label = 2
#                 continue
#         elif label == 2:
#             return 0
#         elif label == 3:
#             t = (t[2], t[0], t[1])
#             S = S + PyLong_FromDouble(PyFloat_AS_DOUBLE(t[0]))
#             if S < n:
#                 label = 5
#                 continue
#             else:
#                 label = 4
#                 continue
#         elif label == 4:
#             return S
#         elif label == 5:
#             t = (t[2], t[0], t[1])
#             S = S + PyLong_FromUnicodeObject(t[0], 10)
#             if S < n:
#                 label = 6
#                 continue
#             else:
#                 label = 4
#                 continue
#         elif label == 6:
#             t = (t[2], t[0], t[1])
#             S = S + t[0]
#             if S < n:
#                 label = 3
#                 continue
#             else:
#                 label = 4
#                 continue
