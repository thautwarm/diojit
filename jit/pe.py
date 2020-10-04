from jit import CoreCPY, types, dynjit, stack, prims, intrinsics
from jit.call_prims import (
    dispatch,
    setup_primitives,
    NO_SPECIALIZATION,
)
from typing import List, Optional, Sequence, Dict, Union
from dataclasses import dataclass, field
import types as pytypes
import dis
import itertools


@dataclass
class Specialised:
    return_type: types.T
    method: dynjit.AbstractValue


def codegen(f, dynjit_ir):
    setattr(f, "__jit__", dynjit_ir)
    return f


def calc_initial_stack_size(codeobj):
    return len(codeobj.co_varnames) + len(codeobj.co_cellvars)


@dataclass
class Assumptions:
    static_members: Dict[str, types.T]
    members: Dict[str, types.T]


class Compiler:
    def __init__(self, registered_primitives=None):
        setup_primitives()
        self.methods = {}
        self.spec_stack = set()
        self.corecpy = {}
        self.awared = set()

    @staticmethod
    def assume(pytype: type):
        def ap(func):
            nom_t: types.NomT = types.noms.get(pytype)
            if nom_t is None:
                members = {}
                static_members = {}
                nom_t = types.NomT(pytype, members, static_members)
                types.noms[pytype] = nom_t
            return func(nom_t)

        return ap

    def aware(self, o):
        # noinspection PyTypeChecker
        if isinstance(o, pytypes.FunctionType):
            self.awared.add(o)
        else:
            raise TypeError(type(o))
        return o

    def specialise(
        self, func: pytypes.FunctionType, *arg_types
    ) -> Optional[Specialised]:
        # NOTE: 'arg_types[0]' is a tuple of free variables
        # use of func_obj:
        # 1. as key for caching
        # 2. inspect reference of global variables
        # 3. get runtime closure object
        if func not in self.awared:
            return
        key = (func, arg_types)
        if key in self.spec_stack:
            return None
        m = self.methods.get(key)
        if m is not None:
            return m
        self.spec_stack.add(key)
        (I) = self.corecpy.get(func)
        if I is None:
            bytecode = dis.Bytecode(func.__code__)
            (I) = list(CoreCPY.from_pyc(bytecode))
            self.corecpy[func] = I

        uninitialized_count = calc_initial_stack_size(
            func.__code__
        ) - len(arg_types)
        (S) = [
            dynjit.AbstractValue(dynjit.D(i + 1), a)
            for i, a in enumerate(
                itertools.chain(
                    arg_types,
                    itertools.repeat(
                        types.BottomT(), uninitialized_count
                    ),
                )
            )
        ][::-1]
        # so for no closure, so make it None
        S.append(dynjit.AbstractValue(dynjit.S(None), types.none_t))
        (S) = stack.construct(S)
        glob: dict = func.__globals__
        import builtins
        from collections import ChainMap

        _glob = ChainMap(builtins.__dict__, glob)
        glob_type = prims.ct(_glob)
        glob_abs_val = dynjit.AbstractValue(dynjit.S(glob), glob_type)
        pe = PE(glob_abs_val, self, I)
        dynjit_code = list(pe.infer(S, 0))
        return_types = pe.return_types
        if not return_types:
            raise ValueError(func)
        elif len(return_types) == 1:
            ret_t = return_types[0]
        else:
            ret_t = types.UnionT(set(return_types))

        # TODO
        method_obj = codegen(func, dynjit_code)

        abs_val_m = dynjit.AbstractValue(
            dynjit.S(method_obj),
            types.FPtrT(method_obj),
        )
        m = Specialised(ret_t, abs_val_m)
        self.methods[key] = m
        return m


def gensym(n: List[int]):
    r = n[0]
    n[0] += 1
    return r


@dataclass
class PE:
    glob_val: dynjit.AbstractValue
    compiler: Compiler
    corecpy_suite: Sequence[CoreCPY.Instr]
    block_cache: dict = field(default_factory=dict)
    found_cache: dict = field(default_factory=dict)
    counter_lbl: List[int] = field(default_factory=lambda: [0])
    counter_sym: List[int] = field(default_factory=lambda: [0])
    return_types: List[types.T] = field(default_factory=list)

    def infer(self, s, p):
        I = self.corecpy_suite
        G = self.block_cache
        instr = I[p]
        if isinstance(instr, CoreCPY.Label):
            lbl = G.get((s, p))
            if not lbl:
                lbl = gensym(self.counter_lbl)
                G[(s, p)] = lbl
                yield dynjit.Label(lbl)
                yield from self.infer(s, p + 1)
            else:
                yield dynjit.Goto(lbl)
            return

        pair = stack.decons_opt(s)
        if pair:
            abs_val: dynjit.AbstractValue = s[0]
            s_ = s[1]
            t_tos = abs_val.type
            if t_tos is types.bool_t and isinstance(
                abs_val.repr, dynjit.D
            ):
                s = s_
                h1 = dynjit.AbstractValue(dynjit.S(True), types.bool_t)
                h2 = dynjit.AbstractValue(dynjit.S(False), types.bool_t)
                s1 = stack.cons(h1, s)
                s2 = stack.cons(h2, s)
                arm1 = list(self.infer(s1, p))
                arm2 = list(self.infer(s2, p))
                dynjit.If(abs_val, arm1, arm2)
                return
            if isinstance(t_tos, types.UnionT):
                s = s_
                assert t_tos.alts
                *init, end_t = t_tos.alts
                untyped_abs_val = abs_val

                abs_val_spec = dynjit.AbstractValue(abs_val.repr, end_t)
                last = list(self.infer(stack.cons(abs_val_spec, s), p))
                for end_t in init:
                    abs_val_spec = dynjit.AbstractValue(
                        abs_val.repr, end_t
                    )
                    s_spec = stack.cons(abs_val_spec, s)
                    last = [
                        dynjit.TypeCheck(
                            untyped_abs_val,
                            end_t,
                            list(self.infer(s_spec, p)),
                            last,
                        )
                    ]

                yield from last
                return
        if isinstance(instr, CoreCPY.Pop):
            a, s_new = s
            yield from self.infer(s_new, p + 1)
            return
        if isinstance(instr, CoreCPY.Peek):
            s_new = stack.cons(stack.peek(s, instr.n), s)
            yield from self.infer(s_new, p + 1)
            return
        if isinstance(instr, CoreCPY.Load):
            assert isinstance(instr.sym, int)
            a: dynjit.AbstractValue = stack.index_rev(s, instr.sym)
            if isinstance(a.repr, dynjit.S):
                s_new = stack.cons(a, s)
            else:
                target = stack.size(s)
                a_dyn = dynjit.AbstractValue(dynjit.D(target), a.type)
                yield dynjit.Assign(a_dyn, a)
                s_new = stack.cons(a_dyn, s)
            yield from self.infer(s_new, p + 1)
            return

        if isinstance(instr, CoreCPY.Constant):
            ct = prims.ct(instr.c)
            a = dynjit.AbstractValue(dynjit.S(instr.c), ct)
            s_new = stack.cons(a, s)
            yield from self.infer(s_new, p + 1)
            return

        if isinstance(instr, CoreCPY.Rot):
            s_new = stack.rotate_stack(s, instr.narg)
            yield from self.infer(s_new, p + 1)
            return

        if isinstance(instr, CoreCPY.Store):
            assert isinstance(instr.sym, int)
            a, s = stack.pop(s)
            if isinstance(a, dynjit.S):
                s_new = stack.store_rev(s, instr.sym, a)
            else:
                a_dyn = dynjit.AbstractValue(
                    dynjit.D(instr.sym), a.type
                )
                s_new = stack.store_rev(s, instr.sym, a_dyn)
                yield dynjit.Assign(a_dyn, a)
            yield from self.infer(s_new, p + 1)
            return

        if isinstance(instr, CoreCPY.Call):
            v_args: List[dynjit.AbstractValue] = []
            for _ in range(instr.narg):
                v, s = stack.pop(s)
                v_args.append(v)
            v_args.reverse()
            f, s = stack.pop(s)
            f: dynjit.AbstractValue = f

            return (yield from self.call_desugar(f, v_args, s, p))

        if isinstance(instr, CoreCPY.Jump):
            yield from self.infer(s, self.find_p(instr.lbl))
            return

        if isinstance(instr, CoreCPY.JumpIf):
            expect = dynjit.AbstractValue(
                dynjit.S(instr.expect), types.bool_t
            )
            a, s_new = s
            if a.type is not types.bool_t:
                cond = dynjit.Call(
                    prims.v_beq,
                    [dynjit.Call(prims.v_asbool, [a]), expect],
                )
            else:
                cond = dynjit.Call(prims.v_beq, [a, expect])
            if instr.keep:
                arm1 = list(self.infer(s, self.find_p(instr.lbl)))
            else:
                arm1 = list(self.infer(s_new, self.find_p(instr.lbl)))
            arm2 = list(self.infer(s_new, p + 1))
            yield dynjit.If(cond, arm1, arm2)
            return
        if isinstance(instr, CoreCPY.Return):
            # insert upcast when it is union
            a, _ = stack.pop(s)
            if a.type not in self.return_types:
                self.return_types.append(a.type)
            yield dynjit.Return(a)
            return

    def call_desugar(self, f, v_args, s, p):
        def iterate_desugar(
            f: Union[dynjit.AbstractValue, dynjit.Call],
            v_args: List[Union[dynjit.Call, dynjit.AbstractValue]],
        ):
            t_f = f.type
            if isinstance(t_f, types.PrimT):
                f_repr = t_f.o
                is_no_specialization = yield from self.call_prim(
                    f_repr, v_args, s, p
                )
                if not is_no_specialization:
                    return

            if isinstance(t_f, types.TypeT):
                # noinspection PyUnresolvedReferences
                # TODO
                ret_t = t_f.type
                n = stack.size(s)
                a_dyn = dynjit.AbstractValue(dynjit.D(n), ret_t)
                s_new = stack.cons(a_dyn, s)
                yield dynjit.Assign(
                    a_dyn, dynjit.Call(prims.v_py_call, [f, *v_args])
                )
                yield from self.infer(s_new, p + 1)
                return

            if (
                isinstance(t_f, types.NomT)
                and "__call__" in t_f.members
            ):
                v_args = [f, *v_args]
                f: dynjit.Expr = t_f.members["__call__"]
                return (yield from iterate_desugar(f, v_args))

            if isinstance(t_f, types.MethT):
                expr_self = dynjit.Call(
                    prims.v_getattr, [f, "__self__"], type=t_f.self
                )
                f: dynjit.Call = dynjit.Call(
                    prims.v_getattr, [f, "__func__"], type=t_f.func
                )
                v_args = [expr_self, *v_args]
                return (yield from iterate_desugar(f, v_args))
            if isinstance(t_f, types.ClosureT):
                expr_self = dynjit.Call(
                    prims.v_getattr, [f, "cell"], type=t_f.cell
                )
                f: dynjit.Call = dynjit.Call(
                    prims.v_getattr, [f, "func"], type=t_f.func
                )
                v_args = [expr_self, *v_args]
                return (yield from iterate_desugar(f, v_args))

            n = stack.size(s)
            if isinstance(t_f, types.FPtrT):
                specialised = self.compiler.specialise(
                    t_f.func,
                    *[v.type for v in v_args],
                )
                if specialised:
                    spec_method = specialised.method
                    expr = dynjit.Call(spec_method, v_args)
                    a_dyn = dynjit.AbstractValue(
                        dynjit.D(n), specialised.return_type
                    )
                    s_new = stack.cons(a_dyn, s)
                    yield dynjit.Assign(a_dyn, expr)
                    yield from self.infer(s_new, p + 1)
                    return

            ret_t = types.TopT()
            a_dyn = dynjit.AbstractValue(dynjit.D(n), ret_t)
            s_new = stack.cons(a_dyn, s)
            yield dynjit.Assign(
                a_dyn, dynjit.Call(prims.v_py_call, [f, *v_args])
            )
            yield from self.infer(s_new, p + 1)
            return

        return (yield from iterate_desugar(f, v_args))

    def call_prim(self, prim_func, args, s, p):
        if prim_func is intrinsics.i_globals and len(args) == 0:
            s = stack.cons(self.glob_val, s)
            ret = yield from self.infer(s, p + 1)
        elif spec := dispatch(prim_func, len(args)):
            ret = yield from spec(self, args, s, p)
        else:
            ret = NO_SPECIALIZATION

        return ret

    def find_p(self, lbl):
        found_cache = self.found_cache
        p = found_cache.get(lbl)
        if p is None:
            for i, instr in enumerate(self.corecpy_suite):
                if (
                    isinstance(instr, CoreCPY.Label)
                    and instr.lbl == lbl
                ):
                    p = found_cache[lbl] = i
                    break
        assert p is not None
        return p
