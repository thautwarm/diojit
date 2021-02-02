import subprocess
import os
import warnings
import sys
import ctypes
import ntpath
import posixpath
import julia.libjulia as jl_libjulia
from json import dumps
from julia.libjulia import LibJulia
from julia.juliainfo import JuliaInfo
from julia.find_libpython import find_libpython
from ..absint.abs import Out_Def as _Out_Def
from ..codegen.julia import Codegen

GenerateCache = _Out_Def.GenerateCache


def get_libjulia():
    global libjl
    if not libjl:
        libjl = startup()
    return libjl


def mk_libjulia(julia="julia", **popen_kwargs):
    if lib := getattr(jl_libjulia, "_LIBJULIA"):
        return lib

    proc = subprocess.Popen(
        [
            julia,
            "--startup-file=no",
            "-e",
            "using DIO; DIO.PyJulia_INFO()",
        ],
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        universal_newlines=True,
        **popen_kwargs,
    )

    stdout, stderr = proc.communicate()
    retcode = proc.wait()
    if retcode != 0:
        raise subprocess.CalledProcessError(
            retcode, [julia, "-e", "..."], stdout, stderr
        )

    stderr = stderr.strip()
    if stderr:
        warnings.warn("{} warned:\n{}".format(julia, stderr))

    args = stdout.rstrip().split("\n")

    return LibJulia.from_juliainfo(JuliaInfo(julia, *args))


def check_jl_err(libjl: LibJulia):
    if o := libjl.jl_exception_occurred():
        raise EnvironmentError


def startup():
    global libjl
    libjl = mk_libjulia()
    libjl.init_julia()
    # DIO package already checked when getting libjulia
    libjl.jl_eval_string(b"using DIO")
    check_jl_err(libjl)
    libpython_path = posixpath.join(*find_libpython().split(os.sep))
    libjl.jl_eval_string(
        b"DIO.@setup(%s)" % dumps(libpython_path).encode("utf-8")
    )
    libjl.jl_eval_string(b"printerror(x) = println(showerror(x))")
    check_jl_err(libjl)
    libjl.jl_eval_string(b'println("setup correctly")')
    check_jl_err(libjl)
    libjl.jl_eval_string(b"println(Py_CallFunction)")
    check_jl_err(libjl)
    a = libjl.jl_eval_string(
        b"Py_CallFunction(@DIO_Obj(%s), @DIO_Obj(%s))"
        % (Codegen.uint64(id(print)).encode(), Codegen.uint64(id(1)).encode())
    )
    check_jl_err(libjl)
    return libjl


def as_py(res: ctypes.c_void_p):
    """
    This should be used on the return of a JIT func.
    No need to incref as it's already done by the JIT func.
    """
    libjl = get_libjulia()
    if res == 0:
        return None
    pyobj = libjl.jl_unbox_voidpointer(res)
    return pyobj


def code_gen():
    libjl = get_libjulia()
    for intrin, out_def in GenerateCache:
        cg = Codegen(out_def)
        libjl.jl_eval_string(cg.get().encode("utf-8"))


startup()
