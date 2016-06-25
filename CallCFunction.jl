numb = Array{Int32, 2}(10, 10)
for i = 1:size(numb, 1)
	numb[i, 1] = i
	numb[i, 2] = size(numb, 1) - i
	print(numb[i, 1], " ", numb[i, 2], "\n")
end
#numb = [i for i=1:10]
#var = ccall((:test, "./cDir/test.so"), Ptr{Cint}, (Ptr{Cint}, Cint), numb, 10)
#numb = convert(Array{Int32, 1}, numb)
var = ccall((:test, "./cDir/test.so"), Ptr{Cint}, (Int32, Array{Cint, 2}), 10, numb, 1)
print(typeof(var),"\n")
for i = 1:10
	print(unsafe_load(var, i), " ")
print("\n") 
end
argv = [ "a.out", "arg1", "arg2" ]
ccall((:main, "./cDir/test.so"), Int32, (Int32, Ptr{Ptr{UInt8}}), length(argv), argv)
#print(typeof(var), " ", bytestring(var), "\n")
