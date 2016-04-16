var = ccall((:test, "./cDir/test.so"), Ptr{UInt8}, ())
print(unsigned(var), "\n")
print(typeof(var),"\n")
#print(typeof(var), " ", bytestring(var), "\n")
