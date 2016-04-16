using PyPlot
using WAV

WavPath = "data/orig/arctic_a0001.wav"

coordinates, fs = wavread(WavPath)
x, y = Array{Float32,1}(), Array{Float32,1}()
print(size(coordinates,1), " ", size(coordinates,2), "\n")
for i = 1 : size(coordinates, 1)
	push!(x, coordinates[i ,1])
	push!(y, coordinates[i, 2])
#	print("coordinates[", i ,", 1] = ", coordinates[i,1], " ", "coordinates[", i, ",2] = ", coordinates[i,2], "\n")
end

plot(x, "r")
show()
plot(y,"r")
show()
