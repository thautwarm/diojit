from cpython cimport PyObject

ctypedef object (*binaryfunc)(object, object)

cdef extern from "object.h":
    """
    static PyNumberMethods* dynjit_helper_tp_as_number(PyTypeObject* o){
        return o->tp_as_number;
    }

    static binaryfunc dynjit_helper_nb_add(PyNumberMethods* o){
        return o->nb_add;
    }
    """
    void* dynjit_helper_tp_as_number(PyObject* o)
    binaryfunc dynjit_helper_nb_add(void* o)


cdef extern from "Python.h":
    void Py_XINCREF(PyObject* o)
    void Py_XDECREF(PyObject* o)
    void Py_DECREF(PyObject* o)
    PyObject* PyList_New(Py_ssize_t i)
    void PyList_SET_ITEM(PyObject* list, Py_ssize_t index, PyObject* o)
    PyObject* PyList_GetItem(PyObject *list, Py_ssize_t index)
    int PyList_SetItem(PyObject *list, Py_ssize_t index, PyObject *item)
    PyObject* PyObject_GetAttrString(PyObject* o, const char *attr_name)
    object PyObject_GetAttr(object o, object attr_name)
    object PyUnicode_Concat(object left, object right)
    PyObject* PyTuple_GetItem(PyObject *p, Py_ssize_t pos)

cdef inline object c_get_attr_by_string(
        object subject,
        const char* attr_name):
        cdef PyObject* attr
        attr = PyObject_GetAttrString(subject, attr_name)

cdef inline PyObject* c_get_member_by_offset(PyObject* x, int offset):
    ptr = <char*>x
    return (<PyObject**> (ptr + offset))[0]



cdef inline void c_set_member_by_offset(PyObject* x, int offset, PyObject* v):
    cdef PyObject** attr_ref
    ptr = <char*>x
    attr_ref = <PyObject**> (ptr + offset)
    if attr_ref[0] != NULL:
        Py_DECREF(attr_ref[0])
    Py_XINCREF(v)
    attr_ref[0] = v

cpdef object get_member_by_offset(object x, int offset)
cpdef void set_member_by_offset(object x, int offset, object v)
cdef binaryfunc dynjit_cpy_long_add
cdef binaryfunc dynjit_cpy_float_add