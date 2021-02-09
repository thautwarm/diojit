## DIO-JIT: General-purpose Python JIT

[![中文README](https://img.shields.io/badge/i18n-%E4%B8%AD%E6%96%87%E6%96%87%E6%A1%A3-teal)](https://github.com/thautwarm/diojit/blob/master/README.zh_CN.md) [![PyPI version shields.io](https://img.shields.io/pypi/v/diojit.svg)](https://pypi.python.org/pypi/diojit/) 
[![JIT](https://img.shields.io/badge/cpython-3.8|3.9-green.svg)](https://pypi.python.org/pypi/diojit/)

Important:

1. DIO-JIT now works for Python >= 3.8. We heavily rely on the `LOAD_METHOD` bytecode instruction.
2. DIO-JIT is not production-ready. a large number of specialisation rules are required to make DIO-JIT batteries-included.
3. This document is mainly provided for prospective developers. Users are not required to write any specialisation rules, which means that users need to learn nothing but `@jit.jit` and `jit.spec_call`.

### Benchmark

| Item  | PY38  | JIT PY38   | PY39   | JIT PY39  |
|---|---|---|---|---|
| [BF](https://github.com/thautwarm/diojit/blob/master/benchmarks/brainfuck.py)   | 265.74  | 134.23  | 244.50  |  140.34 |
| [append3](https://github.com/thautwarm/diojit/blob/master/benchmarks/append3.py)  | 23.94  |  10.70 | 22.29  | 11.21  |
| [DNA READ](https://github.com/thautwarm/diojit/blob/master/benchmarks/dna_read.py)  | 16.96  | 14.82  | 15.03   | 14.38  |
| [fib(15)](https://github.com/thautwarm/diojit/blob/master/benchmarks/fib.py) | 11.63  | 1.54  | 10.41   | 1.51  |
| [hypot(str, str)](https://github.com/thautwarm/diojit/blob/master/benchmarks/hypot.py)  | 6.19  | 3.87  | 6.53  | 4.29  |
| [selectsort](https://github.com/thautwarm/diojit/blob/master/benchmarks/selection_sort.py)  | 46.95  | 33.88  | 38.71  | 29.49  |
| [trans](https://github.com/thautwarm/diojit/blob/master/benchmarks/trans.py)  | 24.22  | 7.79  |  23.23 | 7.71  |

The bechmark item "DNA READ" does not show a significant performance gain, this is because "DNA READ" heavily uses `bytearray` and `bytes`, whose specialised C-APIs
are not exposed. In this case, although the JIT can infer the types, we have to fall back to CPython's default behaviour, or even worse: after all, the interpreter can access internal things, while we cannot.


P.S:
DIO-JIT can do very powerful partial evaluation, which is disabled in default but you can
leverage it in your domain specific tasks. Here is an example of achieving **500x** speed up aginst pure Python: [fibs.py](https://github.com/thautwarm/diojit/blob/master/slide-examples/fibs.py) 


## Install Instructions

<details><summary>Step 1: Install Julia as an in-process native code compiler for DIO-JIT</summary>
<p>

There are several options for you to install Julia:

- [scoop](http://scoop.sh/) (Windows)
- [julialang.org](https://julialang.org/downloads) (recommended for Windows users)
- [jill.py](https://github.com/johnnychen94/jill.py):
    
    `pip install jill && jill install 1.6 --upstream Official`

- [jill](https://github.com/abelsiqueira/jill) (Mac and Linux only!):
    
    `bash -ci "$(curl -fsSL https://raw.githubusercontent.com/abelsiqueira/jill/master/jill.sh)"`
</p>
</details>

<details><summary>Step 2: Install DIO.jl in Julia</summary>
<p>

Type `julia` and open the REPL, then

```julia
julia>
# press ]
pkg> add https://github.com/thautwarm/DIO.jl
# press backspace
julia> using DIO # precompile
```

</p>
</details>

<details><summary>Step 3: Install Python Package</summary>
<p>

`pip install git+https://github.com/thautwarm/diojit`

</p>
</details>

</p>
</details>

<details><summary>How to fetch latest DIO-JIT?(if you have installed DIO)</summary>

<p> 

```
pip install -U diojit
julia -e "using Pkg; Pkg.update(string(:DIO));using DIO"
``` 

</p>
</details>

Usage from Python side is quite similar to that from Numba.
```python
import diojit
from math import sqrt
# eagerjit: assuming all global references are fixed
@diojit.eagerjit
def fib(a):
    if a <= 2:
        return 1
    return fib(a + -1) + fib(a + -2)

jit_fib = diojit.spec_call(fib, diojit.oftype(int), diojit.oftype(int))
jit_fib(15) # 600% faster than pure python
```

It might look strange to you that we use `a + -1` and `a + -2` here.

Clever observation! And that's the point!

DIO-JIT relies on specilisation rules. We have written one for additions, more specifically, `operator.__add__`: [specilisation for `operator.__add__`](https://github.com/thautwarm/diojit/blob/175aab5f4cb65fee923b9f6cb97c256252fc49f5/diojit/absint/prescr.py#L226).

However, due to the bandwidth limitation, rules for `operator.__sub__` is not implemented yet.

(P.S: [why `operator.__add__`](https://github.com/thautwarm/diojit/blob/3ceb9513377234f476566f70792632ce08c13373/diojit/stack2reg/translate.py#L30).)

Although specilisation is common in the scope of optimisation, unlike many other JIT attempts, DIO-JIT doesn't need to
hard encode rules at compiler level. The DIO-JIT compiler implements the skeleton of abstract interpretation, but concrete
rules for specialisation and other inferences can be added within Python itself in an extensible way!
  
See an example below.


## Contribution Example: Add a specialisation rule for `list.append`

1. Python Side:

```python
import diojit as jit
import timeit
jit.create_shape(list, oop=True)
@jit.register(list, attr="append")
def list_append_analysis(self: jit.Judge, *args: jit.AbsVal):
    if len(args) != 2:
        # rollback to CPython's default code
        return NotImplemented
    lst, elt = args

    return jit.CallSpec(
        instance=None,  # return value is not static
        e_call=jit.S(jit.intrinsic("PyList_Append"))(lst, elt),
        possibly_return_types=tuple({jit.S(type(None))}),
    )
```


`jit.intrinsic("PyList_Append")` mentioned in above code means the intrinsic provided by the Julia codegen backend.
Usually it's calling a CPython C API, but sometimes may not.

No matter if it is an existing CPython C API, we can implement intrinsics in Julia.


- [import PyList_Append symbol](https://github.com/thautwarm/DIO.jl/blob/c3ec304645437da6bb02c9e5acb0c91e5e3800a8/src/symbols.jl#L53)

- [generate PyList_Append calling convention](https://github.com/thautwarm/DIO.jl/blob/5fa79357798ff3eaee561d14d4f04a271213282c/src/dynamic.jl#L120):
    
    
    ```julia
    @autoapi PyList_Append(PyPtr, PyPtr)::Cint != Cint(-1) cast(_cint2none) nocastexc
    ```
    
    As a consequence, we automatically generate an instrinsic function for DIO-JIT. This intrinsic function
    is capable of handling CPython exception and reference counting.  

You can either do step 2) at Python side. It might looks more intuitive.

```python
import diojit as jit
from diojit.runtime.julia_rt import jl_eval
jl_implemented_intrinsic = """
function PyList_Append(lst::Ptr, elt::PyPtr)
    if ccall(PyAPI.PyList_Append, Cint, (PyPtr, PyPtr), lst, elt) == -1
        return Py_NULL
    end
    nothing # automatically maps to a Python None
end
DIO.DIO_ExceptCode(::typeof(PyList_Append)) != Py_NULL
"""
jl_eval(jl_implemented_intrinsic)
```

You immediately get a >**100%** time speed up:

```python
@jit.jit
def append3(xs, x):
    xs.append(x)
    xs.append(x)
    xs.append(x)

jit_append3 = jit.spec_call(append3, jit.oftype(list), jit.Top) # 'Top' means 'Any'
xs = [1]
jit_append3(xs, 3)

print("test jit_append3, [1] append 3 for 3 times:", xs)
# test jit func, [1] append 3 for 3 times: [1, 3, 3, 3]

xs = []
%timeit append3(xs, 1)
# 293 ns ± 26.2 ns per loop (mean ± std. dev. of 7 runs, 1000000 loops each)

xs = []
%timeit jit_append3(xs, 1)
# 142 ns ± 14.9 ns per loop (mean ± std. dev. of 7 runs, 10000000 loops each)
```

## Why Julia?

We don't want to maintain a C compiler, and calling `gcc` or others will introduce cross-process IO, which is slow.
We prefer compiling JITed code with LLVM, and **Julia is quite a killer tool for this use case**.

## Current Limitations

1. Support for `*varargs` and `**kwargs` are not ready: we do can immediately support them with very tiny JIT performance gain, but considering backward compatibility we decide not to do this.

2. Exception handling is not yet supported inside JIT functions.
    
    <details><summary>Why?</summary>
    <p>
    
    We haven't implemented the translation from exception handling bytecode to untyped DIO IR (`jit.absint.abs.In_Stmt`).
    
    </p>
    </details>
    
    <details><summary>Will support?</summary>
    <p>
    
    Yes.

    In fact, now a callsite in any JIT function can raise an exception. It will not be handled by JIT functions, instead, it is lifted up to the root call, which is a pure Python call.

    Exception handling will be supported when we have efforts on translating CPython bytecode about exception handling into untyped DIO IR (`jit.absint.abs.In_Stmt`).

    P.S: This will be finished simultaneously with the support for `for` loop.

    </p>
    </details>

3. Support for `for` loop is missing.

    <details><summary>Why?</summary>
    <p>

    Firstly, in CPython, `for` loop relies on exception handling, which is not supported yet.

    Secondly, we're considering a fast path for `for` loop, maybe proposing a `__citer__` protocol for faster iteration for JIT functions, which requires communications with Python developers.

    </p>
    </details>

    <details><summary>Will support?</summary>
    <p>
    
    Yes.

    This will be finished simultaneously with support for exception handling (faster `for` loop might come later).
    
    </p>
    </details>

4. Closure support is missing.

    <details><summary>Why?</summary>
    <p>

    In imperative languages, closures use *cell* structures to achieve mutable free/cell variables.

    However, a writable cell makes it hard to optimise in a dynamic language.

    We recommend using `types.MethodType` to create immutable closures，which can be highly optimised in DIO-JIT(near future).
    
    ```python
    import types
    def f(freevars, z):
            x, y = freevars
            return x + y + z
    
    def hof(x, y):
        return types.MethodType(f, (x, y))
    ```

    </p>
    </details>

    <details><summary>Will support?</summary>
    <p>
    
    Still yes. However, don't expect much about the performance gain for Python's vanilla closures.

    </p>
    </details>

5. Specifying fixed global references(`@diojit.jit(fixed_references=['isinstance', 'str', ...]`) too annoying?

    Sorry, you have to. We are thinking about the possibility about automatic JIT covering all existing CPython code, but the biggest impediment is the volatile global variables.

    You might use `@eagerjit`, and in this case you'd be cautious in making global variables unchangeable.

    <details><summary>Possibility?</summary>
    <p>
    
    Recently we found CPython's newly(`:)`) added feature `Dict.ma_version_tag` might be used to automatically notifying JITed functions to re-compile when the global references change.

    More research is required.

    </p>
    </details>

## Contributions

1. Add more prescribed specialisation rules at `jit.absint.prescr`.
2. TODO

## Benchmarks

Check `benchmarks` directory.