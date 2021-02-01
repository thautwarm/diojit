# cython: infer_types=True
# cython: language_level=3str

from libc.stdint cimport int32_t
# return-type: int
# must return instance: 1
def test8_0():
    cdef int32_t label = 1
    while True:
        if label == 1:
            return 1

def test16_0():
    cdef int32_t label = 1
    while True:
        if label == 1:
            return 1