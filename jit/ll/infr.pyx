from cpython cimport PyObject


cpdef object get_member_by_offset(object x, int offset):
    return <object>(c_get_member_by_offset(<PyObject*> x, offset))


cpdef void set_member_by_offset(object x, int offset, object v):
    c_set_member_by_offset(<PyObject*> x, offset, <PyObject*> v)

cdef binaryfunc dynjit_cpy_long_add = dynjit_helper_nb_add(dynjit_helper_tp_as_number(<PyObject*> int))
cdef binaryfunc dynjit_cpy_float_add = dynjit_helper_nb_add(dynjit_helper_tp_as_number(<PyObject*> float))

def _long_add(a, b):
    return dynjit_cpy_long_add(a, b)

def _float_add(a, b):
    return dynjit_cpy_float_add(a, b)