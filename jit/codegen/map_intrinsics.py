from __future__ import annotations
from typing import TYPE_CHECKING, Sequence
from jit.prims import *

if TYPE_CHECKING:
    from jit.codegen import Emit


def emit_expr(self: Emit, arg: dynjit.Expr):
    if isinstance(arg, dynjit.Call):
        if isinstance(arg.f, dynjit.AbstractValue):
            return map_intrinsic_call(self, arg.f, arg.args)
        no_special_call(self, arg.f, arg.args)
    else:
        self.write(self.get_reg_name(arg))


def no_special_call(
    self: Emit, f: dynjit.Expr, args: Sequence[dynjit.Expr]
):
    emit_expr(self, f)
    self.write("(")
    for each in args:
        emit_expr(self, each)
        self.write(",")
    self.write(")")


def call_args_with_cython_func(self: Emit, func: str, args):
    self.write(func)
    self.write("(")
    if not args:
        self.write(")")
    args = iter(args)
    emit_expr(self, next(args))
    for each in args:
        self.write(",")
        emit_expr(self, each)
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
    elif f is v_getoffset:
        return call_args_with_cython_func(
            self, "dynjit_getoffset", args
        )

    elif f is v_setoffset:
        return call_args_with_cython_func(
            self, "dynjit_setoffset", args
        )

    elif f is v_listappend:
        return call_args_with_cython_func(
            self, "dynjit_list_append", args
        )

    elif f is v_listextend:
        return call_args_with_cython_func(
            self, "dynjit_list_extend", args
        )
    elif f is v_irichcmp:
        return call_args_with_cython_func(
            self, "dynjit_long_richcmp", args
        )
    elif f is v_frichcmp:
        return call_args_with_cython_func(
            self, "dynjit_float_richcmp", args
        )
    elif f is v_srichcmp:
        return call_args_with_cython_func(
            self, "dynjit_str_richcmp", args
        )

    elif len(args) == 1:
        if f is v_asbool:
            self.write("(")
            self.write("True if ")
            emit_expr(self, args[0])
            self.write(" else False")
            self.write(")")
            return
    elif len(args) == 2:
        if f is v_getattr:
            return call_args_with_cython_func(
                self, "dynjit_object_getattr", args
            )

        elif f is v_add:
            self.write("(")
            emit_expr(self, args[0])
            self.write(" + ")
            emit_expr(self, args[1])
            self.write(")")
            return

        elif f is v_iadd:
            return call_args_with_cython_func(
                self, "dynjit_long_add", args
            )

        elif f is v_fadd:
            return call_args_with_cython_func(
                self, "dynjit_float_add", args
            )
        elif f is v_sconcat:
            return call_args_with_cython_func(
                self, "dynjit_str_concat", args
            )

        elif f is v_beq:
            self.write("(")
            emit_expr(self, args[0])
            self.write(" is ")
            emit_expr(self, args[1])
            self.write(")")
            return
        elif f is v_tuple_getitem_int_inbounds:
            return call_args_with_cython_func(
                self, "dynjit_tuple_getitem_int_inbounds", args
            )

        elif f is v_tuple_getitem_int:
            return call_args_with_cython_func(
                self, "dynjit_tuple_getitem_int", args
            )

        elif f is v_getitem:
            emit_expr(self, args[0])
            self.write("[")
            emit_expr(self, args[1])
            self.write("]")
            return
        elif f is v_mkfunc:
            # TODO
            raise NotImplementedError
        elif f is v_mkmethod:
            return call_args_with_cython_func(
                self, "dynjit_method_new", args
            )
        elif f is v_closure:
            return no_special_call(self, f, args)

    return no_special_call(self, f, args)
