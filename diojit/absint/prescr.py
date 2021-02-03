from .abs import *
from .intrinsics import *
from mypy_extensions import VarArg
import warnings
import typing
import operator
import math

_undef = object()

__all__ = ["create_shape", "register"]


def create_shape(o: object, oop: bool = False, instance=_undef):
    """
    o: 'Special Object' in the paper. Must be immutable.
    oop: whether attached methods will be
         used as bound method in method resolution.
    instance: only works when 'o' is a 'type'.
              It is defined only the type has only
              one instance.
    """
    try:
        hash(o)
    except TypeError:
        raise TypeError(f"create shape for non immuatble object {o}")
    if instance is _undef:
        instance = None
    else:
        instance = from_runtime(instance)
        assert not isinstance(instance, D)

    if shape := ShapeSystem.get(o):
        return shape
    shape = ShapeSystem[o] = Shape(o, oop, {}, instance)
    return shape


_create_shape = create_shape


def register(
    o: object,
    attr="__call__",
    create_shape: typing.Union[dict, None, typing.Literal[True]] = None,
):

    if shape := ShapeSystem.get(o):
        pass
    else:
        if create_shape is not None:
            if create_shape is True:
                create_shape = {}
            shape = _create_shape(o, **create_shape)
        else:
            raise ValueError(
                f"No shape found for {{ o={o} }}.\n"
                f" Maybe use {{ jit.create_shape(o, oop_or_not) }} firstly?"
            )
    if attr in shape.fields:
        warnings.warn(
            Warning(
                f"field {attr} exists for the shape of object f{o}."
            )
        )

    def ap(f: typing.Callable[[Judge, VarArg(AbsVal)], CallSpec]):
        shape.fields[attr] = f
        return f

    return ap


def shape_of(o):
    return ShapeSystem[o]


create_shape(Intrinsic, oop=True)


@register(Intrinsic, "__call__")
def py_call_intrinsic(
    self: Judge, f: AbsVal, *args: AbsVal
) -> CallSpec:
    return CallSpec(None, f(*args), (Top,))


@register(
    Intrinsic.Py_LoadGlobal, "__call__", create_shape=dict(oop=False)
)
def py_load_global(self: Judge, a_str: AbsVal) -> CallSpec:

    if a_str.is_literal() and isinstance(a_str.base, str):
        attr = a_str.base
        if attr in self.abs_glob:
            a = self.abs_glob[attr]
            return CallSpec(None, a, possibly_return_types=(a.type,))
        return CallSpec(None, S(Intrinsic.Py_LoadGlobal)(a_str), (Top,))
    return CallSpec(
        None, S(Intrinsic.Py_Raise)(S(NameError)(a_str)), (Bot,)
    )


create_shape(bool, oop=True)


@register(bool, attr="__call__")
def py_call_bool_type(self: Judge, *args: AbsVal):
    if not args:
        # bool() = False
        constant_return = S(False)
        return CallSpec(
            constant_return, constant_return, (Values.A_Bool,)
        )
    if len(args) != 1:
        # bool(a, b, c) = False
        return NotImplemented
    # bool(a)
    arg = args[0]
    if isinstance(arg.type, S) and issubclass(arg.type.base, bool):
        constant_return = isinstance(arg, S) and arg or None
        return CallSpec(constant_return, arg, (Values.A_Bool,))
    return CallSpec(
        None,
        S(intrinsic("Py_CallBoolIfNecessary"))(arg),
        (Values.A_Bool,),
    )


@register(isinstance, create_shape=True)
def spec_isinstance(self: Judge, l: AbsVal, r: AbsVal):
    if (
        isinstance(l.type, S)
        and isinstance(r, S)
        and isinstance(r.base, type)
    ):
        const = l.type == r or l.type.base in r.base.__bases__
        return CallSpec(S(const), S(const), tuple({Values.A_Bool}))
    return NotImplemented


@register(operator.__pow__, create_shape=True)
def spec_pow(self: Judge, l: AbsVal, r: AbsVal):
    if l.type == Values.A_Int:
        if r.type == Values.A_Int:
            py_int_power_int = S(intrinsic("Py_IntPowInt"))
            return_types = tuple({Values.A_Int})
            constant_result = None  # no constant result
            return CallSpec(
                constant_result, py_int_power_int(l, r), return_types
            )
    return NotImplemented


@register(operator.__add__, create_shape=True)
def spec_add(self: Judge, l: AbsVal, r: AbsVal):
    if l.type == Values.A_Int:
        if r.type == Values.A_Int:
            py_int_add_int = S(intrinsic("Py_IntAddInt"))
            return_types = tuple({Values.A_Int})
            constant_result = None  # no constant result
            return CallSpec(
                constant_result, py_int_add_int(l, r), return_types
            )
    return NotImplemented


@register(math.sqrt, create_shape=True)
def spec_sqrt(self: Judge, a: AbsVal):
    if a.type == Values.A_Int:
        int_sqrt = S(intrinsic("Py_IntSqrt"))
        return CallSpec(None, int_sqrt(a), tuple({Values.A_Float}))
    return NotImplemented
