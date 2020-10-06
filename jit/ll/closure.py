class Closure:
    __slots__ = ["cell", "func"]

    def __init__(self, cell, fptr):
        # noinspection PyPropertyAccess
        self.cell = cell
        # noinspection PyPropertyAccess
        self.func = fptr

    def __call__(self, *args):
        return self.func(self.cell, *args)