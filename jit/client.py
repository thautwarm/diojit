import jit.translate as translate
import jit.core as core
import jit.cflags as cflags
import typing as _t

import types


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


function = type(jit)


def _jit(func: types.FunctionType, glob):

    if func in core.STATIC_VALUE_MAPS:
        return func

    code = func.__code__
    hasvararg = bool(code.co_flags & cflags.VARARGS)
    blocks = translate.translate(func)

    in_def = core.In_Def(
        code.co_argcount,
        hasvararg,
        blocks,
        glob,
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


def display_corecpy(func):
    ufunc: core.StAbsVal = core.STATIC_VALUE_MAPS[func]
    in_def = core.In_Def.UserCodeDyn[ufunc.ts[0]]
    in_def.show()


def jit_call(f, *args, attr="__call__", glob=None):
    map_info = {}
    a_f = core.from_runtime(f, map_info)
    a_args = tuple(core.from_runtime(a, map_info) for a in args)
    j = core.Judge({}, [], {} if glob is None else glob)
    return map_info, core.spec(j, a_f, attr, a_args)
