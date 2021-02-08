"""
why julia?
1. low latency incremental compilation(LLVM)
2. easier interface and ABI treatment(LLVM C API is hardo)
3. can do some zero-specialisation in julia side.
   For instance, manual analysis for Python RC's ownership transfer
   is verbose, but with Julia specialisation it is easily
   made automatic.
4. I love Julia
"""
from __future__ import annotations
from ..absint import *
from io import StringIO
from typing import Union
from contextlib import contextmanager
from itertools import repeat, chain

import json


def splice(o):
    return f"@DIO_Obj({u64o(o)})"


def u64o(o: object):
    """
    uint64 address from object
    """
    return u64i(id(o))


def u64i(i: int):
    """uint64 from integer"""
    return f"{i:#0{18}x}"


class Codegen:
    def __init__(self, out_def: Out_Def):
        self.out_def = out_def
        self.io = StringIO()
        self.indent = ""
        self.params = set(map(self.param, self.out_def.params))
        # self._inc = 0

    def __lshift__(self, other: str):
        # self.io.write(f'println({self._inc})\n')
        # self._inc += 1

        self.io.write(self.indent)
        self.io.write(other)
        self.io.write("\n")

    def __matmul__(self, other):
        self.io.write("\n")
        self.io.write(other)
        self.io.write("\n")

    def var_i(self, i: int):
        return f"x{i}"

    def var(self, target: D):
        return self.var_i(target.i)

    def param(self, p: Union[S, D]):
        if isinstance(p, D):
            return f"x{p.i}"
        return "_"

    @staticmethod
    def uint64(i):
        return u64i(i)

    def val(self, v: Union[str, S, D]):
        if isinstance(v, str):
            # see 'diojit.prescr.lit'
            return v

        if isinstance(v, S):
            base = v.base
            if isinstance(base, Intrinsic):
                a = repr(base)
                return a
            # get object from address
            return f"{splice(v.base)} #= {repr(v.base).replace('=#', '//=//#')} =#"

        return self.var(v)

    def call(self, x: Out_Call):
        assert isinstance(x.func, S) and isinstance(
            x.func.base, Intrinsic
        ), x
        f = self.val(x.func)
        args = ", ".join(map(self.val, x.args))
        return f, f"{f}({args})"

    def get_jl_definitions(self):
        self.io = StringIO()
        spec_info = self.out_def.spec
        with self.indent_inc():
            self.visit_many(self.out_def.instrs)
            func_body = self.io.getvalue()
        self.io = StringIO()
        params = ", ".join(map(self.param, self.out_def.params))
        self << f"DIO.@codegen DIO.@q function {spec_info.abs_jit_func}({params})"
        self << func_body
        self @ "@label except"
        # TODO: add traceback
        self << "    DIO_Return = Py_NULL"
        self @ "@label ret"
        self << "    return DIO_Return"
        self << "end"
        doc_io = StringIO()
        self.out_def.show(lambda *args: print(*args, file=doc_io))
        # function documentation
        doc = json.dumps(doc_io.getvalue()).replace("$", "\\$")
        self << f"const DOC_{spec_info.abs_jit_func} = " f"{doc}"
        return self.io.getvalue()

    def get_py_interfaces(self):
        narg = len(self.out_def.params)
        spec_info = self.out_def.spec
        return f"@DIO_MakePtrCFunc {narg} {spec_info.abs_jit_func} {self.out_def.name}\n"

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
        if isinstance(instr, Out_SetLineno):
            filename = json.dumps(instr.filename).replace("$", "\\$")
            self << f"@DIO_SetLineno {instr.line} {filename}"
            pass
        elif isinstance(instr, Out_Assign):
            var = self.var(instr.target)
            assert isinstance(instr.expr, Out_Call)
            f, val = self.call(instr.expr)
            self << f"__tmp__ = {val}"
            self << f"if __tmp__ === DIO_ExceptCode({f})"
            for i in instr.decrefs:
                self << f"    Py_DECREF({self.var_i(i)})"
            self << r"    @goto except"
            self << f"elseif DIO_HasCast({f})"
            self << f"    {var} = DIO_HasCast({f}, __tmp__)"
            self << f"    if DIO_CastExc({f})"
            self << f"       {var} === Py_NULL && return Py_NULL"
            self << r"    end"
            self << r"elseif __tmp__ isa PyPtr"
            self << f"    {var} = __tmp__"
            self << r"elseif __tmp__ isa Integer"
            self << f"    {var} = DIO_WrapIntValue(__tmp__)"
            self << f"    {var} === Py_NULL && return Py_NULL"
            self << r"else"
            self << f"    {var} = DIO_NewNone()"
            self << r"end"
            return
        elif isinstance(instr, Out_Label):
            self @ f"@label {instr.label}"
            return
        elif isinstance(instr, Out_Goto):
            self << f"@goto {instr.label}"
            return
        elif isinstance(instr, Out_Return):
            val = self.val(instr.value)
            self << f"DIO_Return = {val}"
            mini_opt = False
            if isinstance(instr.value, D):
                hold = instr.value.i
                if hold in instr.decrefs:
                    mini_opt = True
                    for i in instr.decrefs:
                        if i != hold:
                            self << f"Py_DECREF({self.var_i(i)})"
            if not mini_opt:
                self << f"Py_INCREF(DIO_Return)"
                for i in instr.decrefs:
                    self << f"Py_DECREF({self.var_i(i)})"
            self << f"@goto ret"
            return
        elif isinstance(instr, Out_If):
            val = self.val(instr.test)
            self << f"if {u64o(True)} === reinterpret(UInt64, {val})"
            self << f"    @goto {instr.t}"
            self << "else"
            self << f"    @goto {instr.f}"
            self << "end"
            return

        elif isinstance(instr, Out_TypeCase):
            val = self.val(instr.obj)
            self << f"__type__ = reinterpret(UInt64, Py_TYPE({val}))"
            cases = instr.cases
            has_any_type = Top in cases
            if has_any_type and len(cases) == 1:
                self.visit_many(cases[Top])
                return
            ts = []
            headers = chain(["if"], repeat("elseif"))
            for i, (typecase, block) in enumerate(instr.cases.items()):
                if typecase is Top:
                    continue
                head = next(headers)
                ts.append(typecase)
                t = ts[-1].base
                self << f"# when type is {t}"
                self << f"{head} __type__ === {u64o(t)}"
                with self.indent_inc():
                    self.visit_many(block)
            if not has_any_type:
                # msg = ",".join(map(repr, ts))
                self << "else"
                self << '    error("analyser produces incorrect return")'
            else:
                self << "else"
                with self.indent_inc():
                    self.visit_many(cases[Top])
            self << "end"
            return
        elif isinstance(instr, Out_DecRef):
            self << f"Py_DECREF({self.var_i(instr.i)})"
