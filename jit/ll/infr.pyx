from cpython cimport PyObject


cpdef object get_member_by_offset(object x, int offset):
    return <object>(c_get_member_by_offset(<PyObject*> x, offset))


cpdef void set_member_by_offset(object x, int offset, object v):
    c_set_member_by_offset(<PyObject*> x, offset, <PyObject*> v)
