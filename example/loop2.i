def main() bound [x, y, z, a, b, c, d]
label entry: PHI []
    x = true;
    y = 1;
    z = 2;
    a = x;
    if a goto loop goto ret;
label loop: PHI [ entry: c <- a ]
    goto end;
label end: PHI [ ]
    d = z;
    if true goto ret goto loop;
label ret: PHI [entry: c <- x | end: c <- d]
    return c;
fed
END.