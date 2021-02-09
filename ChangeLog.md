## 0.2a(2/8/2021)

- Rename `jit_spec_call` to `spec_call`.
    
## 0.1.5(2/8/2021)

- Add experimental features: `@eagerjit` and `@conservativejit`.
  
  The first one assumes field types according to annotations of fields, and tries to make all
  methods jit-able.
  
  The second one needs manually specifying jit-able methods, and does not totally believe users'
  annotations to fields: a runtime type check will be generated when accessing fields.    

## 0.1.4.1(2/7/2021)

- RC analysis.
   
  Previously, `def f(x): x = g(x)` can cause segmentfault due to unexpected deallocation.

  We now added analysis for reference counting in Python side, greatly reducing redundant RC
  operations at runtime.


## 0.1.2(2/5/2021)

- The JIT compiler is now able to optimise selection sort using lists(40% speed up).

  **Experiments have shown that if we can have type-parameterised lists, we can have
  a performance gain in a factor of 600%.**

  
  

