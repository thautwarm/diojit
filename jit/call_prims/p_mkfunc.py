from typing import cast
from jit import prims, dynjit, types, stack, intrinsics
from jit.call_prims import register_dispatch, NO_SPECIALIZATION
from jit.pe import PE
import jit.cflags as cflags
import types as pytypes


@register_dispatch(intrinsics.i_mkfunc, 7)
@register_dispatch(intrinsics.i_mkfunc, 6)
@register_dispatch(intrinsics.i_mkfunc, 5)
@register_dispatch(intrinsics.i_mkfunc, 4)
@register_dispatch(intrinsics.i_mkfunc, 3)
def spec(self: PE, args, s, p):
    # https://docs.python.org/3/library/dis.html?highlight=bytecode#opcode-MAKE_FUNCTION
    flag: dynjit.Abs = args[-1]
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

    code_obj_abs_val: dynjit.Abs = args.pop()
    assert isinstance(code_obj_abs_val.repr, dynjit.S) and isinstance(code_obj_abs_val.repr.c, pytypes.CodeType)
    code_obj: pytypes.CodeType = code_obj_abs_val.repr.c

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

    code_name: dynjit.Abs = args.pop()
    assert isinstance(code_name.repr, dynjit.S) and isinstance(code_name.repr.c, str)

    assert len(args) == 1
    f = pytypes.FunctionType(
        code_obj, cast(dict, self.glob_val.repr.c), code_name.repr.c
    )
    v_f = dynjit.Abs(dynjit.S(f), types.FPtrT(code_obj.co_argcount, f))
    s = stack.cons(v_f, s)
    yield from self.infer(s, p + 1)
