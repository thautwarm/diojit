import typing as _t
import jit.core as core
import jit.opname as opname
import jit.cflags as cflags
import dis
import types as _types
import inspect
from contextlib import contextmanager

__all__ = ["translate"]

JUMP_NAMES = frozenset(
    {
        opname.POP_JUMP_IF_TRUE,
        opname.POP_JUMP_IF_FALSE,
        opname.JUMP_IF_TRUE_OR_POP,
        opname.JUMP_IF_FALSE_OR_POP,
    }
)


BIN_OPS = {
    opname.BINARY_OR: core.Bin.or_,
    opname.BINARY_ADD: core.Bin.add,
    opname.BINARY_SUBTRACT: core.Bin.sub,
    opname.BINARY_FLOOR_DIVIDE: core.Bin.floordiv,
    opname.BINARY_TRUE_DIVIDE: core.Bin.truediv,
    opname.BINARY_MULTIPLY: core.Bin.mul,
    opname.BINARY_SUBSCR: core.Bin.getitem,
}


CMP_OPS = {
    "<": core.Bin.lt,
    ">": core.Bin.gt,
    "<=": core.Bin.le,
    ">=": core.Bin.ge,
    "!=": core.Bin.ne,
    "==": core.Bin.eq
}


class PyC:
    def __init__(self, f):
        co = dis.Bytecode(f)
        self.co = list(co)
        self.label_to_co_offsets = _map = {}
        for i, instr in enumerate(
            self.co
        ):  # type:  int, dis.Instruction
            if instr.is_jump_target:
                _map[instr.offset] = i
            if instr.opcode in JUMP_NAMES:
                instr = self.co[i + 1]
                _map[instr.offset] = i + 1

        self.glob_names = set()
        self.offset = 0
        code: _types.CodeType = co.codeobj
        self.hasvararg = bool(code.co_flags & cflags.VARARGS)
        self.packing = None
        self.codeobj = code
        self.stack_size = len(code.co_varnames) - self.hasvararg
        assert (
            not code.co_cellvars and not code.co_freevars
        ), "cannot handle closures so far"
        self.cur_block = entry_block = []
        self.blocks: core.In_Blocks = {"entry": entry_block}
        self.block_maps: _t.Dict[_t.Tuple[int, int], str] = {}

        self.label_cnt = 0

    def make(self):
        self.interp(0)
        return self.blocks, self.glob_names

    def is_jump_target(self, bytecode_offset: int):
        return bytecode_offset in self.label_to_co_offsets

    def gen_label(self):
        self.label_cnt += 1
        return f"l{self.label_cnt}"

    def codegen(self, *stmts: core.In_Stmt):
        self.cur_block.extend(stmts)

    def cur(self) -> dis.Instruction:
        return self.co[self.offset]

    def next(self) -> dis.Instruction:
        return self.co[self.offset + 1]

    def push(self, a: core.AbsVal):
        self.stack_size += 1
        tos = self.peek(0)
        if tos != a:
            self.codegen(core.In_Move(tos, a))

    def pop(self):
        tos = self.peek(0)
        self.stack_size -= 1
        return tos

    def call(self, f: core.AbsVal, *args: core.AbsVal):
        self.stack_size += 1
        tos = self.peek(0)
        self.codegen(core.In_Bind(tos, f, "__call__", args))

    def call_method(
        self, m: core.AbsVal, attr: core.AbsVal, *args: core.AbsVal
    ):
        self.stack_size += 1
        tos = self.peek(0)
        self.codegen(core.In_Bind(tos, m, attr, args))

    def peek(self, i: int):
        return core.DynAbsVal(self.stack_size - i - 1, core.A_top)

    def varlocal(self, i: int):
        if i < self.codeobj.co_argcount:
            return core.DynAbsVal(i, core.A_top)
        return core.DynAbsVal(i - self.hasvararg, core.A_top)

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
            if arg == self.packing:
                args.append(core.UNDEF)
            else:
                args.append(arg)
        self.packing = None
        args.reverse()
        return args

    def interp(self, offset=0):
        while True:
            x: dis.Instruction = self.cur()
            if self.is_jump_target(x.offset) and self.offset != offset:
                label = self.jump(self.offset)
                self.codegen(core.In_Goto(label))
                return

            if x.opcode is opname.LOAD_CONST:
                argval = x.argval
                if isinstance(argval, tuple):
                    self.push(core.from_runtime(argval))
                elif isinstance(argval, core.literal_runtime_types):
                    self.push(argval)
                elif argval is ...:
                    self.push(...)
                    self.packing = self.peek(0)

            elif x.opcode is opname.LOAD_FAST:
                var = self.varlocal(x.arg)
                self.push(var)
            elif x.opcode is opname.STORE_FAST:
                tos = self.pop()
                var = self.varlocal(x.arg)
                self.codegen(core.In_Move(var, tos))
            elif x.opcode is opname.LOAD_GLOBAL:
                self.require_global(x.argval)
                self.call(core.PrimAbsVal.GetGlobal, x.argval)
            elif x.opcode is opname.STORE_GLOBAL:
                raise NotImplemented
            elif x.opcode is opname.STORE_ATTR:
                a_base = self.pop()
                a_value = self.pop()
                self.call(core.A_setattr, a_base, x.argval, a_value)
            elif (
                x.opcode is opname.JUMP_ABSOLUTE
                or x.opcode is opname.JUMP_FORWARD
            ):
                label = self.jump(self.find_offset(x.arg))
                self.codegen(core.In_Goto(label))
                return
            elif x.opcode is opname.JUMP_IF_TRUE_OR_POP:
                b_off_1 = self.find_offset(x.arg)
                b_off_2 = self.find_offset(self.next().offset)
                tos = self.peek(0)
                l1 = self.jump(b_off_1)
                self.pop()
                l2 = self.jump(b_off_2)
                self.codegen(core.In_Cond(tos, l1, l2))
                return
            elif x.opcode is opname.JUMP_IF_FALSE_OR_POP:
                b_off_1 = self.find_offset(x.arg)
                b_off_2 = self.find_offset(self.next().offset)
                tos = self.peek(0)
                l1 = self.jump(b_off_1)
                self.pop()
                l2 = self.jump(b_off_2)
                self.codegen(core.In_Cond(tos, l2, l1))
                return
            elif x.opcode is opname.POP_JUMP_IF_TRUE:
                b_off_1 = self.find_offset(x.arg)
                b_off_2 = self.find_offset(self.next().offset)
                tos = self.pop()
                l1 = self.jump(b_off_1)
                l2 = self.jump(b_off_2)
                self.codegen(core.In_Cond(tos, l1, l2))
                return
            elif x.opcode is opname.POP_JUMP_IF_FALSE:
                b_off_1 = self.find_offset(x.arg)
                b_off_2 = self.find_offset(self.next().offset)
                tos = self.pop()
                l1 = self.jump(b_off_1)
                l2 = self.jump(b_off_2)
                self.codegen(core.In_Cond(tos, l2, l1))
                return
            elif x.opcode is opname.LOAD_METHOD:
                self.push(x.argval)
            elif x.opcode is opname.LOAD_ATTR:
                tos = self.pop()
                self.call(core.PrimAbsVal.GetField, tos, x.argval)
            elif x.opcode is opname.CALL_METHOD:
                args = self.get_nargs(x.argval)
                attr = self.pop()
                subj = self.pop()
                self.call_method(subj, attr, *args)
            elif x.opcode is opname.CALL_FUNCTION:
                args = self.get_nargs(x.argval)
                f = self.pop()
                self.call(f, *args)
            elif x.opcode is opname.ROT_TWO:
                self.push(self.peek(0))
                self.codegen(core.In_Move(self.peek(1), self.peek(2)))
                subj = self.peek(2)
                self.codegen(core.In_Move(subj, self.pop()))
            elif x.opcode is opname.ROT_THREE:
                a1 = self.peek(0)
                a2 = self.peek(1)
                a3 = self.peek(2)

                self.push(a1)
                b1 = self.peek(0)
                self.push(a2)
                b2 = self.peek(0)
                self.push(a3)
                b3 = self.peek(0)

                self.codegen(core.In_Move(a3, b1))
                self.codegen(core.In_Move(a2, b3))
                self.codegen(core.In_Move(a1, b2))

                self.pop()
                self.pop()
                self.pop()
            elif x.opcode is opname.ROT_FOUR:
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

                self.codegen(core.In_Move(a4, b1))
                self.codegen(core.In_Move(a3, b4))
                self.codegen(core.In_Move(a2, b3))
                self.codegen(core.In_Move(a1, b2))

                self.pop()
                self.pop()
                self.pop()
                self.pop()
            elif x.opcode is opname.DUP_TOP:
                self.push(self.peek(0))
            elif x.opcode is opname.DUP_TOP_TWO:
                a = self.peek(0)
                self.push(a)
                self.push(a)
            elif x.opname.startswith("BINARY_"):
                right, left = self.pop(), self.pop()
                self.call(BIN_OPS[x.opcode], left, right)
            elif x.opcode is opname.BUILD_TUPLE:
                args = self.get_nargs(x.argval)
                self.call(core.PrimAbsVal.CreateTuple, *args)
            elif x.opcode is opname.BUILD_LIST:
                args = self.get_nargs(x.argval)
                self.call(
                    core.PrimAbsVal.CallC,
                    core.A_list,
                    core.CAPIs.CreateList,
                    *args,
                )
            elif x.opcode is opname.RETURN_VALUE:
                tos = self.pop()
                self.codegen(core.In_Return(tos))
                return
            elif x.opcode is opname.COMPARE_OP:
                cmp_name = dis.cmp_op[x.arg]
                right, left = self.pop(), self.pop()
                if cmp_name == "not_in":
                    self.call_method(left, "__contains__", right)
                    self.call(core.PrimAbsVal.Not, self.pop())
                elif cmp_name == "in":
                    self.call_method(left, "__contains__", right)
                elif cmp_name == "exception match":
                    raise NotImplemented
                elif cmp_name == "is":
                    self.call(core.PrimAbsVal.Is, left, right)
                elif cmp_name == "is not":
                    self.call(core.PrimAbsVal.Is, left, right)
                    self.call(core.PrimAbsVal.Not, self.pop())
                else:
                    self.call_method(left, CMP_OPS[cmp_name], right)

            elif x.opcode is opname.POP_TOP:
                self.pop()
            else:
                raise
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
