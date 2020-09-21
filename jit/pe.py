from jit import CoreCPY, types


def ct2(ac):
    return types.noms.get(type(ac), types.TopT())


def ct(ac):
    if isinstance(ac, tuple):
        return types.TupleT(tuple(map(ct2, ac)))
    return ct2(ac)


def pe(G, I):
    def gensym(n):
        r = n[0]
        n[0] += 1
        return r

    counter_lbl = [0]
    counter_var = [0]
    return_types = []

    def infer(S, P):
        nonlocal G
        instr = I[P]
        if isinstance(instr, CoreCPY.Label):
            lbl = G.get((S, P))
            if not lbl:
                lbl = gensym(counter_lbl)
                G[(S, P)] = lbl
            return S, P + 1
