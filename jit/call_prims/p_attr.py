from jit import prims, dynjit, types, stack, intrinsics
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.ll import get_slot_member_offset
from jit.pe import PE
from typing import cast
from _json import encode_basestring


@register_dispatch(intrinsics.i_getattr, 2)
def spec1(self: PE, args, s, p):
    infer = self.infer
    l: dynjit.AbstractValue = args[0]
    r: dynjit.AbstractValue = args[1]
    n = stack.size(s)
    if r.type is types.str_t and isinstance(r.repr, dynjit.S):
        r_val = cast(str, r.repr.c)
        l_type = l.type
        const_attrname = prims.mk_v_const_sym(encode_basestring(r_val))

        if not isinstance(l_type, types.NomT):
            pytype = l_type.to_py_type()
            if r_val in getattr(pytype, "__slots__", ()):
                offset = prims.mk_v_const_sym(
                    repr(get_slot_member_offset(getattr(pytype, r_val)))
                )
                abs_val = dynjit.AbstractValue(
                    dynjit.D(n), types.TopT()
                )
                yield dynjit.Assign(
                    abs_val,
                    dynjit.Call(
                        prims.v_getoffset,
                        [l, offset, const_attrname],
                        type=abs_val.type,
                    ),
                )
                s = stack.cons(abs_val, s)
                yield from infer(s, p + 1)
                return
        else:
            if r_val in l_type.members:
                ret_t = l_type.members[r_val]
                abs_val = dynjit.AbstractValue(dynjit.D(n), ret_t)
                pytype = l_type.to_py_type()
                if (
                    getattr(pytype, "__slots__", None)
                    and r_val in pytype.__slots__
                ):
                    offset = prims.mk_v_const_sym(
                        repr(
                            get_slot_member_offset(
                                getattr(pytype, r_val)
                            )
                        )
                    )
                    yield dynjit.Assign(
                        abs_val,
                        dynjit.Call(
                            prims.v_getoffset,
                            [l, offset, const_attrname],
                            type=ret_t,
                        ),
                    )
                else:
                    yield dynjit.Assign(
                        abs_val,
                        dynjit.Call(
                            prims.v_getattr,
                            [l, r],
                            type=ret_t,
                        ),
                    )
                s = stack.cons(abs_val, s)
                yield from infer(s, p + 1)
                return

            if r_val in l_type.methods:
                unbound_method = l_type.methods[r_val]
                meth_t = types.MethT(l.type, unbound_method.type)
                abs_val = dynjit.AbstractValue(dynjit.D(n), meth_t)
                yield dynjit.Assign(
                    abs_val,
                    dynjit.Call(
                        prims.v_mkmethod,
                        [unbound_method, l],
                        type=meth_t,
                    ),
                )
                s = stack.cons(abs_val, s)
                yield from infer(s, p + 1)
                return
            elif r_val in l_type.static_methods:
                static_method = l_type.static_methods[r_val]
                s = stack.cons(static_method, s)
                yield from infer(s, p + 1)
                return

    abs_val = dynjit.AbstractValue(dynjit.D(n), types.TopT())
    yield dynjit.Assign(
        abs_val, dynjit.Call(prims.v_getattr, [l, r], type=abs_val.type)
    )
    s = stack.cons(abs_val, s)
    yield from infer(s, p + 1)
    return
