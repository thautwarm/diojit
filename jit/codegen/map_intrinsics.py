from typing import TYPE_CHECKING, Sequence
from jit import dynjit
from jit.prims import *
from _json import encode_basestring

if TYPE_CHECKING:
    from jit.codegen import Emit


def emit_expr(self: Emit, arg: dynjit.Expr):
    if isinstance(arg, dynjit.Call):
        if isinstance(arg.f, dynjit.AbstractValue):
            return map_intrinsic_call(self, arg.f, arg.args)
        no_special_call(self, arg.f, arg.args)
    else:
        self.get_reg_name(arg)


def no_special_call(
    self: Emit, f: dynjit.Expr, args: Sequence[dynjit.Expr]
):
    emit_expr(self, f)
    self.write("(")
    for each in args:
        emit_expr(self, each)
        self.write(",")
    self.write(")")


def map_intrinsic_call(
    self: Emit, f: dynjit.AbstractValue, args: Sequence[dynjit.Expr]
):
    if f is v_isinstance:
        # TODO
        pass
    elif f is v_buildlist:
        self.write("[")
        for each in args:
            emit_expr(self, each)
            self.write(", ")
        self.write("]")
        return
    elif f is v_py_call:
        assert len(args) >= 1
        hd, *tl = args
        return no_special_call(self, hd, tl)
    elif f is v_getattr and len(args) == 2:
        if (
            isinstance(args[1], dynjit.AbstractValue)
            and args[1].type is types.str_t
            and isinstance(args[1].repr, dynjit.S)
        ):
            self.write("PyObject_GetAttrString")
            self.write("(")
            emit_expr(self, args[0])
            self.write(", ")
            self.write(encode_basestring(args[1].repr.c))
            self.write(")")
        else:
            self.write("PyObject_GetAttr")
            self.write("(")
            emit_expr(self, args[0])
            self.write(", ")
            emit_expr(self, args[1])
            self.write(")")
        return
    elif (f is v_add or f is v_iadd or f is v_fadd) and len(args) is 2:
        self.write("(")
        emit_expr(self, args[0])
        self.write(" + ")
        emit_expr(self, args[1])
        self.write(")")
        return

    elif f is v_iadd and len(args) is 2:
        self.write("dynjit_cpy_long_add")
        self.write("(")
        emit_expr(self, args[0])
        self.write(", ")
        emit_expr(self, args[1])
        self.write(")")
        return

    elif f is v_fadd and len(args) is 2:
        self.write("dynjit_cpy_float_add")
        self.write("(")
        emit_expr(self, args[0])
        self.write(", ")
        emit_expr(self, args[1])
        self.write(")")
        return
    elif f is v_sconcat:
        self.write("PyUnicode_Concat")
        self.write("(")
        emit_expr(self, args[0])
        self.write(", ")
        emit_expr(self, args[1])
        self.write(")")
        return
    elif f is v_asbool and len(args) == 1:
        self.write("(")
        self.write('True if ')
        emit_expr(self, args[0])
        self.write(' else False')
        self.write(')')
        return
    elif f is v_beq and len(args) == 2:
        self.write("(")
        emit_expr(self, args[0])
        self.write(' is ')
        emit_expr(self, args[1])
        self.write(')')
        return
    elif f is v_tupleget and len(args) == 2:
        raise NotImplemented
    return no_special_call(self, f, args)
