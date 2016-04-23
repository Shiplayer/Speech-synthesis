using PyPlot
using WAV
using MFCC

function splitArrayq(x)
	new_channel = Array{Float64, 1}()
	new_other_channel = Array{Float64, 1}()
	points = Array{Int64, 1}()
	flag = 1
	count = 1
	for i = 1:size(x, 1)
		if(abs(x[i, 1]) > 0.04)
			if(flag == 1)
				push!(points, size(new_channel)[1] + 1)
				flag = 0
				count = 0
			end
			push!(new_channel, x[i, 1])
			push!(new_other_channel, x[i, 2])
		elseif(count <= 500)
			count = count + 1
			if(flag == 0)
				push!(new_channel, x[i, 1])
				push!(new_other_channel, x[i, 2])
			end
		elseif(count > 500)
			count = count + 1
			if(flag == 0)
				push!(points, size(new_channel)[1])
				flag = 1
			end
		end	
	end
	print(size(new_channel, 1), " ", size(new_other_channel, 1), "\n")
	origin = Array{Float64, 2}(size(new_channel)[1], 2)
	for i = 1:size(origin, 1)
		origin[i, 1] = new_channel[i]
		origin[i, 2] = new_other_channel[i]
	end
	return origin, points
end

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


coordinates, fs = wavread(WavPath, 14000)
x, points = splitArrayq(coordinates)
print(points[1], " ", points[2], "\n")
print(length(x), "\n")
x_words = Array{Float64, 1}()
x_words_other_channel = Array{Float64, 1}()
if(size(points)[1] > 2)
	for i = points[1]:points[2]
		push!(x_words, x[i, 1])
		push!(x_words_other_channel, x[i, 2])
#		x_words[i, 1], x_words[i, 2] = x[i, 1], x[i, 2]
	end
end
words = Array{Float64, 2}(length(x_words), 2)
for i=1:length(x_words)
	words[i, 1] = x_words[i]
	words[i, 2] = x_words_other_channel[i]
end

plot(coordinates, "r")
show()
#wavplay(words, fs/2)
#=
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

function f(m)
	
end

function B(b)
	return 700*(exp(b/1125) - 1)
end
=#
