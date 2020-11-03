from jit.flat import *
from jit.codegen.map_intrinsics import emit_expr
from io import StringIO
from itertools import chain
from typing import Tuple
from collections import deque


class MissingDict(dict):
    def __init__(self, func):
        self.func = func
        self.cnt = 0

    def __missing__(self, key):
        v = self[key] = self.func(self.cnt)
        self.cnt += 1
        return v


PIECE = "  "


class Emit:
    def __init__(self, args: Sequence[dynjit.Abs]):
        self.reg_names = MissingDict(lambda x: f"d{x}")
        self.func_defs = []
        self.func_ptrs = {}
        self.lbls = MissingDict(lambda x: x)
        self.generated_lbls = set()
        self.hashable_const_pools = {}
        self.unhashable_const_pools = []
        self.io = StringIO()
        self.indent_level = 3
        self.args = [self.get_reg_name(arg) for arg in args]

    def code_generation(self) -> Tuple[list, str]:
        io = StringIO()
        initializations = []
        io.write("# cython: infer_types=True\n")
        io.write("# cython: language_level=3str\n")
        io.write("from jit.ll.infr cimport *\n")
        io.write("from libc.stdint cimport uint64_t\n")
        io.writelines(self.func_defs)
        io.write('\n')
        for (c, n) in chain(
            self.hashable_const_pools.items(),
            self.unhashable_const_pools,
        ):
            setter = f"set_const_{n}"
            io.write(f"# {c!r}\n")
            io.write(f"cdef object {n}\n")
            io.write(f"def {setter}(object o):\n")
            io.write(f"  global {n}\n")
            io.write(f"  {n} = o\n")
            initializations.append(
                (
                    lambda c=c, setter=setter: lambda mod: getattr(
                        mod, setter
                    )(c)
                )()
            )
        reg_names = [
            reg
            for reg in self.reg_names.values()
            if reg not in self.args
        ]
        argnames = self.args
        narg = len(argnames)
        io.write(
            "cpdef object cfunc({}):\n".format(", ".join(argnames))
        )
        io.write(f"{PIECE}cdef int CONT = -1\n")
        for n in reg_names:
            io.write(f"{PIECE}cdef object {n}\n")
        io.write(f"{PIECE}while True:\n")
        io.write(f"{PIECE}{PIECE}if CONT == -1: # start block\n")
        io.write(f"{PIECE}{PIECE}{PIECE}pass\n")

        io.write(self.io.getvalue())
        io.write("\n")
        io.write(f"pyfunc = JitFunction{narg}(<uint64_t>cfunc)\n")

        return initializations, io.getvalue()

    def get_label_id(self, lbl: Symbol) -> int:
        return self.lbls[lbl]

    def get_reg_name(self, reg: dynjit.Abs):
        if isinstance(reg.type, types.ConstT):
            return f"({reg.repr.c!r})"
        elif isinstance(reg.type, types.JitFPtrT):
            assert isinstance(reg.repr, dynjit.S)
            # noinspection PyUnresolvedReferences
            addr: str = hex(reg.repr.c.addr)
            func_name = self.func_ptrs.get(addr)
            if not func_name:
                func_name = f"cf{len(self.func_ptrs)}"
                narg = reg.type.narg
                self.func_defs.append(
                    f"cdef cfunc{narg} {func_name} = <cfunc{narg}>(<uint64_t>{addr})\n"
                )
                self.func_ptrs[addr] = func_name

            return func_name
        elif isinstance(reg.repr, dynjit.S):
            return self.const_of(reg.repr.c)
        return self.reg_names[reg.repr.n, reg.type]

    def newline(self):
        self.io.write("\n")

    def indent(self):
        self.indent_level += 1

    def dedent(self):
        self.indent_level -= 1

    def write(self, s: str):
        self.io.write(s)

    def write_indent(self, i: int = None):
        self.io.write(PIECE * (self.indent_level if i is None else i))

    def visit_expr(self, x: Expr):

        emit_expr(self, x)

    def visit_stmt(self, x: Stmt):
        return getattr(Emit, "visit_" + x.__class__.__name__)(self, x)

    def visit_stmts(self, xs: Sequence[Stmt]):

        v = Emit.visit_stmt
        n_lbl = 0
        lbls = self.lbls

        # merging label
        last_lbl = None
        checking_lbl = False
        for x in xs:
            if not checking_lbl:
                if isinstance(x, Label):
                    last_lbl = lbls[x.lbl]
                    checking_lbl = True

            elif isinstance(x, Label):
                lbls[x.lbl] = last_lbl
            else:
                checking_lbl = False

        for each in xs:
            if isinstance(each, Label):
                lbl = self.get_label_id(each.lbl)
                self.write_indent()
                self.write("CONT = {}\n".format(lbl))
                self.newline()

            v(self, each)

    def const_of(self, c):
        try:
            n = self.hashable_const_pools.get(c)
            if n is None:
                n = self.hashable_const_pools[
                    c
                ] = f"c_{len(self.hashable_const_pools)}"
            return n

        except TypeError:
            # unhashable
            for i, (e, n) in self.unhashable_const_pools:
                if e is c:
                    return n
            n = f"cc_{len(self.unhashable_const_pools)}"
            self.unhashable_const_pools.append((c, n))
            return n

    def visit_Assign(self, x: Assign):
        self.write_indent()
        self.visit_expr(x.target)
        self.write(" = ")
        self.visit_expr(x.expr)
        self.newline()

    def visit_Label(self, x: Label):
        lbl = self.get_label_id(x.lbl)
        if lbl in self.generated_lbls:
            return
        self.generated_lbls.add(lbl)

        self.write_indent(2)
        self.write("elif CONT == {}:".format(lbl))
        self.newline()

        self.write_indent(3)
        self.write("pass")
        self.newline()

    def visit_Goto(self, x: Goto):
        self.write_indent()
        self.write("CONT = {}".format(self.get_label_id(x.lbl)))
        self.newline()

        self.write_indent()
        self.write("continue")
        self.newline()

    def visit_Return(self, x: Return):
        self.write_indent()
        self.write("return ")
        self.visit_expr(x.expr)
        self.newline()

    def visit_If(self, x: If):
        self.write_indent()

        self.write("if ")
        self.visit_expr(x.cond)
        self.write(":")
        self.newline()

        self.indent()

        self.write_indent()
        self.write("CONT = {}".format(self.get_label_id(x.jmp)))
        self.newline()

        self.write_indent()
        self.write("continue")
        self.newline()

        self.dedent()

    def visit_TypeCheck(self, x: TypeCheck):
        self.write_indent()

        assert isinstance(x.expr, dynjit.Abs)

        self.write("if type(")
        self.visit_expr(x.expr)
        self.write(") is ")
        self.write(self.const_of(x.type.to_py_type()))
        self.write(":")

        self.newline()

        self.indent()

        self.write_indent()
        self.write("CONT = {}".format(self.get_label_id(x.jmp)))
        self.newline()

        self.write_indent()
        self.write("continue")
        self.newline()

        self.dedent()

    def visit_Empty(self, _: Empty):
        self.write_indent()
        self.write("pass")
        self.newline()
