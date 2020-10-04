from jit.flat import *


class Emit:
    def dedent(self):
        raise NotImplementedError

    def newline(self):
        raise NotImplementedError

    def expr(self, x: Expr):
        raise NotImplementedError

    def visit_Assign(self, x: Assign):
        if not x.target:
            self.expr(x.target)
            self.newline()
