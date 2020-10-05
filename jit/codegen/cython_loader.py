import tempfile
import sys
import pyximport
from pathlib import Path

pyximport.install()

JIT_DATA_DIR = Path(tempfile.TemporaryDirectory(prefix="restrain").name)
JIT_DATA_DIR.mkdir()
sys.path.append(str(JIT_DATA_DIR))

jit_func_cnt = 0


def compile_module(source_code):
    # TODO:
    # 1. tempfile.TemporaryDirectory will close unexpectedly before removing the generated module.
    #   Since that we don't delete the temporary dir as a workaround.
    # 2. thread safe
    global jit_func_cnt

    filepath = JIT_DATA_DIR / f"dynjit__{jit_func_cnt}.pyx"
    with filepath.open("w") as f:
        f.write(source_code)
    jit_func_cnt += 1
    mod = __import__(filepath.with_suffix("").name)
    return mod
