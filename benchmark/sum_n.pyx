# cython: infer_types=True
# cython: language_level=3str

from libc.stdint cimport int32_t

def test(n):
    return sum__n_1(n)

# return-type: int
cdef sum__n_1(d_0_int):
    cdef int32_t label = 1
    while True:
        if label == 1:
            label = 2
            continue
        elif label == 11:
            return d_1_int
        elif label == 10 or label == 4:
            d_3_bool = int__lt_7(d_2_int, d_0_int)
            if d_3_bool:
                label = 5
                continue
            else:
                label = 11
                continue
        elif label == 9:
            d_1_int = add_8(d_2_int, d_3_int)
            d_2_int = add_10(d_3_int, 1)
            label = 10
            continue
        elif label == 12:
            return d_2_int
        elif label == 8:
            d_1_bool = int__lt_7(d_3_int, d_0_int)
            if d_1_bool:
                label = 9
                continue
            else:
                label = 12
                continue
        elif label == 7:
            d_2_int = add_8(d_3_int, d_1_int)
            d_3_int = add_10(d_1_int, 1)
            label = 8
            continue
        elif label == 13:
            return d_3_int
        elif label == 6:
            d_2_bool = int__lt_7(d_1_int, d_0_int)
            if d_2_bool:
                label = 7
                continue
            else:
                label = 13
                continue
        elif label == 5:
            d_3_int = add_8(d_1_int, d_2_int)
            d_1_int = add_10(d_2_int, 1)
            label = 6
            continue
        elif label == 3:
            d_1_int = add_3(0, 0)
            d_2_int = add_5(0, 1)
            label = 4
            continue
        elif label == 14:
            return 0
        elif label == 2:
            d_1_bool = int__lt_2(0, d_0_int)
            if d_1_bool:
                label = 3
                continue
            else:
                label = 14
                continue

cdef inline add_8(a, b):
    return long_add(a, b)


cdef inline add_10(a, _):
    return long_add(a, 1)

cdef inline int__lt_7(a, b):
    return long_richcmp(a, b, Py_LT)

cdef inline add_5(_, __):
    return 0 + 1

cdef inline add_3(_, __):
    return 0 + 0

cdef int__lt_2(_, b):
    return long_richcmp(0, b, Py_LT)


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
    int Py_LT
    int Py_LE
    int Py_EQ
    int Py_NE
    int Py_GE
    int Py_GT
    void* c_tp_as_number(object o)
    binaryfunc c_nb_add(void* o)
    richcmpfunc c_tp_richcompare(object o)

cdef binaryfunc long_add = c_nb_add(c_tp_as_number(int))
cdef richcmpfunc long_richcmp = c_tp_richcompare(int)