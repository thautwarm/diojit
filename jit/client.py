import jit.translate as translate
import jit.core as core
import jit.cflags as cflags
import typing as _t
import builtins
import types
from collections import ChainMap


def jit(
    func: types.FunctionType = None,
    glob: _t.Dict[str, core.AbsVal] = None,
):
    if glob:
        if not func:
            return lambda func: _jit(func, glob)
        return _jit(func, glob)
    else:
        assert func
        return _jit(func, {})


def eager_jit(f: types.FunctionType):
    return _jit(f, f.__globals__)


function = type(jit)


def _jit(func: types.FunctionType, glob):

    if func in core.STATIC_VALUE_MAPS:
        return func

    code = func.__code__
    hasvararg = bool(code.co_flags & cflags.VARARGS)
    blocks, glob_names = translate.translate(func)

    abs_glob = {}
    glob = ChainMap(builtins.__dict__, glob)
    for n in glob_names:
        if n not in glob:
            continue
        var = core.from_runtime(glob[n])
        if not isinstance(var, core.DynAbsVal):
            abs_glob[n] = var

    in_def = core.In_Def(
        code.co_argcount,
        hasvararg,
        blocks,
        abs_glob,
        func.__name__,
        "entry",
    )
    i = len(core.In_Def.UserCodeDyn)
    name = f"{func.__name__} {i}"
    ufunc = core.StAbsVal(core.Name_FUN, (name,))
    core.STATIC_VALUE_MAPS[func] = ufunc
    core.In_Def.UserCodeDyn[name] = in_def
    core.UserFunctions[name] = func
    return func


def jit_spec_call(f, *args, attr="__call__", glob=None):
    a_f = core.from_runtime(f)
    a_args = tuple(core.from_runtime(a) for a in args)
    j = core.Judge({}, [], {} if glob is None else glob)
    return core.spec(j, a_f, attr, a_args)
