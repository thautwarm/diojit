from typing import cast
from jit import prims, dynjit, types, stack, intrinsics
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.pe import PE
import jit.cflags as cflags
import types as pytypes


@register_dispatch(intrinsics.i_store, 7)
@register_dispatch(intrinsics.i_store, 6)
@register_dispatch(intrinsics.i_store, 5)
@register_dispatch(intrinsics.i_store, 4)
def spec(self: PE, args, s, p):
    # https://docs.python.org/3/library/dis.html?highlight=bytecode#opcode-MAKE_FUNCTION
    flag: dynjit.AbstractValue = args[-1]
    assert isinstance(flag.repr, dynjit.S) and flag.type is types.int_t
    flag: int = cast(int, flag.repr.c)
    args = list(reversed(args))

    if flag & 0x01:
        raise NotImplementedError

    if flag & 0x02:
        raise NotImplementedError

    if flag & 0x04:
        raise NotImplementedError

    if flag & 0x04:
        raise NotImplementedError

    if flag & 0x08:
        raise NotImplementedError

    code_obj: pytypes.CodeType = args.pop()

    if code_obj.co_flags & cflags.VARARGS:
        raise NotImplementedError
    if code_obj.co_flags & cflags.COROUTINE:
        raise NotImplementedError
    if code_obj.co_flags & cflags.ITERABLE_COROUTINE:
        raise NotImplementedError
    if code_obj.co_flags & cflags.ASYNC_GENERATOR:
        raise NotImplementedError
    if code_obj.co_flags & cflags.GENERATOR:
        raise NotImplementedError
    if code_obj.co_flags & cflags.VARKEYWORDS:
        raise NotImplementedError

    code_name = args.pop()
    assert not args
    f = pytypes.FunctionType(
        code_obj, cast(dict, self.glob_val.repr.c), code_name
    )
    v_f = dynjit.AbstractValue(dynjit.S(f), types.FPtrT(f))
    s = stack.cons(v_f, s)
    yield from self.infer(s, p + 1)
