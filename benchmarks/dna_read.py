"""
[Python39]
jit: 7.4767213
pure py: 7.8394832

[Python38]
7.8734842
8.994623599999999
"""
import sys, string
import requests
from io import BytesIO
from tempfile import mktemp
import timeit

import diojit as jit
from diojit.codegen.julia import splice
from diojit.runtime.julia_rt import check_jl_err, get_libjulia

libjl = get_libjulia()
contents = requests.get(
    r"https://raw.githubusercontent.com/dundee/pybenchmarks/master/bencher/data/revcomp-input1000.txt"
).text.encode()
table = bytes.maketrans(
    b"ACBDGHK\nMNSRUTWVYacbdghkmnsrutwvy",
    b"TGVHCDM\nKNSYAAWBRTGVHCDMKNSYAAWBR",
)


def jl_eval(s: str):
    libjl.jl_eval_string(s.encode())
    check_jl_err(libjl)


@jit.jit(fixed_references=["len"])
def show(out_io: bytearray, seq):
    # FIXME: optimisation point
    seq_ = (b"".join(seq)).translate(table)[::-1]
    i = 0
    n = len(seq_)
    while i < n:
        out_io.extend(seq_[i : i + 60])
        i += 60


# @jit.jit
def main(out_io: bytearray):
    in_io = BytesIO(contents)
    seq = []
    for line in in_io:
        if line[0] in b">;":
            show(out_io, seq)
            out_io.extend(line)
            del seq[:]
        else:
            seq.append(line[:-1])
    show(out_io, seq)
    return out_io


@jit.jit(fixed_references=["next", "BytesIO", "show"])
def main2(out_io: bytearray):
    in_io = BytesIO(contents)
    seq = []
    while True:
        line = next(in_io, None)
        if line is None:
            break
        if line[0] in b">;":
            show(out_io, seq)
            out_io.extend(line)
            del seq[:]
        else:
            seq.append(line[:-1])
    show(out_io, seq)
    return out_io


# @jit.jit
# def b():
#     return [print, set, list]
# for i in range(1000):
#     print(jit.jit_spec_call(b)())
# b()

jit_main = jit.jit_spec_call(
    main2,
    jit.oftype(bytearray),
    print_dio_ir=print,
)
# raise
#
x = bytearray()
jl_eval(f"J_main2_0({splice(x)})")
# raise
print(main(bytearray()) == jit_main(bytearray()))
print(
    timeit.timeit(
        "main(bytearray())",
        number=100000,
        globals=dict(main=jit_main),
    ),
)

print(
    timeit.timeit(
        "main(bytearray())",
        number=100000,
        globals=dict(main=main),
    ),
)
