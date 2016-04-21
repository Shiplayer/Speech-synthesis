using PyPlot
using WAV

WavPath = "data/orig/arctic_a0001.wav"

coordinates, fs = wavread(WavPath, 60000)
x, y = Array{Float32,1}(), Array{Float32,1}()
print(typeof(coordinates))
print(size(coordinates,1), " ", size(coordinates,2), "\n")
#for i = 1 : size(coordinates, 1)
#	push!(x, coordinates[i ,1])
#	push!(y, coordinates[i, 2])
#	print("coordinates[", i ,", 1] = ", coordinates[i,1], " ", "coordinates[", i, ",2] = ", coordinates[i,2], "\n")
#end
new_coordinates = Array{Float64, 2}(size(coordinates, 1) * 3, size(coordinates, 2) * 3)
X = fft(coordinates)
print(size(X, 1), " ", size(X, 2), "\n")
x = Array{Float64, 2}(size(X, 1) * 3, size(X, 2) * 3)
print(x[1, 1])
for i = 1:size(X, 1)
	if(abs(X[i, 1]) < 1000)
		x[i * 3 - 1, 1] = abs(X[i, 1])
		x[i * 3 - 1, 2] = abs(X[i, 2])
		new_coordinates[i * 3 - 1, 1], new_coordinates[i * 3 - 1, 2] = coordinates[i, 1], coordinates[i, 2]
		x[i * 3 - 2, 1], x[i * 3 - 2, 2] = abs(X[i ,1]), abs(X[i, 2])
		new_coordinates[i * 3 - 2, 1], new_coordinates[i * 3 - 2, 2] = 0, 0
		x[i * 3, 1], x[i * 3, 2] = abs(X[i, 1]), abs(X[i, 2])
		new_coordinates[i * 3, 1], new_coordinates[i * 3, 2] = 0, 0 
	else
		x[i * 3, 1], x[i * 3, 2] = 0, 0
		x[i * 3 - 1, 1], x[i * 3 - 1, 2] = 0, 0
		x[i * 3 - 2, 1], x[i * 3 - 2, 2] = 0, 0
		new_coordinates[i * 3, 1], new_coordinates[i * 3, 2] = 0, 0 
		new_coordinates[i * 3 - 1, 1], new_coordinates[i * 3 - 1, 2] = 0, 0 
		new_coordinates[i * 3 - 2, 1], new_coordinates[i * 3 - 2, 2] = 0, 0 
	end
end

plot(abs(x), abs(new_coordinates * 100), "r", linewidth=1.5)
show()
