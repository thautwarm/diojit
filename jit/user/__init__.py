from .. import absint
from ..stack2reg.translate import translate
from typing import Iterable
import dataclasses


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
        code.co_argcount, blocks, func.__name__, func.__globals__, static_global
    )
    absint.In_Def.UserCodeDyn[func] = in_def
    return func


@dataclasses.dataclass
class Val:
    a: object


def jit_spec_call_ir(f: absint.FunctionType, *args, attr="__call__", glob=None):
    rt_map = []
    a_args = []
    for arg in args:
        if isinstance(arg, Val):
            a_args.append(absint.from_runtime(arg.a))
        else:
            assert isinstance(arg, absint.AbsVal)
            a_args.append(absint.D(len(rt_map), arg))
    a_f = absint.from_runtime(f, rt_map)
    j = absint.Judge({}, [], {} if glob is None else glob)
    return j.spec(a_f, attr, a_args)
