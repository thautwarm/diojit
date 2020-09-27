from jit import CoreCPY, types, dynjit, stack, prims
from jit.call_prims import padd, pinst, NO_SPECIALIZATION
from typing import List, Optional
from dataclasses import dataclass
import dis


@dataclass
class Specialised:
    return_type: types.T
    method: dynjit.AbstractValue


def codegen(f, dynjit_ir):
    ff = lambda *args: f(*args)
    ff.__jit__ = dynjit_ir
    return ff


class Compiler:

    def __init__(self):
        self.methods = {}
        self.spec_stack = set()
        self.corecpy = {}

    def specialise(self, func_obj, *arg_types) -> Optional[Specialised]:
        key = (func_obj, arg_types)
        if key in self.spec_stack:
            return None
        m = self.methods.get(key)
        if m is not None:
            return m
        self.spec_stack.add(key)
        (G) = {}
        (I) = self.corecpy.get(func_obj)
        if I is None:
            (I) = list(CoreCPY.from_pyc(dis.Bytecode(func_obj)))
            self.corecpy[func_obj] = I

        (S) = stack.construct([dynjit.AbstractValue(dynjit.D(i), a) for i, a in enumerate(arg_types)][::-1])
        return_types, code = self.partial_evaluate(G, I, S)
        if len(return_types) == 1:
            ret_t = return_types[0]
        else:
            ret_t = types.UnionT(return_types)

        method_obj = codegen(func_obj, code)
        abs_val_m = dynjit.AbstractValue(dynjit.S(method_obj), types.ClosureT(arg_types[0], method_obj))
        m = Specialised(ret_t, abs_val_m)
        self.methods[key] = m
        return m

    def partial_evaluate(self, G, I, S):
        def gensym(n):
            r = n[0]
            n[0] += 1
            return r

        counter_lbl = [0]
        return_types = []

        found_cache = {}

        def find_p(lbl):
            p = found_cache.get(lbl)
            if p is None:
                for i, instr in enumerate(I):
                    if isinstance(instr, CoreCPY.Label) and instr.lbl == lbl:
                        p = found_cache[lbl] = i
                        break
            assert p is not None
            return p

        def infer(s, p):
            nonlocal G
            instr = I[p]
            if isinstance(instr, CoreCPY.Label):
                lbl = G.get((s, p))
                if not lbl:
                    lbl = gensym(counter_lbl)
                    G[(s, p)] = lbl
                    yield dynjit.Label(lbl)
                    yield from infer(s, p + 1)
                else:
                    yield stack.single(dynjit.Goto(lbl))
                return

            pair = stack.decons_opt(s)
            if pair:
                abs_val: dynjit.AbstractValue = s[0]
                s_ = s[1]
                t_tos = abs_val.type
                if t_tos is types.bool_t and isinstance(abs_val.repr, dynjit.D):
                    s = s_
                    h1 = dynjit.AbstractValue(dynjit.S(True), types.bool_t)
                    h2 = dynjit.AbstractValue(dynjit.S(False), types.bool_t)
                    s1 = stack.cons(h1, s)
                    s2 = stack.cons(h2, s)
                    arm1 = list(infer(s1, p))
                    arm2 = list(infer(s2, p))
                    dynjit.If(abs_val, arm1, arm2)
                    return
                if isinstance(t_tos, types.UnionT):
                    s = s_
                    assert t_tos.alts
                    *init, end_t = t_tos.alts
                    untyped_abs_val = dynjit.AbstractValue(abs_val.repr, types.TopT())

                    abs_val_spec = dynjit.AbstractValue(abs_val.repr, end_t)
                    last = list(infer(stack.cons(abs_val_spec, s), p))
                    for end_t in init:
                        abs_val_spec = dynjit.AbstractValue(abs_val.repr, end_t)
                        s_spec = stack.cons(abs_val_spec, s)
                        last = [dynjit.TypeCheck(untyped_abs_val, end_t, list(infer(s_spec, p)), last)]

                    yield from last
                    return
            if isinstance(instr, CoreCPY.Pop):
                a, s_new = s
                yield from infer(s_new, p + 1)
                return
            if isinstance(instr, CoreCPY.Peek):
                s_new = stack.cons(stack.peek(s, instr.n), s)
                yield from infer(s_new, p + 1)
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
                yield from infer(s_new, p + 1)
                return
            if isinstance(instr, CoreCPY.Constant):
                ct = prims.ct(instr.c)
                a = dynjit.AbstractValue(dynjit.S(instr.c), ct)
                s_new = stack.cons(a, s)
                yield from infer(s_new, p + 1)
                return

            if isinstance(instr, CoreCPY.Rot):
                s_new = stack.rotate_stack(s, instr.narg)
                yield from infer(s_new, p + 1)
                return

            if isinstance(instr, CoreCPY.Store):
                assert isinstance(instr.sym, int)
                a, s = stack.pop(s)
                if isinstance(a, dynjit.S):
                    s_new = stack.store_rev(s, instr.sym, a)
                else:
                    a_dyn = dynjit.AbstractValue(dynjit.D(instr.sym), a.type)
                    s_new = stack.store_rev(s, instr.sym, a_dyn)
                    yield dynjit.Assign(a_dyn, a)
                yield from infer(s_new, p + 1)
                return
            if isinstance(instr, CoreCPY.Call):
                v_args: List[dynjit.AbstractValue] = []
                for _ in range(instr.narg):
                    v, s = stack.pop(s)
                    v_args.append(v)
                v_args.reverse()
                f, s = stack.pop(s)
                f: dynjit.AbstractValue = f

                t_f = f.type
                if isinstance(t_f, types.PrimT):
                    assert isinstance(f.repr, dynjit.S)

                    is_no_specialization = yield from call_prim(infer, f.repr.c, v_args, s, p)
                    if not is_no_specialization:
                        return

                if isinstance(t_f, types.ClosureT):
                    specialised = self.specialise(t_f.func, t_f.celltype, *[v.type for v in v_args])
                    if specialised:
                        spec_method: dynjit.AbstractValue = specialised.method
                        cells = dynjit.Call(prims.v_get_cells, [f])
                        expr = dynjit.Call(spec_method, [cells, *v_args])
                        n = stack.size(s)
                        a_dyn = dynjit.AbstractValue(dynjit.D(n), specialised.return_type)
                        s_new = stack.cons(a_dyn, s)
                        yield dynjit.Assign(a_dyn, expr)
                        yield from infer(s_new, p + 1)
                        return

                n = stack.size(s)
                a_dyn = dynjit.AbstractValue(dynjit.D(n), types.TopT())
                s_new = stack.cons(a_dyn, s)
                yield dynjit.Assign(a_dyn, dynjit.Call(prims.v_py_call, [f, *v_args]))
                yield from infer(s_new, p + 1)
                return
            if isinstance(instr, CoreCPY.Jump):
                yield from infer(s, find_p(instr.lbl))
                return

            if isinstance(instr, CoreCPY.JumpIf):
                expect = dynjit.AbstractValue(dynjit.S(instr.expect), types.bool_t)
                a, s_new = s
                if a.type is not types.bool_t:
                    cond = dynjit.Call(prims.v_beq, [dynjit.Call(prims.v_asbool, [a]), expect])
                else:
                    cond = dynjit.Call(prims.v_beq, [a, expect])
                if instr.keep:
                    arm1 = list(infer(s, find_p(instr.lbl)))
                else:
                    arm1 = list(infer(s_new, find_p(instr.lbl)))
                arm2 = list(infer(s_new, p + 1))
                yield dynjit.If(cond, arm1, arm2)
                return
            if isinstance(instr, CoreCPY.Return):
                a, _ = stack.pop(s)
                if a.type not in return_types:
                    return_types.append(a.type)

                yield dynjit.Return(a)
                return

        return return_types, list(infer(S, 0))


def call_prim(infer, prim_func, args, s, p):
    if padd.cond(prim_func, args):
        ret = yield from padd.spec(infer, args, s, p)

    elif pinst.cond(prim_func, args):
        ret = yield from pinst.spec(infer, args, s, p)
    else:
        ret = NO_SPECIALIZATION

    return ret
