using WAV;
using PyPlot
using PyCall

WavPath = "data/orig/arctic_a0001.wav"

y, fs = wavread(WavPath)
print("$fs\n")
print(typeof(y))
#x = [y[(i-1) * 2 + 1] for i=1:(div(length(y),2))]
#y_new = [y[(i - 1) * 2 + 2] for i=1:(div(length(y),2))]
#X = Array{Float64}(1,length(y))
#for i=1:length(y)
#	X[i] = 0
#	for j=0:(length(y) - 1)
#		X[i] += abs(y[j + 1] * e^(- 2 * pi * im * j * (i - 1) / length(y)))
#	end 
#end
m = length(y)
n = 2^(nextpow2(m));
print(n)
X = fft(y, n)
f = (0:n-1)*(fs/n)
power = X.*conj(y)/n
plot(f,power)
show()
plot(y, "r")
show()
#print(y)
#print(X)
print("ploted\n")
#print(string(typeof(x), " ", typeof(y_new), "\n"))
#plot(x=[y[(i-1) * 2 + 1] for i=1:(div(length(y),2))], y=[y[(i - 1) * 2 + 2] for i=1:(div(length(y),2))], Geom.point, Geom.line)
#fs = fs/2
#wavplay(y, fs)


