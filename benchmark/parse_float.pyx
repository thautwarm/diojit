# cython: infer_types=True
# cython: language_level=3str
from libc.stdint cimport int32_t
cdef extern from "Python.h":
    object PyFloat_FromString(object string)

cdef inline c_parse_float(string):
    return PyFloat_FromString(string)

def test_str(x: str):
    return type__new__1(float, x)

# return-type: float
cdef type__new__1(x1, x2):
    # x1 = float = S_{"float"}
    # x2 = D_0^{str}
    cdef int32_t label = 1
    while True:
        if label == 1:
            # x3 = D_1^{float}
            x3 = float__type__new_2(float, x2)
            label = 2
            continue
        elif label == 2:
            # x4 = D_1^{unit}
            x4 = init__do__nothing_3(float, x2)
            return x2
# return-type: NoneType
# must return instance: None
cdef init__do__nothing_3(x1, x2):
    # x1 = float
    # x2 = D_0^{str}
    cdef int32_t label = 1
    while True:
        if label == 1:
            return None

# return-type: float
cdef float__type__new_2(x1, x2):
    # x1 = float
    # x2 = D_0^{str}
    cdef int32_t label = 1
    while True:
        if label == 1:
            label = 2
            continue
        elif label == 4:
            # x3 = D_1^{float}
            x3 = c_parse_float(x2)
            return x3
        elif label == 3:
            label = 4
            continue
        elif label == 2:
            label = 3
            continue
