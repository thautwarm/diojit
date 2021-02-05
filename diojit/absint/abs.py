"""
<abs> ::= D_i^t | NonD
NonD  ::= S_o^ [<NonD>*]
      |   Top
      |   Bot
"""

from __future__ import annotations
from typing import (
    Union,
    Callable,
    Optional,
    Iterable,
    Sequence,
    TypeVar,
    Type,
    TYPE_CHECKING,
    cast,
)
from collections import defaultdict, OrderedDict
from contextlib import contextmanager
from functools import total_ordering
import types
import dataclasses
import pyrsistent
import builtins
from .intrinsics import *

NoneType = type(None)

# awesome pycharm :(
FunctionType: Type[types.FunctionType] = cast(
    Type[types.FunctionType], types.FunctionType
)

# set False when not made for Python
PYTHON = True

__all__ = [
    "Values",
    "AbsVal",
    "D",
    "S",
    "Top",
    "Bot",
    "Judge",
    "JITSpecInfo",
    "CallSpec",
    "CallRecord",
    "PreSpecMaps",
    "SpecMaps",
    "RecTraces",
    "In_Def",
    "In_Move",
    "In_Goto",
    "In_SetLineno",
    "In_Bind",
    "In_Stmt",
    "In_Blocks",
    "In_Cond",
    "In_Return",
    "Out_Def",
    "Out_Label",
    "Out_Call",
    "Out_Return",
    "Out_Goto",
    "Out_TypeCase",
    "Out_If",
    "Out_Assign",
    "Out_Error",
    "Out_SetLineno",
    "Out_Instr",
    "Out_Expr",
    "print_out",
    "print_in",
    "from_runtime",
    "AWARED_IMMUTABLES",
    "ShapeSystem",
    "Shape",
    "FunctionType",  # TODO: put it elsewhere
]


class Out_Callable:
    def __call__(self, *args: AbsVal):
        # noinspection PyTypeChecker
        return Out_Call(self, args)


class AbsVal:
    if TYPE_CHECKING:

        @property
        def type(self) -> NonD:
            raise NotImplementedError

        def is_literal(self) -> bool:
            raise NotImplementedError


@total_ordering
class D(Out_Callable, AbsVal):
    """
    dynamic abstract value
    """

    i: int
    type: NonD

    def __init__(self, i: int, type: NonD):
        self.i = i
        self.type = type

    def __repr__(self):
        if self.type is Top:
            return f"D{self.i}"
        return f"D{self.i} : {self.type}"

    def is_literal(self):
        return False

    def __hash__(self):
        return 114514 ^ hash(self.i) ^ hash(self.type)

    def __eq__(self, other):
        return (
            isinstance(other, D)
            and self.i == other.i
            and self.type == other.type
        )

    def __lt__(self, other):
        # noinspection PyTypeHints
        if not isinstance(other, AbsVal):
            return False
        if other is Top or other is Bot:
            return True
        if isinstance(other, S):
            return True
        if self.i == other.i:
            return self.type < other.type
        return self.i < other.i


@total_ordering
class S(Out_Callable, AbsVal):
    """
    type abstract value
    """

    base: object
    params: Optional[tuple[NonD, ...]]

    def __init__(
        self, base: object, params: Optional[tuple[NonD, ...]] = None
    ):
        self.base = base
        self.params = params

    def __hash__(self):
        return 1919810 ^ hash(self.base) ^ hash(self.params)

    def __eq__(self, other):
        return (
            isinstance(other, S)
            and self.base == other.base
            and self.params == other.params
        )

    def __lt__(self, other):
        # noinspection PyTypeHints
        if not isinstance(other, AbsVal):
            return False
        if other is Top or other is Bot:
            return True
        if isinstance(other, D):
            return False
        if self.base == other.base:
            return self.params < other.params
        return hash(self.base) < hash(other.base)

    @property
    def type(self):
        base = self.base
        t = type(base)
        if abs_t := _literal_type_maps.get(t):
            return abs_t
        elif t is tuple:
            return tuple_type(base)
        a_t = from_runtime(t)
        assert not isinstance(a_t, D)
        return a_t

    @property
    def shape(self) -> Optional[Shape]:
        if type(self.base) in _literal_type_maps:
            return
        return ShapeSystem.get(self.base)

    def is_literal(self):
        return type(self.base) in _literal_type_maps

    def __repr__(self):
        if isinstance(self.base, type):
            n = self.base.__name__
        elif isinstance(self.base, FunctionType):
            n = self.base.__name__
        elif isinstance(self.base, types.BuiltinFunctionType):
            n = f"{self.base.__module__}.{self.base.__name__}"
        else:
            n = repr(self.base)

        if self.params is None:
            return n

        return f"{n}<{', '.join(map(repr, self.params))}>"


class Values:
    A_Int = S(int)
    A_Float = S(float)
    A_Str = S(str)
    A_NoneType = S(NoneType)
    A_FuncType = S(FunctionType)
    A_MethType = S(types.MethodType)
    A_Complex = S(complex)
    A_Bool = S(bool)
    A_Intrinsic = S(Intrinsic)
    A_Type = S(type)
    A_NotImplemented = S(NotImplemented)
    A_NotImplementedType = S(type(NotImplemented))


A_Int = Values.A_Int
A_Float = Values.A_Float
A_Str = Values.A_Str
A_NoneType = Values.A_NoneType
A_FuncType = Values.A_FuncType
A_Bool = Values.A_Bool
A_Intrinsic = Values.A_Intrinsic
A_Complex = Values.A_Complex


_literal_type_maps = {
    int: A_Int,
    float: A_Float,
    complex: A_Complex,
    str: A_Str,
    bool: A_Bool,
    NoneType: A_NoneType,
    tuple: None,
}

_T = TypeVar("_T")


class _Top(Out_Callable, AbsVal):
    def is_literal(self) -> bool:
        return False

    @property
    def type(self):
        raise TypeError

    def __repr__(self):
        return "Top"


class _Bot(Out_Callable, AbsVal):
    def is_literal(self) -> bool:
        return False

    @property
    def type(self):
        raise TypeError

    def __repr__(self):
        return "Bot"


Top = _Top()
Bot = _Bot()

NonD = Union[S, _Top, _Bot]
if TYPE_CHECKING:
    AbsVal = Union[D, NonD]


undef = object()


@dataclasses.dataclass
class Shape:
    name: object
    oop: bool
    fields: dict[str, Union[AbsVal, types.FunctionType]]
    # some type has unique instance
    # None.__class__ has None only
    instance: Callable[
        [tuple[NonD, ...]], Optional[AbsVal]
    ] = dataclasses.field(default=None)


# None: means No Shape
ShapeSystem: dict[object, Optional[Shape]] = {}

AWARED_IMMUTABLES = {*_literal_type_maps, type, Intrinsic, FunctionType}


def from_runtime(o: object, rt_map: list[object] = None):
    if hash(o):
        return S(o)
    t = type(o)
    if t is tuple:
        type_abs = tuple_type(o)
    else:
        type_abs = from_runtime(t)
    rt_map = rt_map or []
    i = len(rt_map)
    abs_val = D(i, type_abs)
    rt_map.append(abs_val)
    return abs_val


def tuple_type(xs):
    return S(tuple, tuple(from_runtime(x) for x in xs))


@dataclasses.dataclass(frozen=True)
class In_Move:
    target: D
    source: AbsVal

    def __repr__(self):
        return f"{self.target} = {self.source!r}"


@dataclasses.dataclass(frozen=True)
class In_Bind:
    target: D
    sub: AbsVal
    attr: AbsVal
    args: tuple[AbsVal, ...]

    def __repr__(self):
        args = [repr(x) for x in self.args]
        return f"{self.target} = {self.sub!r}.{self.attr}({','.join(args)})"


@dataclasses.dataclass(frozen=True)
class In_Goto:
    label: str

    def __repr__(self):
        return f"goto {self.label}"


@dataclasses.dataclass(frozen=True)
class In_SetLineno:
    line: int
    filename: str

    def __repr__(self):
        return f"# line {self.line} at {self.filename}"


@dataclasses.dataclass(frozen=True)
class In_Cond:
    test: AbsVal
    then: str
    otherwise: str

    def __repr__(self):
        return (
            f"if {self.test!r} then {self.then} else {self.otherwise}"
        )


@dataclasses.dataclass(frozen=True)
class In_Return:
    value: AbsVal

    def __repr__(self):
        return f"return {self.value!r}"


In_Stmt = Union[
    In_Cond, In_SetLineno, In_Goto, In_Move, In_Return, In_Bind
]
In_Blocks = "dict[str, list[In_Stmt]]"


def print_in(b: In_Blocks, print=print):
    for label, xs in sorted(b.items(), key=lambda x: x[0] != "entry"):
        print(label, ":")
        for each in xs:
            print(each)


@dataclasses.dataclass
class In_Def:
    narg: int
    blocks: In_Blocks
    _func: FunctionType
    static_glob: set[str]

    UserCodeDyn = {}  # type: dict[FunctionType, In_Def]

    def show(self):
        args = [f"D[{i}]" for i in range(self.narg)]

        print(f'def {self.name}({",".join(args)})', "{")
        print_in(self.blocks, print=lambda *x: print("", *x))
        print("}")

    @property
    def func(self) -> FunctionType:
        """this is for hacking PyCharm's type checker"""
        # noinspection PyTypeChecker
        return self._func

    @property
    def name(self) -> str:
        return self.func.__name__

    @property
    def glob(self) -> dict:
        # noinspection PyUnresolvedReferences
        return self.func.__globals__


@dataclasses.dataclass(unsafe_hash=True)
class Out_Call(Out_Callable):
    func: Out_Expr
    args: tuple[Out_Expr, ...]

    def __repr__(self):
        return f"{self.func!r}{self.args!r}"


Out_Expr = Union[Out_Call, AbsVal]


@dataclasses.dataclass(frozen=True)
class Out_Assign:
    target: D
    expr: Out_Call

    def show(self, prefix, print):
        print(f"{prefix}{self.target} = {self.expr!r}")


@dataclasses.dataclass(frozen=True)
class Out_If:
    test: AbsVal

    t: str
    f: str

    def show(self, prefix, print):
        print(f"{prefix}if {self.test!r}")
        print(f"{prefix}then goto {self.t}")
        print(f"{prefix}else goto {self.f}")


@dataclasses.dataclass(frozen=True)
class Out_TypeCase:
    obj: AbsVal
    cases: pyrsistent.PMap[AbsVal, tuple[Out_Instr, ...]]

    def show(self, prefix, print):
        print(f"{prefix}case typeof {self.obj!r}")
        for t, xs in self.cases.items():
            print(f"{prefix}  {t!r} ->")
            print_out(xs, prefix + "    ", print)


@dataclasses.dataclass(frozen=True)
class Out_Label:
    label: str

    def show(self, prefix, print):
        print(f"label {self.label}:")


@dataclasses.dataclass(frozen=True)
class Out_Goto:
    label: str

    def show(self, prefix, print):
        print(f"{prefix}goto {self.label}")


@dataclasses.dataclass(frozen=True)
class Out_Error:
    def show(self, prefix, print):
        print(f"{prefix}error!")


@dataclasses.dataclass(frozen=True)
class Out_Return:
    value: AbsVal

    def show(self, prefix, print):
        print(f"{prefix}return {self.value!r}")


@dataclasses.dataclass(frozen=True)
class Out_SetLineno:
    line: int
    filename: str

    def show(self, prefix, print):
        print(f"{prefix}# line {self.line} at {self.filename}")


Out_Instr = Union[
    Out_Label,
    Out_TypeCase,
    Out_If,
    Out_Assign,
    Out_Return,
    Out_Goto,
    Out_Error,
]


CallRecord = "tuple[FunctionType, tuple[AbsVal, ...]]"


def print_out(xs: Iterable[Out_Instr], prefix, print):
    for each in xs:
        each.show(prefix, print)


@dataclasses.dataclass
class Out_Def:
    spec: JITSpecInfo
    params: tuple[AbsVal, ...]
    instrs: tuple[Out_Instr, ...]
    start: str
    func: FunctionType

    GenerateCache = OrderedDict()  # type: dict[Intrinsic, Out_Def]

    @property
    def name(self) -> str:
        return self.func.__name__

    def show(self, print=print):
        ret_types = self.spec.possibly_return_types
        name = self.spec.abs_jit_func
        instance = self.spec.instance
        print(
            "|".join(map(repr, ret_types)),
            f"{name!r}(",
            ", ".join(map(repr, self.params)),
            ")",
            f"-> {instance} {{" if instance else "{",
        )
        # print(f"  START from {self.start}")
        for i in self.instrs:
            i.show("  ", print)
        print("}")


@dataclasses.dataclass
class JITSpecInfo:
    instance: Optional[AbsVal]  # maybe return a constant instance
    abs_jit_func: AbsVal
    possibly_return_types: tuple[AbsVal, ...]


@dataclasses.dataclass
class CallSpec:
    instance: Optional[AbsVal]  # maybe return a constant instance
    e_call: Out_Expr
    possibly_return_types: tuple[AbsVal, ...]

    def astuple(self):
        return self.instance, self.e_call, self.possibly_return_types


## user function calls recorded here cannot be reanalyzed next time
RecTraces: set[tuple[str, tuple[AbsVal, ...]]] = set()

## specialisations map
## return types not inferred but compiled function name, and partially inferenced types
PreSpecMaps: dict[CallRecord, tuple[str, set[AbsVal, ...]]] = {}

## cache return types and function address
SpecMaps: dict[CallRecord, JITSpecInfo] = {}


def mk_prespec_name(key: CallRecord, partial_returns: set[AbsVal], name=""):
    v = PreSpecMaps.get(key)
    if v is None:
        i = len(PreSpecMaps)
        n = f"J_{name.replace('_', '__')}_{i}"
        PreSpecMaps[key] = n, partial_returns
        return n
    return v[0]



@dataclasses.dataclass(frozen=True)
class Local:
    mem: pyrsistent.PVector[int]
    store: pyrsistent.PMap[int, AbsVal]

    def up_mem(self, mem):
        return Local(mem, self.store)

    def up_store(self, store):
        return Local(self.mem, store)


def alloc(local: Local):
    i = -1
    for i, each in enumerate(local.mem):
        if each == 0:
            return i
    i += 1
    return i


def decref(local: Local, a: AbsVal):
    if not isinstance(a, D):
        return local
    i = a.i
    if i < len(local.mem):
        mem = local.mem
        mem = mem.set(i, max(mem[i] - 1, 0))
        return local.up_mem(mem)
    return local


def incref(local: Local, a: AbsVal):
    if not isinstance(a, D):
        return local
    i = a.i
    mem = local.mem
    try:
        ref = mem[i]
        mem = mem.set(i, ref + 1)
    except IndexError:
        assert len(mem) == i
        mem = mem.append(1)
    return local.up_mem(mem)


def valid_value(x: AbsVal, mk_exc=None):
    if x is Bot or x is Top:
        raise mk_exc and mk_exc() or TypeError
    return x


def judge_lit(local: Local, a: AbsVal):
    if isinstance(a, D):
        abs_val = local.store.get(a.i)
        return abs_val or Bot
    return a


def judge_coerce(a, t: NonD):
    if t is Bot:
        return [], Bot
    if isinstance(a, D):
        # noinspection PyUnboundLocalVariable
        if (
            isinstance(t, S)
            and (shape := t.shape)
            and (inst := shape.instance)
        ):
            # noinspection PyTypeHints
            # noinspection PyUnboundLocalVariable
            if isinstance(inst, AbsVal):
                # noinspection PyUnboundLocalVariable
                return [], inst
            # noinspection PyUnboundLocalVariable
            inst = inst(t.params)
            return [], inst
        a_t = D(a.i, t)
        return [], a_t
    return [], a


def blocks_to_instrs(blocks: dict[str, list[Out_Instr]], start: str):
    merge_blocks = defaultdict(OrderedDict)
    for label, block in sorted(blocks.items()):
        block = tuple(block)
        labels = merge_blocks[block]
        labels[label] = None
    instrs = []
    for block, labels in merge_blocks.items():
        for label in labels:
            instrs.append(Out_Label(label))
        instrs.extend(block)
    return instrs


class Judge:
    def __init__(self, blocks: In_Blocks, func: FunctionType, abs_glob):
        # States
        self.in_blocks = blocks
        self.block_map: dict[tuple[str, Local], str] = {}
        self.returns: set[AbsVal] = set()
        self.code: list[Out_Instr] = []
        self.out_blocks: dict[str, list[Out_Instr]] = OrderedDict()
        self.abs_glob: dict[str, AbsVal] = abs_glob
        self.func = func
        self.label_cnt = 0

    @property
    def glob(self) -> dict:
        # noinspection PyUnresolvedReferences
        return self.func.__globals__

    @contextmanager
    def use_code(self, code: list[Out_Instr]):
        old_code = self.code
        self.code = code
        try:
            yield
        finally:
            self.code = old_code

    def gen_label(self, kind=""):
        self.label_cnt += 1
        return f"{kind}_{self.label_cnt}"

    def __lshift__(self, a):
        if isinstance(a, list):
            self.code.extend(a)
        else:
            self.code.append(a)

    def jump(self, local: Local, label: str):
        key = (label, local)
        if gen_label := self.block_map.get(key):
            return gen_label
        gen_label = self.gen_label()
        self.block_map[key] = gen_label
        code = []
        with self.use_code(code):
            self.stmt(local, self.in_blocks[label], 0)
        self.out_blocks[gen_label] = code
        return gen_label

    def stmt(self, local: Local, xs: Sequence[In_Stmt], index: int):
        try:
            while (hd := xs[index]) and isinstance(hd, In_SetLineno):
                self << Out_SetLineno(hd.line, hd.filename)
                index += 1

            # print(hd, local.store)
        except IndexError:
            # TODO
            raise Exception("non-terminaor terminate")
        if isinstance(hd, In_Move):
            a_x = judge_lit(local, hd.target)
            # print(hd, judge_lit(local, hd.source), local.store)
            a_y = judge_lit(local, hd.source)
            if a_y is Top or a_y is Bot:
                self << Out_Error()
                return

            local = decref(local, a_x)
            local = incref(local, a_y)
            local = local.up_store(local.store.set(hd.target.i, a_y))
            self.stmt(local, xs, index + 1)
        elif isinstance(hd, In_Goto):
            label_gen = self.jump(local, hd.label)
            self << Out_Goto(label_gen)
        elif isinstance(hd, In_Return):
            a = valid_value(judge_lit(local, hd.value))
            self.returns.add(a)
            self << Out_Return(a)
        elif isinstance(hd, In_Cond):
            a = judge_lit(local, hd.test)
            if a is Top or a is Bot:
                self << Out_Error()
                return

            if a.type == A_Bool:
                a_cond = a
            else:
                # extract
                instance, e_call, union_types = self.spec(
                    A_Bool, "__call__", [a]
                ).astuple()
                if e_call is Top or e_call is Bot:
                    self << Out_Error()
                    return

                if not isinstance(e_call, (Out_Call, D)):
                    a_cond = e_call
                else:
                    j = alloc(local)
                    a_cond = D(j, A_Bool)
                    self << Out_Assign(a_cond, e_call)
                if instance:
                    a_cond = instance

            if a_cond.is_literal() and isinstance(a_cond.base, bool):
                direct_label = hd.then if a_cond.base else hd.otherwise
                label_generated = self.jump(local, direct_label)
                self << Out_Goto(label_generated)
                return

            l1 = self.jump(local, hd.then)
            l2 = self.jump(local, hd.otherwise)
            self << Out_If(a_cond, l1, l2)
        elif isinstance(hd, In_Bind):
            a_x = judge_lit(local, hd.target)
            a_subj = judge_lit(local, hd.sub)
            if a_subj is Top or a_subj is Bot:
                self << Out_Error()
                return
            attr = judge_lit(local, hd.attr)
            assert attr.is_literal() and isinstance(
                attr.base, str
            ), f"attr {attr} shall be a string"
            attr = attr.base
            a_args = []
            for a in hd.args:
                a_args.append(judge_lit(local, a))
                if a_args[-1] in (Top, Bot):
                    self << Out_Error()
                    return
            local = decref(local, a_x)
            instance, e_call, union_types = self.spec(
                a_subj, attr, a_args
            ).astuple()

            if e_call in (Top, Bot):
                self << Out_Error()
                return
            # 1. no actual CALL happens
            if not isinstance(e_call, (Out_Call, D)):
                rhs = e_call
                if instance:
                    rhs = instance
                local = local.up_store(
                    local.store.set(hd.target.i, rhs)
                )
                self.stmt(local, xs, index + 1)
                return

            j = alloc(local)
            # 2. CALL happens but not union-typed and the result might be a constant
            if len(union_types) == 1:
                a_t = union_types[0]
                a_spec = D(j, a_t)
                if isinstance(e_call, Out_Call):
                    self << Out_Assign(a_spec, e_call)
                    # TODO: documenting that 'D(i, t1)' means 'D(i, t2)'
                    #  at a given program counter.
                if a_t is Bot:
                    self << Out_Error()
                    return
                a_t = a_spec.type
                _, a_spec = judge_coerce(a_spec, a_t)  # handle instance
                valid_value(a_spec)
                local = incref(local, a_spec)
                local = local.up_store(
                    local.store.set(hd.target.i, a_spec)
                )
                self.stmt(local, xs, index + 1)
                return
            # 3. CALL happens, union-typed;
            # result might be a constant for each type
            a_union = D(j, Top)
            self << Out_Assign(a_union, e_call)
            # TODO: Top(if any) should be put in the last of 'union_types'
            split = [judge_coerce(a_union, t) for t in union_types]
            cases: list[tuple[S, list[Out_Instr]]] = []
            for (code, a_spec), a_t in zip(split, union_types):
                cases.append((a_t, code))
                if a_t is Bot:
                    code.append(Out_Error())
                    continue

                valid_value(a_spec)
                local_i = incref(local, a_spec)
                local_i = local_i.up_store(
                    local_i.store.set(hd.target.i, a_spec)
                )
                with self.use_code(code):
                    self.stmt(local_i, xs, index + 1)
            self << Out_TypeCase(
                a_union,
                pyrsistent.pmap(
                    {case: tuple(code) for case, code in cases}
                ),
            )

    def no_spec(
        self, a_sub: AbsVal, attr: str, a_args: list[AbsVal]
    ) -> CallSpec:
        assert isinstance(attr, str)
        a_sub = valid_value(a_sub)
        if attr == "__call__":
            return CallSpec(
                None,
                S(Intrinsic.Py_CallFunction)(a_sub, *a_args),
                (Top,),
            )
        else:
            return CallSpec(
                None,
                S(Intrinsic.Py_CallMethod)(a_sub, S(attr), *a_args),
                (Top,),
            )

    def spec(
        self, a_sub: AbsVal, attr: str, a_args: list[AbsVal]
    ) -> CallSpec:
        assert isinstance(attr, str)
        a_sub = valid_value(a_sub)
        if attr == "__call__":

            def default():
                return CallSpec(
                    None,
                    S(Intrinsic.Py_CallFunction)(a_sub, *a_args),
                    (Top,),
                )

        else:

            def default():
                return CallSpec(
                    None,
                    S(Intrinsic.Py_CallMethod)(a_sub, S(attr), *a_args),
                    (Top,),
                )

        a_t = a_sub.type
        if a_t is Top:
            return default()
        if a_t is Bot:
            raise TypeError
        if isinstance(a_sub, S):
            # python literal is not callable
            if a_sub.is_literal():
                a_t = cast(S, a_t)
                shape = a_t.shape
                if not shape:
                    return default()
                assert shape.oop
                meth = judge_resolve(shape, attr)
                if not meth:
                    return default()
                # noinspection PyTypeHints
                if isinstance(meth, AbsVal):
                    return self.spec(meth, "__call__", [a_sub, *a_args])
                r = meth(self, a_sub, *a_args)
                if r is NotImplemented:
                    return default()
                return r
            shape = a_sub.shape
            if shape and (meth_ := judge_resolve(shape, attr)):
                # hack pycharm for type check
                # noinspection PyUnboundLocalVariable
                meth = meth_
                # noinspection PyTypeHints
                if isinstance(meth, AbsVal):
                    return self.spec(meth, "__call__", a_args)

                r = meth(self, *a_args)
                if r is NotImplemented:
                    return default()
                return r

        a_t = cast(S, a_t)
        shape = a_t.shape
        if not shape:
            return default()
        meth = judge_resolve(shape, attr)
        if not meth:
            return default()
        if shape.oop:
            a_args = [a_sub, *a_args]

        # noinspection PyTypeHints
        if isinstance(meth, AbsVal):
            return self.spec(meth, "__call__", a_args)

        r = meth(self, *a_args)
        if r is NotImplemented:
            return default()
        return r


def ufunc_spec(self, a_func: AbsVal, *arguments: AbsVal) -> CallSpec:
    a_func = valid_value(a_func)

    def default():
        return CallSpec(
            None,
            S(Intrinsic.Py_CallFunction)(a_func, *arguments),
            (Top,),
        )

    if isinstance(a_func, D):
        return default()
    # isinstance functiontype not handled in PyCharm
    assert isinstance(a_func.base, FunctionType)
    func = a_func.base
    in_def = In_Def.UserCodeDyn.get(func)
    if not in_def:
        # not registered as jit func, skip
        return default()
    parameters = []
    mem = []
    store = {}

    for i, a_arg in enumerate(arguments):
        if isinstance(a_arg, D):
            j = len(mem)
            mem.append(1)
            a_param = D(j, a_arg.type)
            parameters.append(a_param)

        else:
            a_param = a_arg
            parameters.append(a_arg)
        store[i] = a_param

    parameters = tuple(parameters)
    call_record = a_func.base, parameters
    if call_record in SpecMaps:
        spec = SpecMaps[call_record]
        e_call = spec.abs_jit_func(*arguments)
        ret_types = spec.possibly_return_types
        instance = spec.instance
    elif partial_spec := PreSpecMaps.get(call_record):
        jit_func_name, partial_returns = partial_spec
        abs_jit_func = S(intrinsic(jit_func_name))
        e_call = abs_jit_func(*arguments)
        partial_return_types = set(each.type for each in partial_returns)
        partial_return_types.add(Top)
        ret_types = tuple(sorted(partial_return_types))
        instance = None
    else:
        partial_returns = set()
        jit_func_name = mk_prespec_name(call_record, partial_returns, name=in_def.name)

        abs_glob = {}
        for glob_name in in_def.static_glob:
            v = in_def.glob.get(glob_name, undef)
            if v is undef:
                v = getattr(builtins, glob_name, undef)
                if v is undef:
                    continue
            a_v = from_runtime(v)
            if isinstance(v, D):
                continue
            abs_glob[glob_name] = a_v

        sub_judge = Judge(
            blocks=in_def.blocks, func=in_def.func, abs_glob=abs_glob
        )
        sub_judge.returns = partial_returns
        local = Local(pyrsistent.pvector(mem), pyrsistent.pmap(store))
        gen_start = sub_judge.jump(local, "entry")
        instrs = blocks_to_instrs(sub_judge.out_blocks, gen_start)

        ret_types = tuple(sorted({r.type for r in sub_judge.returns}))
        instance, *is_union = sub_judge.returns
        instance = valid_value(instance)
        if is_union:
            instance = None
        if isinstance(instance, D):
            instance = None
        intrin = intrinsic(jit_func_name)
        spec_info = JITSpecInfo(instance, S(intrin), ret_types)
        out_def = Out_Def(
            spec_info, parameters, tuple(instrs), gen_start, in_def.func
        )
        Out_Def.GenerateCache[intrin] = out_def
        e_call = spec_info.abs_jit_func(*arguments)

    return CallSpec(instance, e_call, ret_types)


ShapeSystem[types.FunctionType] = Shape(
    types.FunctionType,
    oop=True,
    fields={"__call__": cast(FunctionType, ufunc_spec)},
)


def judge_resolve(shape: Shape, attr: str):
    if meth := shape.fields.get(attr):
        return meth
    if not isinstance(shape.name, type):
        return None
    for base in shape.name.__bases__:
        if (shape := ShapeSystem.get(base)) and (
            meth := shape.fields.get(attr)
        ):
            return meth

    return None
