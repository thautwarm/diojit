from __future__ import annotations
from .. import absint
from ..stack2reg.translate import translate
from typing import Iterable
import dataclasses

__all__ = [
    "jit",
    "jit_spec_call",
    "jit_spec_call_ir",
    "oftype",
    "ofval",
]


def jit(
    func: absint.FunctionType = None,
    fixed_references: Iterable[str] = None,
):

    if fixed_references:
        fixed_references = set(fixed_references)
        if not func:
            return lambda func: _jit(func, fixed_references)
        return _jit(func, fixed_references)
    else:
        assert func
        return _jit(func, set())


def _jit(func: absint.FunctionType, glob: set[str]):

    code = func.__code__
    blocks, glob_names = translate(func)
    static_global = glob_names & glob
    in_def = absint.In_Def(
        code.co_argcount,
        blocks,
        func,
        static_global,
    )
    absint.In_Def.UserCodeDyn[func] = in_def
    return func


@dataclasses.dataclass
class Val:
    a: object


def jit_spec_call_ir(
    f: absint.FunctionType, *args, attr="__call__", glob=None
):
    rt_map = []
    a_args = []
    for arg in args:
        if isinstance(arg, Val):
            a_args.append(absint.from_runtime(arg.a))
        else:
            assert isinstance(arg, absint.AbsVal)
            a_args.append(absint.D(len(rt_map), arg))
    a_f = absint.from_runtime(f, rt_map)
    j = absint.Judge({}, f, {} if glob is None else glob)
    return j.spec(a_f, attr, a_args)


_code_gen = None


def jit_spec_call(
    f: absint.FunctionType,
    *args,
    attr="__call__",
    glob=None,
    print_jl=None,
    print_dio_ir=None,
):
    global _code_gen
    if not _code_gen:
        from diojit.runtime.julia_rt import code_gen

        _code_gen = code_gen

    rt_map = []
    a_args = []
    for arg in args:
        if isinstance(arg, Val):
            a_args.append(absint.from_runtime(arg.a))
        else:
            assert isinstance(arg, absint.AbsVal)
            a_args.append(absint.D(len(rt_map), arg))
    a_f = absint.from_runtime(f, rt_map)
    j = absint.Judge({}, f, {} if glob is None else glob)
    spec = j.spec(a_f, attr, a_args)
    jit_f = spec.e_call.func.base
    assert isinstance(jit_f, absint.Intrinsic)
    if print_dio_ir:
        from diojit.runtime.julia_rt import GenerateCache

        for each in GenerateCache.values():
            each.show(print_dio_ir)

    _code_gen(print_jl)
    return getattr(jit_f, "_callback")


def oftype(t: object):
    """
    create an abstract value from type object
    """
    abs = absint.from_runtime(t)
    if not isinstance(abs, absint.D):
        return abs
    raise TypeError(f"{t} is not a type")


def ofval(o: object):
    return Val(o)
