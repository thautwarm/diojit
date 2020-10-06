from cpython cimport PyObject, PyErr_SetObject

ctypedef object (*binaryfunc)(object, object)
ctypedef object (*richcmpfunc)(object, object, int op)

cdef extern from "Python.h":
    """
    static inline void* dynjit_py_err(){
        return NULL;
    }

    static PyNumberMethods* dynjit_helper_tp_as_number(PyTypeObject* o){
        return o->tp_as_number;
    }

    static binaryfunc dynjit_helper_nb_add(PyNumberMethods* o){
        return o->nb_add;
    }

    static richcmpfunc dynjit_helper_tp_richcompare(PyTypeObject* o){
        return o->tp_richcompare;
    }
    """
    int Py_LT
    int Py_LE
    int Py_EQ
    int Py_NE
    int Py_GE
    int Py_GT

    void Py_XINCREF(PyObject* o)
    void Py_XDECREF(PyObject* o)
    void Py_DECREF(PyObject* o)

    object dynjit_tuple_getitem_int_inbounds "PyTuple_GET_ITEM"(object list, Py_ssize_t index)
    object dynjit_tuple_getitem_int "PyTuple_GetItem"(object p, Py_ssize_t pos)

    object dynjit_object_getattr "PyObject_GetAttr"(object o, object attr_name)
    int dynjit_object_setattr "PyObject_SetAttr"(object o, object attr_name, object v) except -1


    object dynjit_list_getitem_int "PyList_GetItem"(object list, Py_ssize_t index)
    object dynjit_list_getitem_int_inbounds "PyList_GET_ITEM"(object list, Py_ssize_t index)

    int _dynjit_list_setitem_int "PyList_SetItem"(object list, Py_ssize_t index, object item) except -1
    void dynjit_list_setitem_int_inbounds "PyList_SET_ITEM"(object list, Py_ssize_t index, object item)
    int _dynjit_list_append "PyList_Append"(object list, object item) except -1
    object dynjit_list_extend "_PyList_Extend"(object list, object iterable)


    object dynjit_str_concat "PyUnicode_Concat"(object left, object right)
    object dynjit_py_err()

    object dynjit_method_get_self "PyMethod_GET_SELF"(object meth)
    object dynjit_method_get_func "PyMethod_GET_FUNCTION"(object meth)
    object dynjit_method_new "PyMethod_New"(object func, object self)

    double PyFloat_AS_DOUBLE(object op)
    object PyFloat_FromDouble(double fval)
    double PyLong_AsDouble(object) except? -1.0
    object PyNumber_Add(object o1, object o2)

    void* dynjit_helper_tp_as_number(object o)
    binaryfunc dynjit_helper_nb_add(void* o)
    richcmpfunc dynjit_helper_tp_richcompare(object o)

cdef inline void dynjit_list_setitem_int(object list, Py_ssize_t index, object item):
    _dynjit_list_setitem_int(list, index, item)

cdef inline void dynjit_list_append(object list, object item):
    _dynjit_list_append(list, item)

cdef inline object dynjit_getoffset(object x, int offset, object attrname):
    cdef PyObject* res
    ptr = <char*>(<PyObject*>x)
    res = (<PyObject**> (ptr + offset))[0]
    if res == NULL:
        PyErr_SetObject(AttributeError, attrname)
        return dynjit_py_err()
    return <object>res


cdef inline void dynjit_setoffset(object subject, int offset, object value):
    cdef:
        PyObject** attr_ref
        char* ptr
        PyObject* v
    v = <PyObject*> value
    ptr = <char*> (<PyObject*> subject)
    attr_ref = <PyObject**> (ptr + offset)
    if attr_ref[0] != NULL:
        Py_DECREF(attr_ref[0])
    Py_XINCREF(v)
    attr_ref[0] = v

cdef binaryfunc dynjit_long_add
cdef object dynjit_float_add(object, object)
cdef richcmpfunc dynjit_long_richcmp
cdef richcmpfunc dynjit_str_richcmp
cdef richcmpfunc dynjit_float_richcmp

cdef inline object dynjit_int_to_float(object x):
    return PyLong_AsDouble(x)


ctypedef object (*cfunc0)()
cdef class JitFunction0:
    cdef cfunc0 fptr

ctypedef object (*cfunc1)(object)
cdef class JitFunction1:
    cdef cfunc1 fptr

ctypedef object (*cfunc2)(object, object)
cdef class JitFunction2:
    cdef cfunc2 fptr

ctypedef object (*cfunc3)(object, object, object)
cdef class JitFunction3:
    cdef cfunc3 fptr

ctypedef object (*cfunc4)(object, object, object, object)
cdef class JitFunction4:
    cdef cfunc4 fptr

ctypedef object (*cfunc5)(object, object, object, object, object)
cdef class JitFunction5:
    cdef cfunc5 fptr

ctypedef object (*cfunc6)(object, object, object, object, object, object)
ctypedef object (*cfunc7)(object, object, object, object, object, object, object)
ctypedef object (*cfunc8)(object, object, object, object, object, object, object, object)
ctypedef object (*cfunc9)(object, object, object, object, object, object, object, object, object)
ctypedef object (*cfunc10)(object, object, object, object, object, object, object, object, object, object)
