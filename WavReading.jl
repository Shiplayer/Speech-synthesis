using WAV;
using PyPlot
using PyCall

WavPath = "data/orig/arctic_a0001.wav"

y, fs = wavread(WavPath)
print("$fs\n")
#x = [y[(i-1) * 2 + 1] for i=1:(div(length(y),2))]
#y_new = [y[(i - 1) * 2 + 2] for i=1:(div(length(y),2))]
plot(y, "r")
show()
print("ploted\n")
#print(string(typeof(x), " ", typeof(y_new), "\n"))
#plot(x=[y[(i-1) * 2 + 1] for i=1:(div(length(y),2))], y=[y[(i - 1) * 2 + 2] for i=1:(div(length(y),2))], Geom.point, Geom.line)
#fs = fs/2
#wavplay(y, fs)


