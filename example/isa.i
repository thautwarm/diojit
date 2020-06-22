def main() bound [x, y]
label entry: PHI []
    x = 1;
    y = call f(x);
    return y;
fed

def f(x) bound [b, i, j]
label entry: PHI []
    i = call + (0, 0);
    j = call + (0, 0);
    b = call = (0, 0);
    goto loop_check;
label loop_check: PHI [
    loop_check: i <- j
]
    b = call = (i, 10);
    j = call + (i, 1);
    if b goto end goto loop_check;

label end: PHI []
    j = (x, x);
    return j;
fed

END.

