# Dynjit: General Purpose Python JIT

See running `examples/` or documents at `docs/`. 
 
## Overview
```python

from jit import types
from jit.pe import Compiler, DEBUG
from timeit import timeit

c = Compiler()

# '__fix__' is required for specifying constant global references
__fix__ = [
    "int",
    "float",
    "str",
    "isinstance",
    "pp",    
    "one",
]

# print output dynjit ir
c.debug.add(DEBUG.print_dynjit_ir)

# `@c.aware` tells the compiler this function is allowed to jit.
@c.aware
def one(x):
    if isinstance(x, float):
        return 1.0
    elif isinstance(x, str):
        return "-"
    elif isinstance(x, int):
        return 1


@c.aware
def pp(x, n):
    j = 0
    s = x
    _1 = one(x)
    while j < n:
        s = s + _1
        j = j + 1
    return s

pp_float = c.optimize_by_args(pp, 0.0, 10)
print(pp_float(0.0, 10))
print(pp(0.0, 10))


print(
    timeit("pp(0.0, 100)", globals=dict(pp=pp_float), number=1000000),
    "s/1000000 call",
)
# 3.5285782999999995 s/1000000 call

print(
    timeit("pp(0.0, 100)", globals=dict(pp=pp), number=1000000),
    "s/1000000 call",
)
# 8.9750375 s/1000000 call
```

## Notes

Dynjit so far does no object unboxing, so the speed up wouldn't be that dramatic.
The good side is Dynjit brings a **safe** and **robust** speed up to CPython that semantics is kept as-is,
e.g., Python integers are actually big integers, and dynjit wouldn't convert them to int64_t.

This makes dynjit works well with C extensions.

## Limitations

Due to the lack of efforts, so far several language constructs are not supported:
- Python closures:
    
    lack of this is mainly due to the difficulty of escape analysis, so that we cannot infer the types of closure cells.
    you should use `from jit.ll.closure import Closure` to achieve efficient closures:
    
    ```python
    @c.aware
    def f(x):
      return Closure(x, lambda cell, y: cell + y)
    ``` 
- default arguments, variadic arguments, keyword arguments

    too heavy for individual :), and you can actually avoid them or
    achieve them via mixing code with non-JIT Python code.


## User Assumptions for Optimizations

TODO