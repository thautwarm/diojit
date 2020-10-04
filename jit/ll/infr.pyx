from cpython cimport PyObject


class Closure:
    __slots__ = ['cell', 'fptr']
    def __init__(self, cell, fptr):
        self.cell = cell
        self.fptr = fptr

    @property
    def __closure__(self):
        return self.cell

    @property
    def __func__(self):
        return self.fptr

    def __call__(self, *args):
        return self.fptr(self.cell, *args)


cpdef object get_member_by_offset(object x, int offset):
    return <object>(c_get_member_by_offset(<PyObject*> x, offset))


cpdef void set_member_by_offset(object x, int offset, object v):
    c_set_member_by_offset(<PyObject*> x, offset, <PyObject*> v)
