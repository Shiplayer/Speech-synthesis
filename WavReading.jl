using PyPlot
using WAV

function transformToHistogram(x_plot, y_plot)
	x = Array{Float64, 2}(size(x_plot, 1) * 3, size(x_plot, 2) * 3)
	y = Array{Float64, 2}(size(y_plot, 1) * 3, size(y_plot, 2) * 3)
	print(x[1, 1])
	for i = 1:size(x_plot, 1)
		if(abs(x_plot[i, 1]) < 1000)
			x[i * 3 - 1, 1] = abs(x_plot[i, 1])
			x[i * 3 - 1, 2] = abs(x_plot[i, 2])
			y[i * 3 - 1, 1], y[i * 3 - 1, 2] = y_plot[i, 1], y_plot[i, 2]
			x[i * 3 - 2, 1], x[i * 3 - 2, 2] = abs(x_plot[i ,1]), abs(x_plot[i, 2])
			y[i * 3 - 2, 1], y[i * 3 - 2, 2] = 0, 0
			x[i * 3, 1], x[i * 3, 2] = abs(x_plot[i, 1]), abs(x_plot[i, 2])
			y[i * 3, 1], y[i * 3, 2] = 0, 0 
		else
			x[i * 3, 1], x[i * 3, 2] = 0, 0
			x[i * 3 - 1, 1], x[i * 3 - 1, 2] = 0, 0
			x[i * 3 - 2, 1], x[i * 3 - 2, 2] = 0, 0
			y[i * 3, 1], y[i * 3, 2] = 0, 0 
			y[i * 3 - 1, 1], y[i * 3 - 1, 2] = 0, 0 
			y[i * 3 - 2, 1], y[i * 3 - 2, 2] = 0, 0 
		end
	end
	return x, y
end

WavPath = "data/orig/arctic_a0001.wav"

coordinates, fs = wavread(WavPath, 60000)
#x, y = Array{Float32,1}(), Array{Float32,1}()
print(typeof(coordinates))
print(size(coordinates,1), " ", size(coordinates,2), "\n")
#for i = 1 : size(coordinates, 1)
#	push!(x, coordinates[i ,1])
#	push!(y, coordinates[i, 2])
#	print("coordinates[", i ,", 1] = ", coordinates[i,1], " ", "coordinates[", i, ",2] = ", coordinates[i,2], "\n")
#end
X = fft(coordinates)
print(size(X, 1), " ", size(X, 2), "\n")

x, y = transformToHistogram(X, coordinates)
plot(abs(x), abs(y * 100), "r")
show()
