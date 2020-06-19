def f(x: @bool, y: @int, z: @int) bound [a, b, c, d]
label entry: PHI []
    a = 1;
    a = true;
    if a goto loop goto ret;
label loop: PHI [ entry: c <- a ]
    goto end;
label end: PHI []
    d = true;
    if d goto ret goto loop;
label ret: PHI [entry: c <- x]
    return c;
fed
END.