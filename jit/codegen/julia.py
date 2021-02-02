"""
why julia?
1. low latency incremental compilation(LLVM)
2. easier interface and ABI treatment(LLVM C API is hardo)
3. can do some zero-specialisation in julia side.
   For instance, manual analysis for Python RC's ownership transfer
   is verbose, but with Julia specialisation it is easily
   made automatic.

3. I love Julia
"""
from ..absint import *
from io import StringIO
from typing import Union
from contextlib import contextmanager

import json


class Codegen:
    def __init__(self, out_def: Out_Def):
        self.out_def = out_def
        self.io = StringIO()
        self.indent = ""
        self.vars = set()
        self.params = set(map(self.param, self.out_def.params))

    def __lshift__(self, other: str):
        self.io.write(self.indent)
        self.io.write(other)
        self.io.write("\n")

    def __matmul__(self, other):
        self.io.write('\n')
        self.io.write(other)
        self.io.write("\n")

    def var(self, target: D):
        a = f"x{target.i}"
        if a not in self.params:
            # which will be decref-ed when leaving the function
            self.vars.add(a)
        return a

    def param(self, p: Union[S, D]):
        if isinstance(p, D):
            return f"x{p.i}"
        return "_"

    @staticmethod
    def uint64(i):
        return f"{i:#0{18}x}"

    def val(self, v: Union[S, D]):
        if isinstance(v, S):
            base = v.base
            if isinstance(base, Intrinsic):
                return repr(base)
            # get object from address
            return f"@DIO_Obj({self.uint64(id(v.base))})"

        return self.var(v)

    def call(self, x: Out_Expr, dealloc_args: bool = False):
        if isinstance(x, AbsVal):
            return self.val(x)
        f = self.call(x.func)

        args = ", ".join(self.call(arg, True) for arg in x.args)
        if dealloc_args:
            return f"@DIO_ChkExc({f}({args}))"
        else:
            return f"@DIO_ChkExcAndDecRefSubCall({f}({args}))"

    def get(self):
        spec_info = self.out_def.spec
        with self.indent_inc():
            self.visit_many(self.out_def.instrs)
            func_body = self.io.getvalue()
        self.io = StringIO()
        params = ", ".join(map(self.param, self.out_def.params))
        self << f"function {spec_info.abs_jit_func}({params})"
        sorted_vars = sorted(self.vars)
        for var in sorted_vars:
            self << f"    {var} = DIO_Undef"
        self << func_body
        self @ "@label except"
        # TODO: add traceback
        self << "    DIO_Return = Py_NULL"
        self @ "@label return"
        for var in sorted_vars:
            self << f"    DIO_DecRef({var})"
        self << "    return DIO_Return"
        self << "end"
        self << f"DIO.DIO_ExceptCode(::typeof({spec_info.abs_jit_func})) = Py_NULL"
        narg = len(self.out_def.params)

        doc_io = StringIO()
        self.out_def.show(lambda *args: print(*args, file=doc_io))
        # function documentation
        doc = doc_io.getvalue().replace("$", "\\$")
        self << (
            f"const DOC_{spec_info.abs_jit_func} = "
            f"Base.unsafe_convert(Cstring, {json.dumps(doc)})"
        )
        if narg == 0:
            self << (
                f"CFunc_{spec_info.abs_jit_func}(_ :: PyPtr, ::PyPtr) = "
                f"{spec_info.abs_jit_func}()"
            )
            self << (
                f"const CFuncPtr_{spec_info.abs_jit_func} = "
                f"@cfunction(CFunc_{spec_info.abs_jit_func}, PyPtr, (PyPtr, PyPtr)) "
            )
            self << (
                f"const PyMeth_{spec_info.abs_jit_func} = PyMethodDef(\n"
                f"    Base.unsafe_convert(Cstring, :{self.out_def.name}),\n"
                f"    CFuncPtr_{spec_info.abs_jit_func},\n"
                f"    METH_NOARGS,\n"
                f"    DOC_{spec_info.abs_jit_func}\n"
                ")"
            )

        elif narg == 1:
            self << (
                f"CFunc_{spec_info.abs_jit_func}(_ :: PyPtr, o::PyPtr) = "
                f"{spec_info.abs_jit_func}(o)"
            )
            self << (
                f"const CFuncPtr_{spec_info.abs_jit_func} = "
                f"@cfunction(CFunc_{spec_info.abs_jit_func}, PyPtr, (PyPtr, PyPtr)) "
            )

            self << (
                f"const PyMeth_{spec_info.abs_jit_func} = PyMethodDef(\n"
                f"    Base.unsafe_convert(Cstring, :{self.out_def.name}),\n"
                f"    CFuncPtr_{spec_info.abs_jit_func},\n"
                f"    METH_O,\n"
                f"    DOC_{spec_info.abs_jit_func}\n"
                ")"
            )

        else:
            self << (
                f"CFunc_{spec_info.abs_jit_func}(self :: PyPtr, args::Ptr{{PyPtr}}, n::Py_ssize_t) = "
                f"@DIO_MakePyFastCFunc({spec_info.abs_jit_func}, args, n, {narg})"
            )
            self << (
                f"const CFuncPtr_{spec_info.abs_jit_func} = "
                f"@cfunction(CFunc_{spec_info.abs_jit_func}, PyPtr, (PyPtr, Ptr{{PyPtr}}, Py_ssize_t))"
            )

            self << (
                f"const PyMeth_{spec_info.abs_jit_func} = PyMethodDef(\n"
                f"    Base.unsafe_convert(Cstring, :{self.out_def.name}),\n"
                f"    CFuncPtr_{spec_info.abs_jit_func},\n"
                f"    METH_FASTCALL,\n"
                f"    DOC_{spec_info.abs_jit_func}\n"
                ")"
            )
        self << (
            f"const PyFunc_{spec_info.abs_jit_func} = PyCFunction_New(PyMeth_{spec_info.abs_jit_func}, Py_NULL)"
        )
        return self.io.getvalue()

    @contextmanager
    def indent_inc(self):
        old = self.indent
        try:
            self.indent = old + "    "
            yield
        finally:
            self.indent = old

    def visit_many(self, instrs: tuple[Out_Instr, ...]):
        for each in instrs:
            self.visit(each)

    def visit(self, instr: Out_Instr):
        if isinstance(instr, Out_Assign):
            var = self.var(instr.target)
            self << f"DIO_DecRef({var})"
            val = self.call(instr.expr)
            self << f"{var} = {val}"
            return
        elif isinstance(instr, Out_Label):
            self @ f"@label {instr.label}"
            return
        elif isinstance(instr, Out_Goto):
            self << f"@goto {instr.label}"
            return
        elif isinstance(instr, Out_Return):
            val = self.val(instr.value)
            self << f"@DIO_Return DIO_IncRef({val})"
            return
        elif isinstance(instr, Out_If):
            val = self.val(instr.test)
            self << f"if {self.uint64(id(True))} == reinterpret(UInt64, {val})"
            self << f"    @goto {instr.t}"
            self << "else"
            self << f"    @goto {instr.f}"
            self << "end"
            return

        elif isinstance(instr, Out_TypeCase):
            val = self.val(instr.obj)
            x = "__type__"
            self << f"__type__ = reinterpret(UInt64, Py_TYPE({val}))"
            for i, (typecase, block) in enumerate(instr.cases.items()):
                head = i == 0 and "if" or "elseif"
                t = typecase.type.base
                self << f"# when type is {t}"
                self << f"{head} __type__ === {self.uint64(id(t))}"
                with self.indent_inc():
                    self.visit_many(block)
            self << "end"
            return
        elif isinstance(instr, Out_Error):
            # TODO: set debug info like: lineno, fileno...
            self << "@goto except"
            return
