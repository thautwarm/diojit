from jit.flat import *
from io import StringIO


class MissingDict(dict):
    def __missing__(self, key):
        v = self[key] = len(self)
        return v


class Emit:
    def __init__(self):
        self.reg_names = MissingDict()
        self.lbls = MissingDict()
        self.hashable_const_pools = {}
        self.unhashable_const_pools = []
        self.io = StringIO()
        self.indent_level = 0
        self.generate_syms = []

    def get_label_id(self, lbl: Symbol) -> int:
        return self.lbls[lbl]

    def new_sym(self):
        n = f'__dynjit_tmp_{len(self.generate_syms)}'
        self.generate_syms.append(n)
        return n

    def get_reg_name(self, reg: dynjit.AbstractValue):
        if isinstance(reg.repr, dynjit.S):
            return self.const_of(reg.repr.c)
        return f"d{self.reg_names[reg.repr.n, reg.type]}"

    def newline(self):
        self.io.write("\n")

    def indent(self):
        self.indent_level += 1

    def dedent(self):
        self.indent_level -= 1

    def write(self, s: str):
        self.io.write(s)

    def write_indent(self, i: int = None):
        self.io.write("  " * (self.indent_level if i is None else i))

    def visit_expr(self, x: Expr):
        if isinstance(x, dynjit.AbstractValue):
            self.write(self.get_reg_name(x))
        else:
            self.visit_expr(x.f)
            self.write("(")
            for each in x.args:
                self.visit_expr(each)
                self.write(",")
            self.write(")")

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
        self.write_indent(2)
        self.write(
            "{}if CONT == {}:".format(
                "el" if self.lbls else "", self.get_label_id(x.lbl)
            )
        )
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

        assert isinstance(x.expr, dynjit.AbstractValue)

        self.write("if type(")
        self.visit_expr(x.expr)
        self.write(") is ")
        self.visit_expr(self.const_of(x.type.to_py_type()))
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
