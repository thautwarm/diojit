import diojit


@diojit.jit
def test(a):
    t = (1, 2, 3)
    i = 0
    while i < a:
        t = (t[1], t[2], t[0])
        i = i + t[0]
    return i


@diojit.jit(fixed_references=["test"])
def f(x):
    return test(x)


in_def = diojit.absint.In_Def.UserCodeDyn[test]
# in_def.show()
callspec = diojit.jit_spec_call_ir(f, diojit.Val(500))
print("return types: ", *callspec.possibly_return_types)
print("instance    : ", callspec.instance)
print("call expr   : ", callspec.e_call)
for each in reversed(diojit.absint.Out_Def.GenerateCache):
    each.show()


