def main() bound [x]
label entry: PHI []
    x = call f(1);
    x = call +(2, x);
    return x;
fed

def f(x) bound [b]
label entry: PHI []
    b = call = (b, 0);
    if b goto is_float goto is_int;
label is_float: PHI []
    return 3.0;

label is_int: PHI []
    return 4;
fed

END.

