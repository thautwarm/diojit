from jit.CoreCPY import *
import jit.opname as opname
import operator
intrinsic_globals = globals
intrinsic_locals = locals


def intrinsic_deref(x):
    return x.cell_contents


intrinsic_item = operator.getitem


def build_tuple(*args):
    return args


def build_list(*args):
    return list(args)


def intrinsic_setitem(x, i, v):
    x[i] = v


def intrinsic_store(x, v):
    x.cell_contents = v


def intrinsic_not(x):
    return not x


def intrinsic_attr(x, s):
    return getattr(x, s)


def _from_pyc(x: dis.Instruction, co: CodeType):
    hasfree = bool(co.co_freevars)
    if x.opcode is opname.LOAD_CONST:
        const = co.co_consts[x.arg]
        yield Constant(const)
    elif x.opcode is opname.LOAD_FAST:
        yield Load(x.arg + hasfree)
    elif x.opcode is opname.LOAD_DEREF:
        len_cells = len(co.co_cellvars)
        if x.arg < len_cells:
            yield Constant(intrinsic_deref)
            yield Load(x.arg + len(co.co_varnames) + hasfree)
            yield Call(1)
        else:
            yield Constant(intrinsic_deref)
            yield Constant(intrinsic_item)
            yield Load(0)
            yield Constant(len_cells - x.arg)
            yield Call(2)
            yield Call(1)
    elif x.opcode is opname.LOAD_CLOSURE:
        len_cells = len(co.co_cellvars)
        if x.arg < len_cells:
            yield Load(x.arg + len(co.co_varnames) + hasfree)
        else:
            yield Constant(intrinsic_item)
            yield Load(0)
            yield Constant(len_cells - x.arg)
            yield Call(2)

    elif x.opcode is opname.STORE_FAST:
        yield Store(x.arg + hasfree)
    elif x.opcode is opname.STORE_DEREF:
        len_cells = len(co.co_cellvars)
        if x.arg < len_cells:
            yield Constant(intrinsic_store)
            yield Load(x.arg + len(co.co_varnames) + hasfree)
            yield Rot(3)
            yield Rot(3)
            yield Call(2)
            yield Pop()
        else:
            yield Constant(intrinsic_store)
            yield Constant(intrinsic_item)
            yield Load(0)
            yield Constant(len_cells - x.arg)
            yield Call(2)
            yield Rot(3)
            yield Rot(3)
            yield Call(2)
            yield Pop()
    elif x.opcode is opname.LOAD_GLOBAL:
        name = co.co_names[x.arg]
        yield Constant(intrinsic_item)
        yield Constant(intrinsic_globals)
        yield Call(0)
        yield Constant(name)
        yield Call(2)
    elif x.opcode is opname.STORE_GLOBAL:
        name = co.co_names[x.arg]
        yield Constant(intrinsic_setitem)
        yield Constant(intrinsic_globals)
        yield Call(0)
        yield Constant(name)
        yield Rot(4)
        yield Rot(4)
        yield Rot(4)
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

    elif x.opcode is opname.JUMP_IF_TRUE_OR_POP:
        yield JumpIf(True, False, x.arg)

    #  *_METHOD is treated as regular member lookup
    elif x.opcode is opname.CALL_FUNCTION or x.opcode is opname.LOAD_ATTR:
        attr = co.co_names[x.arg]
        yield Constant(intrinsic_attr)
        yield Rot(2)
        yield Constant(attr)
        yield Call(2)

    elif x.opcode is opname.CALL_FUNCTION or x.opcode is opname.CALL_METHOD:
        attr = co.co_names[x.arg]
        yield Constant(intrinsic_attr)
        yield Rot(2)
        yield Constant(attr)
        yield Call(2)

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
        yield Constant(intrinsic_item)
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
        yield Constant(build_tuple)
        yield Rot(x.arg + 1)
        yield Call(x.arg)

    elif x.opcode is opname.BUILD_LIST:
        yield Constant(build_list)
        yield Rot(x.arg + 1)
        yield Call(x.arg)

    elif x.opcode is opname.RETURN_VALUE:
        yield Return()

