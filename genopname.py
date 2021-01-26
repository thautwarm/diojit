import opcode
import os
import dis
dir = "jit"
with open(os.path.join(dir, "opname.py"), 'w') as f:
    f.write("import opcode\n")
    for each in opcode.opmap:
        f.write(f"{each} = opcode.opmap[{each!r}]\n")
    f.write('\n')

with open(os.path.join(dir, "cflags.py"), 'w') as f:
    f.write("import dis\n")
    f.write("_flags = {v: k for k, v in dis.COMPILER_FLAG_NAMES.items()}\n")

    for _, n in dis.COMPILER_FLAG_NAMES.items():
        f.write(f"{n} = _flags[{n!r}]\n")
    f.write('\n')
