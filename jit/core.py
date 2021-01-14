from __future__ import annotations
from dataclasses import dataclass
from contextlib import contextmanager
from collections import defaultdict, OrderedDict
from enum import Enum
import typing as _t
import types as _types
import dataclasses
import sys
import pyrsistent

# AbsVal
UNDEF = object()
literal_types = _t.Union[int, str, float, None, bool, complex]
literal_runtime_types = (int, str, float, type(None), bool, complex)


class Out_IExpr:
    def __call__(self, *args):
        self: Out_Expr
        return Out_Call(self, list(args))


class Constant(Out_IExpr):
    o: object
    t: AbsVal

    def __init__(self, o, t):
        self.o = o
        self.t = t

    def __repr__(self):
        return f"const[{self.o!r}]^[{self.t}]"


@dataclass(frozen=True)
class DynAbsVal(Out_IExpr):
    """
    dynamic abstract value
    """

    i: int
    t: AbsVal

    def __repr__(self):
        return f"D[{self.i}]^{self.t}"


@dataclass(frozen=True, order=True)
class StAbsVal(Out_IExpr):
    """
    static abstract value
    """

    o: object
    ts: _t.Tuple[
        _t.Union[StAbsVal, PrimAbsVal, literal_types], ...
    ] = dataclasses.field(default_factory=tuple)

    def shape(self):
        return ShapeSystem[self.o]

    def __repr__(self):
        if not self.ts:
            return f"S[{self.o}]"
        return f"S[{self.o}]^{list(self.ts)}"


# primitives
class PrimAbsVal(Out_IExpr, Enum):
    CallC = 0
    CallU = 1
    GetField = 2
    GetTypeField = 3
    GetClass = 4
    GetGlobal = 5
    CreateTuple = 6
    Coerce = 7
    Is = 8
    Not = 9
    IsInstance = 10
    AnyPack = 11
    IsStatic = 12
    CallS = 13
    ElimTypeVars = 14

    def __repr__(self):
        return "@" + self.name


# c api
class CAPI(Out_IExpr):
    cname: str

    def __init__(self, cname: str):
        self.cname = sys.intern(cname)

    def __repr__(self):
        return f"CAPI[{self.cname}]"


class CAPIs:
    CreateTuple = CAPI("create_tuple")
    CreateList = CAPI("create_list")
    Is = CAPI("identity_equal")
    Not = CAPI("not")


STATIC_VALUE_MAPS: _t.Dict[
    object, _t.Union[StAbsVal, PrimAbsVal, CAPI, Constant]
] = {}


def to_runtime(x: AbsVal):
    if isinstance(x, DynAbsVal):
        raise TypeError
    if isinstance(x, Constant):
        return x.o
    if isinstance(x, literal_runtime_types):
        return x
    if isinstance(x, StAbsVal):
        return ShapeSystem[x.o].to_py(x.ts)
    if isinstance(x, PrimAbsVal):
        return primitive_abs_typemap[x]
    raise TypeError


@dataclass
class RuntimeWrap:
    def __init__(self, o):
        self.o = o

    def __call__(self, *args, **kwargs):
        raise TypeError(f"calling jit only function {self.o}!")


def from_runtime(x: object):

    if isinstance(x, RuntimeWrap):
        return x.o

    if isinstance(x, literal_runtime_types):
        return x
    if isinstance(x, _types.ModuleType):
        return StAbsVal(Name_MOD, (x.__name__,))

    if isinstance(x, tuple):
        a_ts = tuple(map(judge_class, map(from_runtime, x)))
        a_t = StAbsVal(Name_TUPLE, a_ts)
        return Constant(x, a_t)

    as_abs = getattr(x, "__as_abstract__", None)
    if as_abs:
        return as_abs()

    try:
        hash(x)
        a = STATIC_VALUE_MAPS.get(x)
        if a is not None:
            return a
    except TypeError:
        pass
    t = type(x)
    a_t = from_runtime(t)
    return Constant(x, a_t)


AbsVal = _t.Union[
    DynAbsVal, StAbsVal, PrimAbsVal, CAPI, Constant, literal_types
]

# Shape System


@dataclass
class Shape:
    name: object
    cls: AbsVal
    bases: _t.List[AbsVal]
    fields: _t.Dict[str, AbsVal]
    to_py: _t.Callable[[AbsValSeq], object]
    instance: _t.Callable[[AbsValSeq], AbsVal] = dataclasses.field(
        default=lambda _: UNDEF
    )


ShapeSystem: _t.Dict[object, Shape] = {}

NonDyn = _t.Union[StAbsVal, PrimAbsVal, CAPI, literal_types]
AbsValSeq = _t.Tuple[AbsVal, ...]

# CoreDyn


@dataclass
class In_Move:
    target: DynAbsVal
    source: AbsVal

    def __repr__(self):
        return f"{self.target} = {self.source!r}"


@dataclass
class In_Bind:
    target: DynAbsVal
    sub: AbsVal
    attr: AbsVal
    args: _t.Tuple[_t.Optional[AbsVal], ...]

    def __repr__(self):
        args = ["..." if x is None else repr(x) for x in self.args]

        return f"{self.target} = {self.sub!r}.{self.attr}({','.join(args)})"


@dataclass
class In_Goto:
    label: str

    def __repr__(self):
        return f"goto {self.label}"


@dataclass
class In_Cond:
    test: AbsVal
    then: str
    otherwise: str

    def __repr__(self):
        return (
            f"if {self.test!r} then {self.then} else {self.otherwise}"
        )


@dataclass
class In_Return:
    value: AbsVal

    def __repr__(self):
        return f"return {self.value!r}"


In_Stmt = _t.Union[In_Cond, In_Goto, In_Move, In_Return, In_Bind]
In_Blocks = _t.Dict[str, _t.List[In_Stmt]]


def print_in_blocks(b: In_Blocks, print=print):
    for label, xs in sorted(b.items(), key=lambda x: x[0] != "entry"):
        print(label, ":")
        for each in xs:
            print(each)


@dataclass
class In_Def:
    narg: int
    arg_pack: bool
    blocks: In_Blocks
    glob: _t.Dict[str, AbsVal]
    name: str
    start: str

    UserCodeDyn = {}  # type: _t.Dict[str, In_Def]

    def show(self):
        args = [f"D[{i}]" for i in range(self.narg)]
        if self.arg_pack:
            args.append("...")

        print(f'def {self.name}({",".join(args)})', "{")
        print_in_blocks(self.blocks, print=lambda *x: print("", *x))
        print("}")


# DO-IL


@dataclass(unsafe_hash=True)
class Out_Call(Out_IExpr):
    func: Out_Expr
    args: _t.Tuple[Out_Expr, ...]

    def __post_init__(self):
        self.args = tuple(self.args)

    def __repr__(self):
        return f"{self.func}{tuple(self.args)}"


Out_Expr = _t.Union[AbsVal, Out_Call]


@dataclass(frozen=True)
class Out_Assign:
    target: DynAbsVal
    expr: Out_Expr

    def show(self, prefix):
        print(f"{prefix}{self.target} = {self.expr!r}")


@dataclass(unsafe_hash=True)
class Out_Case:
    test: Out_Expr
    cases: _t.Mapping[AbsVal, _t.Tuple[Out_Instr, ...]]

    def __post_init__(self):
        self.cases = pyrsistent.pmap(
            {k: tuple(v) for k, v in self.cases.items()}
        )

    def show(self, prefix):
        print(f"{prefix}case {self.test!r}")
        for t, xs in self.cases.items():
            print(f"{prefix}  {t!r} ->")
            show_many(xs, prefix + "    ")


@dataclass(frozen=True)
class Out_Label:
    label: str

    def show(self, prefix):
        print(f"label {self.label}:")


@dataclass(frozen=True)
class Out_Goto:
    label: str

    def show(self, prefix):
        print(f"{prefix}goto {self.label}:")


@dataclass(frozen=True)
class Out_Return:
    value: Out_Expr

    def show(self, prefix):
        print(f"{prefix}return {self.value!r}")


Out_Instr = _t.Union[
    Out_Label, Out_Case, Out_Assign, Out_Return, Out_Goto
]

CallRecord = _t.Tuple[str, _t.Tuple[AbsVal, ...]]


def show_many(xs: _t.Iterable[Out_Instr], prefix):
    for each in xs:
        each.show(prefix)


@dataclass
class Out_Def:
    args: _t.Tuple[AbsVal, ...]
    rettypes: _t.Tuple[AbsVal, ...]
    instance: _t.Union[object, AbsVal]
    instrs: _t.Tuple[Out_Instr, ...]
    name: str  # unique
    start: str

    GenerateCache = []

    def show(self):
        print(
            "|".join(map(repr, self.rettypes)),
            f"def {self.name}(",
            ", ".join(map(repr, self.args)),
            ")",
            f"-> {self.instance} {{"
            if self.instance is not UNDEF
            else "{",
        )
        print(f"  START from {self.start}")
        for i in self.instrs:
            i.show("  ")
        print("}")


# States

## user function calls recorded here cannot be reanalyzed next time
RecTraces: _t.Set[_t.Tuple[str, _t.Tuple[AbsVal, ...]]] = set()

## specialisations map
## return types not inferred but function address
PreSpecMaps: _t.Dict[CallRecord, str] = {}

## cache return types and function address
SpecMaps: _t.Dict[
    CallRecord, _t.Tuple[_t.Tuple[AbsVal, ...], AbsVal, AbsVal]
] = {}


def prespec_name(key: CallRecord, name=""):
    v = PreSpecMaps.get(key)
    if v is None:
        i = len(PreSpecMaps)
        n = f"{name.replace('_', '__')}_{i}"
        PreSpecMaps[key] = n
        return n
    return v


@dataclass(frozen=True)
class Local:
    mem: pyrsistent.PVector[int]
    store: pyrsistent.PMap[int, AbsVal]

    def up_mem(self, mem):
        return Local(mem, self.store)

    def up_store(self, store):
        return Local(self.mem, store)


# Prims


def alloc(local: Local):
    i = -1
    for i, each in enumerate(local.mem):
        if each == 0:
            return i
    i += 1
    return i


def decref(local: Local, a: AbsVal):
    if not isinstance(a, DynAbsVal):
        return local
    i = a.i
    if i < len(local.mem):
        mem = local.mem
        mem = mem.set(i, max(mem[i] - 1, 0))
        return local.up_mem(mem)
    return local


def incref(local: Local, a: AbsVal):
    if not isinstance(a, DynAbsVal):
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


def judge_lit(local: Local, a: AbsVal):
    if isinstance(a, DynAbsVal):
        return local.store.get(a.i, A_bot)
    return a


def judge_coerce(a, t: StAbsVal):
    if isinstance(a, DynAbsVal):
        a_t = DynAbsVal(a.i, t)
        inst = t.shape().instance(t.ts)
        if inst is not UNDEF:
            return [], inst
        return [Out_Assign(a_t, a)], a_t
    return [], a


def judge_class(a: AbsVal) -> StAbsVal:
    if isinstance(a, Constant):
        return a.t

    if isinstance(a, DynAbsVal):
        return a.t

    if isinstance(a, StAbsVal):
        shape = ShapeSystem[a.o]
        return shape.cls

    if isinstance(a, PrimAbsVal):
        return A_top

    if isinstance(a, literal_runtime_types):
        return literal_runtime_abs_typemap[type(a)]

    if isinstance(a, CAPI):
        return A_top
    raise TypeError(type(a), a)


def judge_resolve(t: _t.Union[StAbsVal, Constant], method: str):
    if isinstance(t, Constant):
        return UNDEF
    shape = ShapeSystem[t.o]
    m = shape.fields.get(method, UNDEF)
    if m is not UNDEF:
        return m
    for base in shape.bases:
        m = judge_resolve(base, method)
        if m is not UNDEF:
            return m
    return UNDEF


def blocks_to_instrs(
    blocks: _t.Dict[str, _t.List[Out_Instr]], start: str
):
    merge_blocks = defaultdict(OrderedDict)
    for label, block in sorted(
        blocks.items(), key=lambda pair: pair[0] != start
    ):
        block = tuple(block)
        labels = merge_blocks[block]
        labels[label] = None
    instrs = []

    for block, labels in merge_blocks.items():
        for label in labels:
            instrs.append(Out_Label(label))
        instrs.extend(block)
    return instrs


# Core


class Judge:
    def __init__(
        self, blocks: In_Blocks, unpack: _t.List[AbsVal], glob
    ):
        # States
        self.in_blocks = blocks
        self.block_map: _t.Dict[_t.Tuple[str, Local], str] = {}
        self.returns: _t.Set[AbsVal] = set()
        self.unpack: _t.List[AbsVal] = unpack
        self.code: _t.List[Out_Instr] = []
        self.out_blocks: _t.Dict[str, _t.List[Out_Instr]] = {}
        self.glob: _t.Dict[str, AbsVal] = glob

        self.label_cnt = 0

    @contextmanager
    def use_code(self, code: _t.List[Out_Instr]):
        old_code = self.code
        self.code = code
        try:
            yield
        finally:
            self.code = old_code

    def gen_label(self, kind=""):
        self.label_cnt += 1
        return f"{kind}_{self.label_cnt}"

    def codegen(self, *args):
        self.code.extend(args)

    def stmt(self, local: Local, xs: _t.Sequence[In_Stmt], index: int):
        try:
            hd = xs[index]
        except StopIteration:
            raise Exception("non-terminaor terminate")
        if isinstance(hd, In_Move):
            a_x = judge_lit(local, hd.target)
            a_y = judge_lit(local, hd.source)
            local = decref(local, a_x)
            local = incref(local, a_y)
            local = local.up_store(local.store.set(hd.target.i, a_y))
            self.stmt(local, xs, index + 1)
        elif isinstance(hd, In_Goto):
            label_gen = self.jump(local, hd.label)
            self.codegen(Out_Goto(label_gen))
        elif isinstance(hd, In_Return):
            a = judge_lit(local, hd.value)
            self.returns.add(a)
            self.codegen(Out_Return(a))
        elif isinstance(hd, In_Cond):
            a = judge_lit(local, hd.test)
            if judge_class(a) == A_bool:
                a_cond = a
            else:
                instance, e_call, unions = spec(
                    self, A_bool, "__call__", tuple([a])
                )
                if not isinstance(e_call, (Out_Call, DynAbsVal)):
                    a_cond = e_call
                else:
                    j = alloc(local)
                    a_cond = DynAbsVal(j, A_bool)
                    self.codegen(Out_Assign(a_cond, e_call))
                a_cond = instance if instance is not UNDEF else a_cond

            if isinstance(a_cond, bool):
                label = hd.then if a_cond else hd.otherwise
                label_gen = self.jump(local, label)
                self.codegen(Out_Goto(label_gen))
                return

            l1 = self.jump(local, hd.then)
            l2 = self.jump(local, hd.otherwise)
            self.codegen(
                Out_Case(
                    a_cond,
                    {True: [Out_Goto(l1)], False: [Out_Goto(l2)]},
                )
            )
        elif isinstance(hd, In_Bind):
            a_x = judge_lit(local, hd.target)
            a_subj = judge_lit(local, hd.sub)
            attr = judge_lit(local, hd.attr)
            assert isinstance(
                attr, str
            ), f"attr {attr} shall be a string"
            a_args = []
            for arg in hd.args:
                if arg is UNDEF:
                    a_args.extend(self.unpack)
                else:
                    a_args.append(judge_lit(local, arg))
            local = decref(local, a_x)
            a_args = tuple(a_args)
            instance, e_call, unions = spec(self, a_subj, attr, a_args)
            if not isinstance(e_call, (Out_Call, DynAbsVal)):
                e_call = instance if instance is not UNDEF else e_call
                local = incref(local, e_call)
                local = local.up_store(
                    local.store.set(hd.target.i, e_call)
                )
                self.stmt(local, xs, index + 1)
            else:
                j = alloc(local)
                a_u = DynAbsVal(
                    j, unions[0] if len(unions) == 1 else A_top
                )
                self.codegen(Out_Assign(a_u, e_call))
                split = [judge_coerce(a_u, t) for t in unions]

                (code, a), *union_classed = split
                if not union_classed:
                    if instance is not UNDEF:
                        a = instance
                    local = incref(local, a)
                    self.codegen(*code)
                    local = local.up_store(
                        local.store.set(hd.target.i, a)
                    )
                    self.stmt(local, xs, index + 1)
                else:
                    cases: _t.List[
                        _t.Tuple[AbsVal, _t.List[Out_Instr]]
                    ] = []
                    for (code, a), t in zip(split, unions):
                        cases.append((t, code))
                        local_i = incref(local, a)
                        local_i = local_i.up_store(
                            local_i.store.set(hd.target.i, a)
                        )
                        with self.use_code(code):
                            self.stmt(local_i, xs, index + 1)
                    self.codegen(
                        Out_Case(Out_Call(A_class, [a_u]), dict(cases))
                    )
        return

    def jump(self, local: Local, label: str) -> str:
        key = (label, local)
        gen_label = self.block_map.get(key)
        if gen_label:
            return gen_label
        gen_label = self.gen_label()
        self.block_map[key] = gen_label
        code = []
        with self.use_code(code):
            self.stmt(local, self.in_blocks[label], 0)
        self.out_blocks[gen_label] = code
        return gen_label


def _check(f):
    _valid_types = (
        *literal_runtime_types,
        CAPI,
        DynAbsVal,
        Constant,
        StAbsVal,
        PrimAbsVal,
        Out_Call,
    )

    def call(self, a, attr, args):
        # print(f"|specialising {a!r}.{attr}{args!r}")
        inst, a, ts = f(self, a, attr, args)

        assert isinstance(a, _valid_types)
        assert isinstance(ts, tuple)
        return inst, a, ts

    return call


@_check
def spec(
    self: Judge,
    a_subj: AbsVal,
    attr: str,
    a_args: _t.Tuple[AbsVal, ...],
) -> _t.Tuple[
    _t.Union[object, AbsVal], Out_Expr, _t.Tuple[AbsVal, ...]
]:

    if attr == "__call__":
        default_call = PrimAbsVal.CallU(a_subj, *a_args)
        default = UNDEF, default_call, (A_top,)
    else:
        default_call = A_callmethod(a_subj, attr, *a_args)
        default = UNDEF, default_call, (A_top,)

    c_a_subj = judge_class(a_subj)
    if c_a_subj == A_bot or a_subj == A_bot:
        return UNDEF, A_bot, (A_bot,)

    if isinstance(a_subj, PrimAbsVal) and attr == "__call__":
        if a_subj is PrimAbsVal.CreateTuple:
            a_ts = tuple(map(judge_class, a_args))
            a_t = StAbsVal(Name_TUPLE, a_ts)
            e = PrimAbsVal.CallC(a_t, CAPIs.CreateTuple, *a_args)
            return UNDEF, e, (a_t,)
        elif a_subj is PrimAbsVal.GetTypeField:
            if len(a_args) != 2 or not isinstance(a_args[1], int):
                raise TypeError(
                    f"({a_subj}{a_args}) requires exact 2 arguments and"
                    f"the 2nd argument should be an integer"
                )
            a_t, i = a_args[0], a_args[1]
            if isinstance(a_t, StAbsVal):
                if i < len(a_t.ts):
                    a_ret: AbsVal = a_t.ts[i]
                    return UNDEF, a_ret, (judge_class(a_ret),)
                else:
                    return UNDEF, A_bot, (A_bot,)
            return UNDEF, A_top, (A_top,)
        elif a_subj is PrimAbsVal.CallC:
            # ccall(t, "cfuncname", arg1, arg2)
            if len(a_args) < 2:
                raise TypeError(
                    f"({a_subj}{a_args}) C call should"
                    f"take more than 2 arguments! "
                )
            if not isinstance(a_args[0], StAbsVal):
                raise TypeError(
                    f"({a_subj}{a_args}) C call's 1st argument "
                    f"should be a class!"
                )
            capi = a_args[1]
            if isinstance(capi, str):
                capi = CAPI(capi)
            if not isinstance(capi, CAPI):
                raise TypeError(
                    f"({a_subj}{a_args}) C call's 2nd argument "
                    f"should be a literal string!"
                )
            a_t = a_args[0]
            return (
                UNDEF,
                PrimAbsVal.CallC(a_t, capi, *a_args[2:]),
                (a_t,),
            )
        elif a_subj is PrimAbsVal.IsStatic:
            # TODO: error msg
            assert len(a_args) == 1
            e = not isinstance(a_args[0], DynAbsVal)
            return UNDEF, e, (A_bool,)
        elif a_subj is PrimAbsVal.CallS:
            # TODO: error msg
            assert len(a_args) >= 2
            assert all(not isinstance(a, DynAbsVal) for a in a_args)
            f, *args = map(to_runtime, a_args)
            a = from_runtime(f(*args))
            a_t = judge_class(a)
            return UNDEF, a, (a_t,)

        elif a_subj is PrimAbsVal.CallU:
            if not a_args:
                raise TypeError(
                    f"({a_subj}{a_args}) user call should"
                    f"take more than 1 arguments!"
                )
            # for PyCharm infer
            u_a_func, arguments = a_args[0], a_args[1:]
            if (
                isinstance(u_a_func, StAbsVal)
                and u_a_func.o == Name_FUN
            ):
                func_id = u_a_func.ts[0]
                if len(u_a_func.ts) != 1 or not isinstance(
                    func_id, str
                ):
                    raise TypeError(
                        f"({u_a_func}) user function can have only 1 **str** parameter."
                    )
                in_def = In_Def.UserCodeDyn[func_id]
                if in_def.arg_pack:
                    assert in_def.narg <= len(arguments), (
                        f"({u_a_func}{arguments}) calling this vararg"
                        f"function requires more than {in_def.narg} arguments."
                    )
                else:
                    assert in_def.narg == len(arguments), (
                        f"({u_a_func}{arguments}) calling this no-vararg"
                        f"function requires exact {in_def.narg} arguments"
                    )

                parameters = []
                mem = []

                for a_arg in arguments:
                    if isinstance(a_arg, DynAbsVal):
                        i = len(mem)
                        mem.append(1)
                        parameters.append(DynAbsVal(i, a_arg.t))
                    else:
                        parameters.append(a_arg)

                parameters = tuple(parameters)

                call_record = func_id, parameters
                if call_record in SpecMaps:  # spec
                    rettypes, instance, jit_a_func = SpecMaps[
                        call_record
                    ]
                    e = jit_a_func(*arguments)
                elif (
                    call_record in PreSpecMaps
                ):  # prespec, handling recursions
                    jit_func_id = prespec_name(call_record)
                    jit_a_func = StAbsVal(Name_JIT, (jit_func_id,))

                    e = jit_a_func(*arguments)
                    rettypes = (A_top,)
                    instance = UNDEF
                else:
                    name = prespec_name(call_record, name=in_def.name)

                    sub_judge = Judge(
                        blocks=in_def.blocks,
                        unpack=list(parameters[in_def.narg :]),
                        glob=in_def.glob,
                    )
                    local = Local(
                        pyrsistent.pvector(mem),
                        pyrsistent.pmap(
                            dict(
                                zip(
                                    range(in_def.narg),
                                    parameters[: in_def.narg],
                                )
                            )
                        ),
                    )
                    gen_start = sub_judge.jump(local, in_def.start)
                    instrs = blocks_to_instrs(
                        sub_judge.out_blocks, gen_start
                    )

                    rettypes = tuple(
                        {judge_class(r) for r in sub_judge.returns}
                    )
                    instance, *__ = sub_judge.returns
                    instance = instance if not __ else UNDEF
                    if isinstance(instance, DynAbsVal):
                        instance = UNDEF

                    out_def = Out_Def(
                        parameters,
                        rettypes,
                        instance,
                        tuple(instrs),
                        name,
                        gen_start,
                    )
                    Out_Def.GenerateCache.append(out_def)
                    jit_a_func = StAbsVal(Name_JIT, (name,))
                    SpecMaps[call_record] = (
                        rettypes,
                        instance,
                        jit_a_func,
                    )
                    e = jit_a_func(*arguments)

                return instance, e, rettypes
            else:
                return default
        elif a_subj is PrimAbsVal.GetField:

            if len(a_args) != 2:
                return default
            if not isinstance(a_args[1], str):
                return default
            if not isinstance(a_args[0], StAbsVal):
                return default
            if judge_class(a_args[0]) == A_moduletype:
                a_module = a_args[0]
                o = a_module.shape().to_py(a_module.ts)
                attribute = getattr(o, a_args[1], UNDEF)
                if attribute is UNDEF:
                    return default
                a_attr = from_runtime(attribute)
                if isinstance(a_attr, DynAbsVal):
                    return default
                return UNDEF, a_attr, (judge_class(a_attr),)
            method = judge_resolve(a_args[0], a_args[1])
            if method is UNDEF:
                # TODO
                raise TypeError
            return UNDEF, method, (judge_class(method),)
        elif a_subj is PrimAbsVal.AnyPack:
            return UNDEF, any(self.unpack), (A_bool,)
        elif a_subj is PrimAbsVal.IsInstance:
            if len(a_args) != 2:
                raise TypeError(
                    f"{a_subj}{a_args} requires extract 2 argument."
                )
            a1, a2 = a_args[0], a_args[1]
            if judge_class(a1) == A_top or judge_class(a2) == A_top:
                return UNDEF, default_call, (A_bool,)
            if not isinstance(a2, StAbsVal):
                # TODO
                raise TypeError(
                    f"({a_subj}{a_args}) second argument shall be a class."
                )
            a_t = judge_class(a1)
            return (
                UNDEF,
                (a2 == a_t or a2 in a_t.shape().bases),
                (A_bool,),
            )
        elif a_subj is PrimAbsVal.ElimTypeVars:
            assert len(a_args) == 1
            a = a_args[0]
            if isinstance(a, StAbsVal):
                a = StAbsVal(a.o, ())
            return UNDEF, a, (judge_class(a),)

        elif a_subj is PrimAbsVal.GetClass:
            if len(a_args) != 1:
                raise TypeError(
                    f"{a_subj}{a_args} requires extract 1 argument."
                )
            a_t = judge_class(a_args[0])
            if a_t == A_top:
                return default
            return UNDEF, a_t, (judge_class(a_t),)
        elif a_subj is PrimAbsVal.GetGlobal:
            if len(a_args) != 1 or not isinstance(a_args[0], str):
                raise TypeError(
                    f"({a_subj}{a_args}) should take only 1 str argument."
                )
            n = a_args[0]
            if n in self.glob:
                a_ret = self.glob[n]
                return UNDEF, a_ret, (judge_class(a_ret),)
            return default
        elif a_subj is PrimAbsVal.Coerce:
            # TODO: msg
            assert len(a_args) >= 2 and all(
                isinstance(a, StAbsVal) for a in a_args[:-1]
            ), "invalid coerce"
            a_ts = a_args[:-1]
            return UNDEF, default_call, a_ts
        elif a_subj is PrimAbsVal.Not:
            assert len(a_args) == 1, "invalid 'not' check"
            a = a_args[0]
            if isinstance(a, (str, int, float, bool)):
                test = not a
                return UNDEF, test, (A_bool,)
            return (
                UNDEF,
                PrimAbsVal.CallC(A_bool, CAPIs.Not, a),
                (A_bool,),
            )

        elif a_subj is PrimAbsVal.Is:
            # TODO: err msg
            assert len(a_args) == 2, f"(is{a_args}) invalid 'is' check"
            a1, a2 = a_args[0], a_args[1]
            if isinstance(a1, DynAbsVal) or isinstance(a2, DynAbsVal):
                a_t1, a_t2 = judge_class(a1), judge_class(a2)
                if a_t1 != A_top and a_t2 != A_top:
                    if a_t1 != a_t2:
                        return UNDEF, False, (A_bool,)
                e = PrimAbsVal.CallC(A_bool, CAPIs.Is, a1, a2)
                return UNDEF, e, (A_bool,)
            else:
                test = a1 == a2
                return UNDEF, test, (A_bool,)
    elif c_a_subj == A_class:
        if isinstance(a_subj, (DynAbsVal, Constant)):
            return default
        method = judge_resolve(judge_class(a_subj), attr)
        if method is UNDEF:
            return default
        return spec(self, method, "__call__", (a_subj, *a_args))
    elif c_a_subj == A_top:
        if isinstance(a_subj, (DynAbsVal, Constant)):
            return default
        method = judge_resolve(a_subj, attr)
        if method is UNDEF:
            return default
        return spec(self, method, "__call__", a_args)
    elif c_a_subj == A_moduletype:
        a_module = a_subj
        o = a_module.shape().to_py(a_module.ts)
        attribute = getattr(o, attr, UNDEF)
        if attribute is UNDEF:
            return default
        a_attr = from_runtime(attribute)
        if isinstance(a_attr, DynAbsVal):
            return default
        return spec(self, a_attr, "__call__", a_args)
    else:
        a_class = judge_class(a_subj)
        method = judge_resolve(a_class, attr)
        if method is UNDEF:
            return default
        spec_a_args = a_subj, *a_args
        return spec(self, method, "__call__", spec_a_args)


# Setup

CompiledFunctions = {}
UserFunctions = {}


Name_TOP = "top"
A_top = StAbsVal(Name_TOP)
_shape_top = ShapeSystem[Name_TOP] = Shape(
    Name_TOP, 0, [], {}, lambda _: 1 / 0
)
_shape_top.cls = A_top


def register_simple(t: object, a_cls: AbsVal):
    hash(t)
    a = StAbsVal(t)
    ShapeSystem[t] = Shape(t, a_cls, [], {}, lambda _: t)
    STATIC_VALUE_MAPS[t] = a
    return a


Name_TYPE = type
A_class = register_simple(Name_TYPE, A_top)
A_class.shape().cls = A_class


def register_simple_type(t: type):
    return register_simple(t, A_class)


Name_BOOL = bool
A_bool = register_simple_type(Name_BOOL)
Name_INT = int
A_int = register_simple_type(Name_INT)
Name_FLOAT = float
A_float = register_simple_type(Name_FLOAT)
Name_STR = str
A_str = register_simple_type(Name_STR)
Name_TUPLE = tuple
A_tuple = register_simple_type(Name_TUPLE)
Name_LIST = list
A_list = register_simple_type(Name_LIST)
Name_DICT = dict
A_dict = register_simple_type(Name_DICT)

A_notimpltype = register_simple_type(type(NotImplemented))
A_notimpl = register_simple(NotImplemented, A_notimpltype)
A_notimpltype.shape().instance = lambda _: A_notimpl

Name_FUNTYPE = type(register_simple_type)
A_functype = register_simple_type(Name_FUNTYPE)


Name_NONETYPE = "NoneType"
A_nonetype = StAbsVal(Name_NONETYPE)
ShapeSystem[Name_NONETYPE] = Shape(
    Name_NONETYPE, A_class, [], {}, lambda _: type(None), lambda _: None
)
STATIC_VALUE_MAPS[type(None)] = A_nonetype

Name_BOT = "bot"
A_bot = StAbsVal(Name_BOT)
_shape_bot = ShapeSystem[Name_BOT] = Shape(
    Name_BOT, 0, [], {}, lambda _: 1 / 0
)
_shape_bot.cls = A_bot

A_setattr = register_simple(setattr, a_cls=A_top)
A_getattr = register_simple(getattr, a_cls=A_top)
A_callmethod = CAPI("call_method")

A_moduletype = register_simple_type(_types.ModuleType)

Name_MOD = "module"
ShapeSystem[Name_MOD] = Shape(
    Name_MOD, A_moduletype, [], {}, lambda xs: sys.modules[xs[0]]
)

Name_FUN = "func"
ShapeSystem[Name_FUN] = Shape(
    Name_FUN, A_functype, [], {}, lambda xs: UserFunctions[xs[0]]
)
Name_JIT = "jitfunc"
ShapeSystem[Name_JIT] = Shape(
    Name_FUN, A_top, [], {}, lambda xs: CompiledFunctions[xs[0]]
)

_shape_funtype = ShapeSystem[Name_FUNTYPE]
_shape_funtype.fields["__call__"] = PrimAbsVal.CallU
literal_runtime_abs_typemap = {
    int: A_int,
    type(None): A_nonetype,
    float: A_float,
    bool: A_bool,
    str: A_str,
    complex: A_top,  # TODO
}

STATIC_VALUE_MAPS.update(
    {
        isinstance: PrimAbsVal.IsInstance,
    }
)
primitive_abs_typemap = {PrimAbsVal.IsInstance: isinstance}

import operator


class Bin:
    add = register_simple(operator.add, A_top)
    sub = register_simple(operator.sub, A_top)
    or_ = register_simple(operator.or_, A_top)
    floordiv = register_simple(operator.floordiv, A_top)
    truediv = register_simple(operator.truediv, A_top)
    mul = register_simple(operator.mul, A_top)
    getitem = register_simple(operator.getitem, A_top)
    lt = register_simple(operator.lt, A_top)
    gt = register_simple(operator.gt, A_top)
    le = register_simple(operator.le, A_top)
    ge = register_simple(operator.ge, A_top)
    eq = register_simple(operator.eq, A_top)
    ne = register_simple(operator.ne, A_top)
    modulo = register_simple(operator.mod, A_top)
