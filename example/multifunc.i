def main() bound [a, b]
label entry: PHI []
    a = true;
    b = call f(a);
    return b;
fed

def f(x) bound []
label entry: PHI []
    if x goto isint goto isfloat;

label isint: PHI []
    return 1;

label isfloat: PHI []
    return 1.0;
fed

END.