## DIO-JIT: General-purpose Python JIT


Important: DIO-JIT now works for Python >= 3.9.

<details><summary>Install Instructions</summary>
<p>

<details><summary>Step 1: Install Julia as an in-process native code compiler for DIO-JIT</summary>
<p>

There are several options for you to install Julia:

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

`pip install diojit`

</p>
</details>

</p>
</details>

Usage from Python side is quite similar to that from Numba.
```python
import diojit
from math import sqrt
@diojit.jit(fixed_references=["sqrt", "str", "int", "isinstance"])
def hypot(x, y):
    if isinstance(x, str):
        x = int(x)

    if isinstance(y, str):
        y = int(y)

    return sqrt(x ** 2 + y ** 2)

specialized_hypot = diojit.jit_spec_call(hypot, diojit.oftype(int), diojit.oftype(int))
specialized_hypot(1, 2) # 30% faster than CPython
```

DIO-JIT is a method JIT driven by abstract interpretation and call-site specialisation.
Abstract interpretation is done by the compiler (`jit.absint.abs`).
You can register new specialisation rules(and see examples) from (`jit.absint.prescr`).

We're able to optimise anything!

## Add a specialisation rule for `list.append`

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

@jit.jit
def append3(xs, x):
    xs.append(x)
    xs.append(x)
    xs.append(x)

jit_append3 = jit.jit_spec_call(append3, jit.oftype(list), jit.Top)
xs = [1]
jit_append3(xs, 3)
print("test jit func, [1] append 3 for 3 times:", xs)
xs = []
print("pure py func time:", timeit.timeit("f(xs, 1)", globals=dict(f=append3, xs=xs), number=10000000),)
xs = []
print("diojit func time:", timeit.timeit("f(xs, 1)", globals=dict(f=jit_append3, xs=xs), number=10000000),)
```

2. Julia Side:
    - https://github.com/thautwarm/DIO.jl/blob/6e2258d19fe87f81b3f78589ec28209eb24ee55a/src/dynamic.jl#L46
    - https://github.com/thautwarm/DIO.jl/blob/6e2258d19fe87f81b3f78589ec28209eb24ee55a/src/dynamic.jl#L77-L81

You can either do step 2) at Python side(for users other than DIO-JIT developers):
```python
import diojit as jit
jl_implemented_intrinsic = b"""
function PyList_Append(lst::Ptr, elt::PyPtr)
    ccall(PyAPI.PyList_Append, Cint, (PyPtr, PyPtr), lst, elt) === Cint(-1)
end
DIO.DIO_ExceptCode(::typeof(PyList_Append)) = Cint(-1)
"""
libjl = jit.runtime.julia_rt.get_libjulia()
libjl.jl_eval_string(jl_implemented_intrinsic)
```

You immediately get a >**100%** time speed up:

```
test jit func, [1] append 3 for 3 times: [1, 3, 3, 3]
pure py func time: 2.9825069
jit func time: 1.4520723000000002
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

    We recommend your create a bound object to simulate fast closures **after we support variadic arguments**:

    ```python
    class Closure:
        def __init__(self, f, cells: tuple):
            self.cells = cells
            self.f = f
        def __call__(self, *args):
            return self.f(self.cells, *args)
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

    <details><summary>Possibility?</summary>
    <p>
    
    Recently we found CPython's newly(`:)`) added feature `Dict.ma_version_tag` might be used to automatically notifying JITed functions to re-compile when the global references change.

    More research is required.

    </p>
    </details>

6. Missing Line number in debug information?

    Sorry, the efforts are limited. We will do this at a more formal release.

## Contributions

1. Add more prescribed specialisation rules at `jit.absint.prescr`: for instance.
2. TODO
