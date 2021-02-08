## DIO-JIT:  Python的泛用jit

[![README](https://img.shields.io/badge/i18n-English-teal)](https://github.com/thautwarm/diojit/blob/master/README.zh_CN.md) [![PyPI version shields.io](https://img.shields.io/pypi/v/diojit.svg)](https://pypi.python.org/pypi/diojit/) 
[![JIT](https://img.shields.io/badge/cpython-3.8|3.9-green.svg)](https://pypi.python.org/pypi/diojit/)

DIO-JIT是一种 method JIT, 在抽象解释和调用点特化下成为可能。抽象解释由编译器实现，而特化规则可以扩展式地注册(例见`jit.absint.prescr`)。

Important:

1. 注意, DIO-JIT目前只在Python>=3.8时工作。我们高度依赖Python 3.8之后的`LOAD_METHOD`字节码指令。
2. 在多数情况下来看，目前DIO-JIT不适合生产环境。我们还需要提供更多的特化规则，来让DIO-JIT变得开箱即用。
3. 这个文档主要是为开发者提供的。用户不需要了解如何写特化规则，只需要使用`jit.jit(func_obj)`和`jit.jit_spec_call(func_obj, arg_specs...)`。


## Benchmark

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

## 安装

<details><summary>1: 安装Julia(我们的"底层代码编译服务"提供者)</summary>
<p>

推荐以如下方式安装Julia:

- [scoop](http://scoop.sh/) (Windows)
- [julialang.org](https://julialang.org/downloads) (Windows)
- [jill.py](https://github.com/johnnychen94/jill.py) (跨平台，但安装路径不符合Windows上Unix用户习惯):
    
    `pip install jill && jill install 1.6 --upstream Official`

- [jill](https://github.com/abelsiqueira/jill) (Mac and Linux):
    
    `bash -ci "$(curl -fsSL https://raw.githubusercontent.com/abelsiqueira/jill/master/jill.sh)"`

</p>
</details>

<details><summary>2: 在Julia中安装 DIO.jl</summary>
<p>

输入 `julia` 打开REPL

```julia
julia>
# 按下 ]
pkg> add https://github.com/thautwarm/DIO.jl
# 按下 backspace 键
julia> using DIO # 预编译
```

</p>
</details>

<details><summary>3: 安装Python</summary>
<p>

`pip install git+https://github.com/thautwarm/diojit`

</p>
</details>

</p>
</details>

<details><summary>如何获取最新的DIO-JIT?(需安装过DIO-JIT)</summary>
<p>

```
pip install -U diojit
julia -e "using Pkg; Pkg.update(string(:DIO));using DIO"
``` 

</p>
</details>

从Python端使用DIO-JIT和使用Numba类似:
```python
import diojit
from math import sqrt
# eagerjit: 假设所有全局引用不变
@diojit.eagerjit
def fib(a):
    if a <= 2:
        return 1
    return fib(a + -1) + fib(a + -2)

jit_fib = diojit.jit_spec_call(fib, diojit.oftype(int), diojit.oftype(int))
jit_fib(15) # 比原生Python快600%以上
```

你可能会问, 为什么上面的代码要使用`a + -1`和`a + -2`这么迷惑的写法？

你get了重点！

我们的jit依赖于已有的特化规则。我们已经为加法，具体的说是`operator.__add__`实现了特化规则: [`operator.__add__`的特化规则](https://github.com/thautwarm/diojit/blob/05a20be3cb0bbf543f6c5d9e154f73a0071cbfa2/diojit/absint/prescr.py#L226).

(P.S: [为啥是 `operator.__add__`](https://github.com/thautwarm/diojit/blob/3ceb9513377234f476566f70792632ce08c13373/diojit/stack2reg/translate.py#L30).)

但因为个人精力有限，目前还没有为`operator.__sub__`实现对应的规则。

虽然特化是非常常见的优化技术，但与很多的Python JIT不同的是，DIO-JIT并不需要在编译器层面内建特别的优化。DIO-JIT编译器只负责实现一个抽象解释的算法，
而更具体的推导、特化规则，在Python里就可以扩展式地添加！

下面是一个例子。


## 代码贡献案例: 为`list.append`注册特化规则

步骤1：Python端如下代码

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

上面的`jit.intrinsic("PyList_Append")`指的是JIT后端提供的底层原语，它通常是调用CPython的C API。

我们可以在Julia里面实现这些底层原语。

步骤2： Julia端

- [导入PyList_Append符号](https://github.com/thautwarm/DIO.jl/blob/c3ec304645437da6bb02c9e5acb0c91e5e3800a8/src/symbols.jl#L53)

- [生成PyList_Append的调用约定](https://github.com/thautwarm/DIO.jl/blob/5fa79357798ff3eaee561d14d4f04a271213282c/src/dynamic.jl#L120):
    
    
    ```julia
    @autoapi PyList_Append(PyPtr, PyPtr)::Cint != Cint(-1) cast(_cint2none) nocastexc
    ```
    
    这样一来，我们就自动生成了一个能够处理CPython错误处理和引用计数的原语函数。

实际上，你也可以在Python端手动实现步骤2，没有宏看起来可能会更直观一些：

```python
import diojit as jit
from diojit.runtime.julia_rt import jl_eval
jl_implemented_intrinsic = b"""
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

我们立即得到大于**100%**的性能提升。

```python
@jit.jit
def append3(xs, x):
    xs.append(x)
    xs.append(x)
    xs.append(x)

jit_append3 = jit.jit_spec_call(append3, jit.oftype(list), jit.Top) # 'Top' means 'Any'
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

## 为什么要用Julia?

我们不想维护一个C编译器，并且调用`gcc`这样的操作会引入跨进程的IO。这好吗？这不好。

我们倾向于使用LLVM在运行时编译底层代码，而基于其上的Julia提供了对其底层架构的自由访问，从而**成为了运行时编译的杀手级应用**。

## 现状和限制

1. **暂**未支持不定参数和关键字参数。我们可以立刻支持它们，并提供较小的JIT性能提升。但由此可能引来后向兼容的问题，权衡之下还是暂且搁置。

2. **暂**不支持在JIT函数中处理异常.
    
    <details><summary>？？？</summary>
    <p>
    
    还未实现从相关的CPython字节码到无类型DIO IR的转译(`jit.absint.abs.In_Stmt`)

    </p>
    </details>
    
    <details><summary>会支持吗?</summary>
    <p>
    
    会的。

    实际上，目前JIT函数内部的调用可以正常抛错。这样的错误无法被JIT函数处理，而是被交给更上层。

    在我们有精力实现对应的（错误处理）字节码到无类型 DIO IR的转译后，JIT函数中将可以做错误处理。

    P.S: 这会和`for`循环的支持同时实现。

    </p>
    </details>

3. **暂**不支持`for`循环.

    <details><summary>？？？</summary>
    <p>

    首先，在CPython中，`for`循环的视线依赖错误处理，而这目前还未支持。
    
    其次，我们在考虑一个更高效的`for`循环实现，可能会提议一个`__citer__`协议用以JIT函数的优化。而这需要和Python开发者进一步探讨。

    </p>
    </details>

    <details><summary>会支持吗?</summary>
    <p>
    
    嗯。

    这会和错误处理同时实现。快速`for`可能会引入得更晚一些。

    </p>
    </details>

4. 未支持Python的原生闭包

    <details><summary>？？？</summary>
    <p>

    在命令式语言中，闭包使用一种叫`cell`的数据结构来实现可变(mutable)的自由变量(free variables)。

    然而，在动态语言里边，优化可写的闭包是一个相当困难的问题。
    
    我们建议你使用`types.MethodType`创建自由变量不可变的闭包，这是DIO-JIT（很快就能）高效优化的写法。
    
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

    <details><summary>会支持吗?</summary>
    <p>
    
    会是会的，毕竟我们的目的是覆盖所有的CPython代码。
    
    但对此不要期待很大性能提升。

    </p>
    </details>

5. 手动指定不可变全局变量太啰嗦了？(`@diojit.jit(fixed_references=['isinstance', 'str', ...]`) 

    很遗憾，你得这样。我们在考虑全自动JIT的可能性，但Python任人随意修改的全部变量是这个目标最大的阻碍。
    
    <details><summary>不写行不行?</summary>
    <p>
    
    可能会可以的。

    近期CPython优化了存储全局变量的字典。字典的内存布局多了一个名为`ma_version_tag`的数字，用以指示字典最近被写入过。这个改动可能可以用来触发JIT函数的重编译。

    这还需要更多的研究。

    </p>
    </details>

## Contributions

1. 发挥你的聪明才智，展示你对Python语义的了解，为DIO-JIT添加更多的特化规则吧！

    例见`jit.absint.prescr`。
2. TODO

## Benchmarks

康康 `benchmarks` 文件夹。
