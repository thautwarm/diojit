from jit.CoreCPY import *
import jit.opname as opname
from jit.intrinsics import *


def _from_pyc(x: dis.Instruction, co: CodeType):
    hasfree = 1
    if x.opcode is opname.LOAD_CONST:
        const = co.co_consts[x.arg]
        yield Constant(const)
    elif x.opcode is opname.LOAD_FAST:
        yield Load(x.arg + hasfree)
    elif x.opcode is opname.STORE_FAST:
        yield Store(x.arg + hasfree)
    elif x.opcode is opname.LOAD_GLOBAL:
        name = co.co_names[x.arg]
        yield Constant(i_getitem)
        yield Constant(i_globals)
        yield Call(0)
        yield Constant(name)
        yield Call(2)
    elif x.opcode is opname.STORE_GLOBAL:
        name = co.co_names[x.arg]
        yield Constant(i_setitem)
        yield Constant(i_globals)
        yield Call(0)
        yield Constant(name)
        yield Rot(4)
        yield Rot(4)
        yield Rot(4)
        yield Call(3)
        yield Pop()

    elif x.opcode is opname.STORE_ATTR:
        # |v|x|
        # need: |f|x|attr|v|
        yield Constant(co.co_names[x.arg])
        # |v|x|attr|
        yield Rot(3)
        # |attr|v|x|
        yield Rot(3)
        # |x|attr|v|
        yield Constant(i_setattr)
        # |x|attr|v|f|
        yield Rot(4)
        # |f|x|attr|v|
        yield Call(3)
        yield Pop()

    elif x.opcode is opname.JUMP_ABSOLUTE:
        yield Jump(x.arg)

    elif x.opcode is opname.JUMP_FORWARD:
        if x.arg:
            yield Jump(x.arg + x.offset)

    elif x.opcode is opname.JUMP_IF_FALSE_OR_POP:
        yield JumpIf(False, True, x.arg)

    elif x.opcode is opname.JUMP_IF_TRUE_OR_POP:
        yield JumpIf(True, True, x.arg)

    elif x.opcode is opname.POP_JUMP_IF_FALSE:
        yield JumpIf(False, False, x.arg)

    elif x.opcode is opname.POP_JUMP_IF_TRUE:
        yield JumpIf(True, False, x.arg)

    #  *_METHOD is treated as regular member lookup
    elif x.opcode is opname.LOAD_ATTR or x.opcode is opname.LOAD_METHOD:
        attr = co.co_names[x.arg]
        yield Constant(i_getattr)
        yield Rot(2)
        yield Constant(attr)
        yield Call(2)

    elif (
        x.opcode is opname.CALL_FUNCTION
        or x.opcode is opname.CALL_METHOD
    ):
        yield Call(x.arg)

    elif x.opcode is opname.ROT_TWO:
        yield Rot(2)

    elif x.opcode is opname.ROT_THREE:
        yield Rot(3)

    elif x.opcode is opname.ROT_FOUR:
        yield Rot(4)

    elif x.opcode is opname.DUP_TOP:
        yield Peek(0)

    elif x.opcode is opname.DUP_TOP_TWO:
        yield Peek(1)
        yield Peek(1)

    elif x.opcode is opname.BINARY_OR:
        yield Constant(operator.or_)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_ADD:
        yield Constant(operator.add)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_SUBTRACT:
        yield Constant(operator.add)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_SUBSCR:
        yield Constant(i_getitem)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_AND:
        yield Constant(operator.and_)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_FLOOR_DIVIDE:
        yield Constant(operator.floordiv)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_MATRIX_MULTIPLY:
        yield Constant(operator.matmul)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_LSHIFT:
        yield Constant(operator.lshift)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_RSHIFT:
        yield Constant(operator.rshift)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_MODULO:
        yield Constant(operator.mod)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_POWER:
        yield Constant(operator.pow)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_TRUE_DIVIDE:
        yield Constant(operator.truediv)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_MULTIPLY:
        yield Constant(operator.mul)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BINARY_XOR:
        yield Constant(operator.xor)
        yield Rot(3)
        yield Call(2)

    elif x.opcode is opname.BUILD_TUPLE:
        yield Constant(i_buildtuple)
        yield Rot(x.arg + 1)
        yield Call(x.arg)

    elif x.opcode is opname.BUILD_LIST:
        yield Constant(i_buildlist)
        yield Rot(x.arg + 1)
        yield Call(x.arg)

    elif x.opcode is opname.RETURN_VALUE:
        yield Return()

    elif x.opcode is opname.COMPARE_OP:
        cmp_name = dis.cmp_op[x.arg]
        if cmp_name == "not_in":
            yield Constant(operator.not_)
            yield Rot(2)
            yield Constant(operator.contains)
            yield Rot(3)
            yield Call(2)
            yield Call(1)
        elif cmp_name == "in":
            yield Rot(2)
            yield Constant(operator.contains)
            yield Rot(3)
            yield Call(2)
        else:
            yield Constant(_cmp_instrinsics.get(cmp_name))
            yield Rot(3)
            yield Call(2)
    elif x.opcode is opname.MAKE_FUNCTION:
        flag = x.arg
        argc = 2 + bin(flag & 0b1111).count("1")
        yield Constant(flag)
        yield Constant(i_mkfunc)
        yield Rot(argc + 2)
        yield Call(argc + 1)
    elif x.opcode is opname.POP_TOP:
        yield Pop()

    elif x.opcode is opname.GET_ITER:
        yield Constant(iter)
        yield Rot(2)
        yield Call(1)

    else:
        raise ValueError(x.opname)


_cmp_instrinsics = {
    "<": operator.lt,
    ">": operator.lt,
    "<=": operator.le,
    ">=": operator.ge,
    "!=": operator.ne,
    "is": operator.is_,
    "is not": operator.is_not,
    "exception match": i_exec_match,
}
