using PyPlot
using WAV
#=
	интересный
=#
wav = "data/orig/arctic_a0001.wav"

#=y, fs = wavread(wav)
print(length(y), "\n")
print(size(y,1), " ", size(y, 2), "\n")
#print(y[(length(y)/2):(length(y)/2 + 30), "\n")
for i=(div(length(y),2) - 10):(div(length(y),2) + 10)
	print(y[i], "\n")
end
y, fs = wavread(wav, length(y)/2 + 1)
print(length(y)/2, "\n")
plot(y)
show()=#


