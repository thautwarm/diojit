from __future__ import annotations
import typing
import dataclasses
import sys
from diojit.absint.intrinsics import intrinsic
from diojit.absint.prescr import create_shape, register

from ..absint.abs import (
    CallSpec,
    FunctionType,
    S,
    Top,
    AbsVal,
)
from .. import absint
from ..stack2reg.translate import translate
from typing import Iterable

__all__ = [
    "eagerjit",
    "conservativejit",
    "jit",
    "eager_jitclass",
    "jitclass", "spec_call", "spec_call_ir",
    "oftype",
    "ofval",
]


def _is_function(o):
    return isinstance(o, type(_is_function))


def jit(
    func: absint.FunctionType = None,
    fixed_references: Iterable[str] = None,
):

    if fixed_references is not None:
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


def spec_call_ir(
    f: FunctionType, *args, attr="__call__", glob=None
):
    narg = f.__code__.co_argcount
    assert (
        _is_function(f) and len(args) == narg
    ), f"Function {f} takes exactly {narg} arguments."

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


def spec_call(
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

    narg = f.__code__.co_argcount
    assert (
        _is_function(f) and len(args) == narg
    ), f"Function {f} takes exactly {narg} arguments."
    rt_map = []
    a_args = []
    for arg in args:
        if isinstance(arg, Val):
            a_args.append(absint.from_runtime(arg.a))
        else:
            assert isinstance(arg, absint.AbsVal), arg
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


def eagerjit(func: typing.Union[FunctionType, type]):
    if isinstance(func, type):
        cls = func
        return eager_jitclass(cls)
    assert isinstance(func, FunctionType)
    fixed_references = func.__code__.co_names
    return _jit(func, set(fixed_references))


def conservativejit(
    func: typing.Union[FunctionType, type], fixed_references=()
):
    fixed_references = set(fixed_references)
    if isinstance(func, type):
        cls = func
        return jitclass(cls, fixed_references)
    assert isinstance(func, FunctionType)
    fixed_references = func.__code__.co_names
    return _jit(func, fixed_references)


_cache = {}

u_inst_type = type(typing.Union[int, float])


def process_annotations(anns: dict, glob: dict):
    if ret := _cache.get(id(anns)):
        return ret

    def each(v):
        if isinstance(v, str):
            v = eval(v, glob)
        if hasattr(typing, "GenericAlias") and isinstance(
            v, typing.GenericAlias
        ):
            v = v.__origin__
        elif type(v) is u_inst_type and v.__origin__ is typing.Union:
            return tuple(each(a) for a in v.__args__)

        assert isinstance(v, type), v
        return S(v)

    ret = {k: each(v) for k, v in anns.items()}
    _cache[id(anns)] = ret
    return ret


def eager_jitclass(cls: type):
    shape = create_shape(cls, oop=True)
    if annotations := getattr(cls, "__annotations__", None):

        def get_attr(self, *args: AbsVal):
            if len(args) != 2:
                return NotImplemented
            a_obj, a_attr = args
            if a_attr.is_literal() and a_attr.base in annotations:
                if ret_types := process_annotations(
                    annotations, sys.modules[cls.__module__].__dict__
                ).get(a_attr.base):
                    if not isinstance(ret_types, tuple):
                        assert isinstance(ret_types, AbsVal)
                        ret_types = (ret_types,)
                    func = S(intrinsic("PyObject_GetAttr"))
                    return CallSpec(
                        None, func(a_obj, a_attr), ret_types
                    )
            return NotImplemented

        register(cls, attr="__getattr__")(get_attr)

    for each, f in cls.__dict__.items():
        if not each.startswith("__") and isinstance(f, FunctionType):
            eagerjit(f)
            shape.fields[each] = S(f)
    return cls


def jitclass(
    cls: type,
    fixed_references: Iterable[str] = (),
    meth_jit_policy=conservativejit,
    jit_methods: typing.Union[all, Iterable[str]] = all,
):
    fixed_references = set(fixed_references)
    shape = create_shape(cls, oop=True)
    if annotations := getattr(cls, "__annotations__", None):

        def get_attr(self, *args: AbsVal):
            if len(args) != 2:
                return NotImplemented
            a_obj, a_attr = args
            if a_attr.is_literal() and a_attr.base in annotations:
                if ret_types := process_annotations(
                    annotations, sys.modules[cls.__module__].__dict__
                ).get(a_attr.base):
                    if not isinstance(ret_types, tuple):
                        assert isinstance(ret_types, AbsVal)
                        ret_types = (ret_types,)
                    func = S(intrinsic("PyObject_GetAttr"))
                    return CallSpec(
                        None, func(a_obj, a_attr), (*ret_types, Top)
                    )
            return NotImplemented

        register(cls, attr="__getattr__")(get_attr)

    for each, f in (
        jit_methods is all and cls.__dict__.items() or jit_methods
    ):
        if not each.startswith("__") and isinstance(f, FunctionType):
            meth_jit_policy(f, fixed_references)
            shape.fields[each] = S(f)
    return cls
