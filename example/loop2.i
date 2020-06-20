def main(x: @bool, y: @int, z: @int) bound [a, b, c, d]
label entry: PHI []
    a = true;
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