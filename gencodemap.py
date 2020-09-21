import opcode
import os
dir = "jit"
with open(os.path.join(dir, "opname.py"), 'w') as f:
    f.write("import opcode\n")
    for each in opcode.opmap:
        f.write(f"{each} = opcode.opmap[{each!r}]\n")
    f.write('\n')
