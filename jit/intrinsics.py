import operator

intrinsic_globals = globals
intrinsic_locals = locals


def i_deref(x):
    return x.cell_contents


i_getitem = operator.getitem


def i_exec_match(err, exc):
    raise NotImplemented


def i_buildtuple(*args):
    return args


def i_buildlist(*args):
    return list(args)


def i_setitem(x, i, v):
    x[i] = v


def i_store(x, v):
    x.cell_contents = v


i_not = operator.not_


i_getattr = getattr
i_setattr = setattr


def i_getcells(s):
    return s.__closure__


def i_pycall(f, *args):
    return f(*args)


i_isinstance = isinstance


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


i_asbool = bool
