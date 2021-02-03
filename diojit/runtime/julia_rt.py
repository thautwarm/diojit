import subprocess
import os
import signal
import warnings
import ctypes
import sys
import posixpath
import importlib
import json
import julia.libjulia as jl_libjulia
from json import dumps
from julia.libjulia import LibJulia
from julia.juliainfo import JuliaInfo
from julia.find_libpython import find_libpython
from ..absint.abs import Out_Def as _Out_Def
from ..codegen.julia import Codegen, u64o

GenerateCache = _Out_Def.GenerateCache


def get_libjulia():
    global libjl
    if not libjl:
        libjl = startup()
    return libjl


class RichCallSubprocessError(subprocess.CalledProcessError):
    def __str__(self):
        if self.returncode and self.returncode < 0:
            try:
                return "Command '%s' died with %r." % (
                    self.cmd,
                    signal.Signals(-self.returncode),
                )
            except ValueError:
                return "Command '%s' died with unknown signal %d." % (
                    self.cmd,
                    -self.returncode,
                )
        else:
            return (
                "Command '%s' returned non-zero exit status %d: %s"
                % (self.cmd, self.returncode, self.stderr)
            )


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
        raise RichCallSubprocessError(
            retcode, [julia, "-e", "..."], stdout, stderr
        )

    stderr = stderr.strip()
    if stderr:
        warnings.warn("{} warned:\n{}".format(julia, stderr))

    args = stdout.rstrip().split("\n")

    libjl = LibJulia.from_juliainfo(JuliaInfo(julia, *args))
    libjl.jl_string_ptr.restype = ctypes.c_char_p
    libjl.jl_string_ptr.argtypes = [ctypes.c_void_p]
    libjl.jl_call1.argtypes = [ctypes.c_void_p, ctypes.c_void_p]
    libjl.jl_call1.restype = ctypes.c_void_p
    libjl.jl_eval_string.argtypes = [ctypes.c_char_p]
    libjl.jl_eval_string.restype = ctypes.c_void_p
    libjl.jl_stderr_stream.argtypes = []
    libjl.jl_stderr_stream.restype = ctypes.c_void_p
    libjl.jl_printf.argtypes = [ctypes.c_void_p, ctypes.c_char_p]
    libjl.jl_printf.restype = ctypes.c_int
    return libjl


class JuliaException(Exception):
    def __init__(self, msg):
        self.msg = msg

    def __repr__(self):
        return self.msg


def check_jl_err(libjl: LibJulia):
    if o := libjl.jl_exception_occurred():
        msg = libjl.jl_string_ptr(
            libjl.jl_call1(libjl.jl_eval_string(b"error2str"), o)
        ).decode("utf-8")
        raise JuliaException(msg)


def startup():
    global libjl
    libjl = mk_libjulia()
    libjl.init_julia()
    # DIO package already checked when getting libjulia
    libjl.jl_eval_string(
        b"function error2str(e)\n"
        b"   sprint(showerror, e; context=:color=>true)\n"
        b"end"
    )
    libjl.jl_eval_string(b"using DIO")
    check_jl_err(libjl)

    libjl.jl_eval_string(
        str.encode(
            f"const PyO = PyOType("
            f"PY_VERSION = Tuple({json.dumps(sys.version_info)}),"
            f"bool = @DIO_Obj({u64o(bool)}),"
            f"int = @DIO_Obj({u64o(int)}),"
            f"float = @DIO_Obj({u64o(float)}),"
            f"str = @DIO_Obj({u64o(str)}),"
            f"type = @DIO_Obj({u64o(type)}),"
            f"None = @DIO_Obj({u64o(None)}),"
            f"complex = @DIO_Obj({u64o(complex)}),"
            f"tuple = @DIO_Obj({u64o(tuple)}),"
            f"list = @DIO_Obj({u64o(list)}),"
            f"set = @DIO_Obj({u64o(set)}),"
            f"dict = @DIO_Obj({u64o(dict)}),"
            f"import_module = @DIO_Obj({u64o(importlib.import_module)}),"
            f")",
            encoding="utf-8",
        )
    )
    check_jl_err(libjl)

    libpython_path = posixpath.join(*find_libpython().split(os.sep))
    libjl.jl_eval_string(
        b"DIO.@setup(%s)" % dumps(libpython_path).encode("utf-8")
    )
    check_jl_err(libjl)
    libjl.jl_eval_string(b"printerror(x) = println(showerror(x))")
    check_jl_err(libjl)
    # a = libjl.jl_eval_string(
    #     b"Py_CallFunction(@DIO_Obj(%s), @DIO_Obj(%s), @DIO_Obj(%s))"
    #     % (
    #         Codegen.uint64(id(print)).encode(),
    #         Codegen.uint64(id(1)).encode(),
    #         Codegen.uint64(id(3)).encode(),
    #     )
    # )
    # check_jl_err(libjl)
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
    check_jl_err(libjl)
    return pyobj


def code_gen(print_jl=None):
    libjl = get_libjulia()
    interfaces = bytearray()
    for out_def in GenerateCache.values():
        cg = Codegen(out_def)
        interfaces.extend(cg.get_py_interfaces().encode("utf-8"))
        definition = cg.get_jl_definitions()
        if print_jl:
            print_jl(definition)
        definition = definition.encode("utf-8")
        libjl.jl_eval_string(definition)
        check_jl_err(libjl)
    if print_jl:
        print_jl(interfaces.decode("utf-8"))
    libjl.jl_eval_string(bytes(interfaces))
    check_jl_err(libjl)

    for intrin in GenerateCache:
        v = libjl.jl_eval_string(
            b"PyFunc_%s" % repr(intrin).encode("utf-8")
        )
        check_jl_err(libjl)
        intrin._callback = as_py(v)

    GenerateCache.clear()


startup()
