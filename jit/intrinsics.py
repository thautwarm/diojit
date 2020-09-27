import operator

intrinsic_globals = globals
intrinsic_locals = locals


def i_deref(x):
    return x.cell_contents


i_getitem = operator.getitem


def i_buildtuple(*args):
    return args


def i_buildlist(*args):
    return list(args)


def i_setitem(x, i, v):
    x[i] = v


def i_store(x, v):
    x.cell_contents = v


def i_not(x):
    return not x


def i_getattr(x, s):
    return getattr(x, s)


def i_getcells(s):
    return s.__closure__


def i_pycall(f, *args):
    return f(*args)


def i_isinstance(x, s):
    return isinstance(x, s)


def i_iadd(a: int, b: int):
    return a + b


def i_fadd(a: float, b: float):
    return a + b


def i_sconcat(a: str, b: str):
    return a + b


def i_sext(a: int):
    return float(a)


def i_beq(a: bool, b: bool):
    return a is b


def i_asbool(a: object):
    return bool(a)
