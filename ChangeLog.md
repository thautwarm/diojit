## 0.1.2(2/5/2021)

- The JIT compiler is now able to optimise selection sort using lists(40% speed up).

  **Experiments have shown that if we can have type-parameterised lists, we can have
  a performance gain in a factor of 600%.**

## 0.1.4.1(2/5/2021)

- RC analysis.
   
  Previously, `def f(x): x = g(x)` can cause segmentfault due to unexpected deallocation.

  We now added analysis for reference counting in Python side, greatly reducing redundant RC
  operations at runtime.
