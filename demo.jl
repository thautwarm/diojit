import Libdl
dll = Libdl.dlopen("libpython3.8")
Py = Ptr{Cvoid}
err_print = Libdl.dlsym(dll, :PyErr_Print)
init = Libdl.dlsym(dll, :Py_Initialize)
comp = Libdl.dlsym(dll, :Py_CompileString)
peval = Libdl.dlsym(dll, :PyEval_EvalCode)
new_dict = Libdl.dlsym(dll, :PyDict_New)

ccall(init, Cvoid, ())
ccall(err_print, Cvoid, ())
macro c_str(s)
   quote
   println("start making char*")
   arr = UInt8[collect($s)...]
       buf = Libc.malloc((length(arr) + 1) * sizeof(UInt8))
   buf = reinterpret(Ptr{UInt8}, buf)
   for i in eachindex(arr)
       unsafe_store!(buf, arr[i], i)
   end
   unsafe_store!(buf, UInt8(0), lastindex(arr) + 1) 
   println("end")
   buf
   end
end

s1, s2 = c"print(114514)", c"a.py"
pycode = ccall(
    comp,
    Ptr{Cvoid},
    (Ptr{UInt8}, Ptr{UInt8}, Cint),
    s1, s2, 257
)

empty_scope = ccall(new_dict, Py, ())
ccall(peval, Py, (Py, Py, Py), pycode, empty_scope, empty_scope)

ccall(err_print, Cvoid, ())

fin = Libdl.dlsym(dll, :Py_Finalize)
ccall(fin, Cvoid, ())
println(:ok)

