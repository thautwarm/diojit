from cpython cimport PyObject

cdef extern from "Python.h":
    void Py_XINCREF(PyObject* o)
    void Py_XDECREF(PyObject* o)

cdef inline PyObject* c_get_member_by_offset(PyObject* x, int offset):
    ptr = <char*>x
    return (<PyObject**> (ptr + offset))[0]

cdef inline void c_set_member_by_offset(PyObject* x, int offset, PyObject* v):
    cdef PyObject** attr_ref
    ptr = <char*>x
    attr_ref = <PyObject**> (ptr + offset)
    if attr_ref[0] != NULL:
        Py_XDECREF(attr_ref[0])
    Py_XINCREF(v)
    attr_ref[0] = v

cpdef object get_member_by_offset(object x, int offset)
cpdef void set_member_by_offset(object x, int offset, object v)