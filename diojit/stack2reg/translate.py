from __future__ import annotations
import typing as _t
import dis
import types as _types
import operator
from contextlib import contextmanager
from . import opcodes
from . import cflags
from diojit.absint import *

__all__ = ["translate"]

JUMP_NAMES: frozenset[int] = frozenset(
    {
        opcodes.POP_JUMP_IF_TRUE,
        opcodes.POP_JUMP_IF_FALSE,
        opcodes.JUMP_IF_TRUE_OR_POP,
        opcodes.JUMP_IF_FALSE_OR_POP,
    }
)


BIN_OPS: dict[int, FunctionType] = {
    opcodes.BINARY_POWER: operator.__pow__,
    opcodes.BINARY_MULTIPLY: operator.__mul__,
    opcodes.BINARY_MATRIX_MULTIPLY: operator.__matmul__,
    opcodes.BINARY_FLOOR_DIVIDE: operator.__floordiv__,
    opcodes.BINARY_TRUE_DIVIDE: operator.__truediv__,
    opcodes.BINARY_MODULO: operator.__mod__,
    opcodes.BINARY_ADD: operator.__add__,
    opcodes.BINARY_SUBTRACT: operator.__sub__,
    opcodes.BINARY_SUBSCR: operator.__getitem__,
    opcodes.BINARY_LSHIFT: operator.__lshift__,
    opcodes.BINARY_RSHIFT: operator.__rshift__,
    opcodes.BINARY_AND: operator.__and__,
    opcodes.BINARY_XOR: operator.__xor__,
    opcodes.BINARY_OR: operator.__or__,
}


CMP_OPS: dict[str, FunctionType] = _t.cast(_t.Dict[str, FunctionType], {
    "<": operator.__lt__,
    ">": operator.__gt__,
    "<=": operator.__le__,
    ">=": operator.__ge__,
    "!=": operator.__ne__,
    "==": operator.__eq__,
})


def flags_check(flag, *patterns):
    return any(flag & p for p in patterns)


class PyC:
    def __init__(self, f):
        co = dis.Bytecode(f)
        code: _types.CodeType = co.codeobj
        if flags_check(
            code.co_flags,
            cflags.VARARGS,
            cflags.ASYNC_GENERATOR,
            cflags.ITERABLE_COROUTINE,
            cflags.VARKEYWORDS,
            cflags.GENERATOR,
            cflags.COROUTINE,
        ):
            raise ValueError

        self.co = list(co)
        self.label_to_co_offsets = _map = {}
        for i, instr in enumerate(self.co):  # type:  int, dis.Instruction
            if instr.is_jump_target:
                _map[instr.offset] = i
            if instr.opcode in JUMP_NAMES:
                instr = self.co[i + 1]
                _map[instr.offset] = i + 1

        self.glob_names = set()
        self.offset = 0
        self.codeobj = code
        self.stack_size = len(code.co_varnames)
        assert (
            not code.co_cellvars and not code.co_freevars
        ), "cannot handle closures so far"
        self.cur_block = entry_block = []
        self.blocks: In_Blocks = {"entry": entry_block}
        self.block_maps: _t.Dict[_t.Tuple[int, int], str] = {}
        self.label_cnt = 0
        self.lastlinenumber = None
        self.filename = code.co_filename

    def make(self):
        self.interp(0)
        return self.blocks, self.glob_names

    def is_jump_target(self, bytecode_offset: int):
        return bytecode_offset in self.label_to_co_offsets

    def gen_label(self):
        self.label_cnt += 1
        return f"l{self.label_cnt}"

    def codegen(self, *stmts: In_Stmt):
        self.cur_block.extend(stmts)

    def cur(self) -> dis.Instruction:
        return self.co[self.offset]

    def next(self) -> dis.Instruction:
        return self.co[self.offset + 1]

    def push(self, a: AbsVal):
        self.stack_size += 1
        tos = self.peek(0)
        if tos != a:
            self.codegen(In_Move(tos, a))

    def pop(self):
        tos = self.peek(0)
        self.stack_size -= 1
        return tos

    def call(self, f: AbsVal, *args: AbsVal):
        assert all(isinstance(a, AbsVal) for a in args)
        self.stack_size += 1
        tos = self.peek(0)
        self.codegen(In_Bind(tos, f, S("__call__"), args))

    def call_method(self, m: AbsVal, attr: AbsVal, *args: AbsVal):
        self.stack_size += 1
        tos = self.peek(0)
        self.codegen(In_Bind(tos, m, attr, args))

    def peek(self, i: int):
        return D(self.stack_size - i - 1, Top)

    def varlocal(self, i: int):
        return D(i, Top)

    def find_offset(self, bytecode_offset: int):
        return self.label_to_co_offsets[bytecode_offset]

    @contextmanager
    def generate_new_block(self, offset: int):
        old_offset = self.offset
        old_cur_block = self.cur_block
        old_stack_size = self.stack_size
        try:
            key = offset, self.stack_size
            self.offset = offset
            label = self.block_maps[key] = self.gen_label()
            self.cur_block = self.blocks[label] = []
            yield label
        finally:
            self.offset = old_offset
            self.cur_block = old_cur_block
            self.stack_size = old_stack_size

    def jump(self, offset: int) -> str:
        key = offset, self.stack_size
        if key in self.block_maps:
            return self.block_maps[key]

        with self.generate_new_block(offset) as label:
            self.interp(offset)
            return label

    def get_nargs(self, n: int):
        args = []
        for _ in range(n):
            arg = self.pop()
            args.append(arg)
        args.reverse()
        return args

    def interp(self, offset=0):
        while True:
            x: dis.Instruction = self.cur()
            if x.starts_line is not None and x.starts_line != self.lastlinenumber:
                line = x.starts_line
                self.codegen(In_SetLineno(line, self.filename))

            if self.is_jump_target(x.offset) and self.offset != offset:
                label = self.jump(self.offset)
                self.codegen(In_Goto(label))
                return

            if x.opcode is opcodes.LOAD_CONST:
                argval = x.argval
                self.push(S(argval))
            elif x.opcode is opcodes.LOAD_FAST:
                var = self.varlocal(x.arg)
                self.push(var)
            elif x.opcode is opcodes.STORE_FAST:
                tos = self.pop()
                var = self.varlocal(x.arg)
                self.codegen(In_Move(var, tos))
            elif x.opcode is opcodes.LOAD_GLOBAL:
                self.require_global(x.argval)
                self.call(S(Intrinsic.Py_LoadGlobal), S(x.argval))
            elif x.opcode is opcodes.STORE_GLOBAL:
                self.require_global(x.argval)
                self.call(S(Intrinsic.Py_StoreGlobal), S(x.argval))
            elif x.opcode is opcodes.STORE_ATTR:
                a_base = self.pop()
                a_value = self.pop()
                self.call(S(Intrinsic.Py_StoreAttr), a_base, S(x.argval), a_value)
            elif (
                x.opcode is opcodes.JUMP_ABSOLUTE
                or x.opcode is opcodes.JUMP_FORWARD
            ):
                label = self.jump(self.find_offset(x.arg))
                self.codegen(In_Goto(label))
                return
            elif x.opcode is opcodes.JUMP_IF_TRUE_OR_POP:
                b_off_1 = self.find_offset(x.arg)
                b_off_2 = self.find_offset(self.next().offset)
                tos = self.peek(0)
                l1 = self.jump(b_off_1)
                self.pop()
                l2 = self.jump(b_off_2)
                self.codegen(In_Cond(tos, l1, l2))
                return
            elif x.opcode is opcodes.JUMP_IF_FALSE_OR_POP:
                b_off_1 = self.find_offset(x.arg)
                b_off_2 = self.find_offset(self.next().offset)
                tos = self.peek(0)
                l1 = self.jump(b_off_1)
                self.pop()
                l2 = self.jump(b_off_2)
                self.codegen(In_Cond(tos, l2, l1))
                return
            elif x.opcode is opcodes.POP_JUMP_IF_TRUE:
                b_off_1 = self.find_offset(x.arg)
                b_off_2 = self.find_offset(self.next().offset)
                tos = self.pop()
                l1 = self.jump(b_off_1)
                l2 = self.jump(b_off_2)
                self.codegen(In_Cond(tos, l1, l2))
                return
            elif x.opcode is opcodes.POP_JUMP_IF_FALSE:
                b_off_1 = self.find_offset(x.arg)
                b_off_2 = self.find_offset(self.next().offset)
                tos = self.pop()
                l1 = self.jump(b_off_1)
                l2 = self.jump(b_off_2)
                self.codegen(In_Cond(tos, l2, l1))
                return
            elif x.opcode is opcodes.LOAD_METHOD:
                self.push(S(x.argval))
            elif x.opcode is opcodes.LOAD_ATTR:
                tos = self.pop()
                self.call(S(Intrinsic.Py_LoadAttr), tos, S(x.argval))
            elif x.opcode is opcodes.CALL_METHOD:
                args = self.get_nargs(x.argval)
                attr = self.pop()
                subj = self.pop()
                self.call_method(subj, attr, *args)
            elif x.opcode is opcodes.CALL_FUNCTION:
                args = self.get_nargs(x.argval)
                f = self.pop()
                self.call(f, *args)
            elif x.opcode is opcodes.ROT_TWO:
                self.push(self.peek(0))
                self.codegen(In_Move(self.peek(1), self.peek(2)))
                subj = self.peek(2)
                self.codegen(In_Move(subj, self.pop()))
            elif x.opcode is opcodes.ROT_THREE:
                a1 = self.peek(0)
                a2 = self.peek(1)
                a3 = self.peek(2)

                self.push(a1)
                b1 = self.peek(0)
                self.push(a2)
                b2 = self.peek(0)
                self.push(a3)
                b3 = self.peek(0)

                self.codegen(In_Move(a3, b1))
                self.codegen(In_Move(a2, b3))
                self.codegen(In_Move(a1, b2))

                self.pop()
                self.pop()
                self.pop()
            elif x.opcode is opcodes.ROT_FOUR:
                a1 = self.peek(0)
                a2 = self.peek(1)
                a3 = self.peek(2)
                a4 = self.peek(3)

                self.push(a1)
                b1 = self.peek(0)
                self.push(a2)
                b2 = self.peek(0)
                self.push(a3)
                b3 = self.peek(0)
                self.push(a4)
                b4 = self.peek(0)

                self.codegen(In_Move(a4, b1))
                self.codegen(In_Move(a3, b4))
                self.codegen(In_Move(a2, b3))
                self.codegen(In_Move(a1, b2))

                self.pop()
                self.pop()
                self.pop()
                self.pop()
            elif x.opcode is opcodes.DUP_TOP:
                self.push(self.peek(0))
            elif x.opcode is opcodes.DUP_TOP_TWO:
                a = self.peek(0)
                self.push(a)
                self.push(a)
            elif x.opcode is opcodes.BINARY_SUBSCR:
                right, left = self.pop(), self.pop()
                self.call_method(left, S("__getitem__"), right)
            elif x.opname.startswith("BINARY_"):
                right, left = self.pop(), self.pop()
                self.call(S(BIN_OPS[x.opcode]), left, right)
            elif x.opcode is opcodes.BUILD_TUPLE:
                args = self.get_nargs(x.argval)
                self.call(S(Intrinsic.Py_BuildTuple), *args)
            elif x.opcode is opcodes.BUILD_LIST:
                args = self.get_nargs(x.argval)
                self.call(
                    S(Intrinsic.Py_BuildList),
                    *args,
                )
            elif x.opcode is opcodes.RETURN_VALUE:
                tos = self.pop()
                self.codegen(In_Return(tos))
                return
            # python 3.9
            elif x.opcode is opcodes.IS_OP:
                right, left = self.pop(), self.pop()
                if x.argval != 1:
                    self.call(S(Intrinsic.Py_AddressCompare), left, right)
                else:
                    self.call(S(Intrinsic.Py_AddressCompare), left, right)
                    self.call(S(Intrinsic.Py_Not), self.pop())

            elif x.opcode is opcodes.COMPARE_OP:
                cmp_name = dis.cmp_op[x.arg]
                right, left = self.pop(), self.pop()
                if cmp_name == "not_in":
                    self.call_method(left, S("__contains__"), right)
                    self.call(S(Intrinsic.Py_Not), self.pop())
                elif cmp_name == "in":
                    self.call_method(left, S("__contains__"), right)
                elif cmp_name == "exception match":
                    raise NotImplemented
                elif cmp_name == "is":
                    self.call(S(Intrinsic.Py_AddressCompare), left, right)
                elif cmp_name == "is not":
                    self.call(S(Intrinsic.Py_AddressCompare), left, right)
                    self.call_method(self.pop(), S("__not__"))
                else:
                    self.call(S(CMP_OPS[cmp_name]), left, right)

            elif x.opcode is opcodes.POP_TOP:
                self.pop()
            else:
                raise ValueError(x.opname)
            self.offset += 1

    def build_const_tuple(self, argval: tuple):
        for each in argval:
            if isinstance(each, tuple):
                self.build_const_tuple(each)
            else:
                self.push(each)

    def require_global(self, argval):
        self.glob_names.add(argval)


def translate(f):
    pyc = PyC(f)
    return pyc.make()
