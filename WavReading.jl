using WAV;
using PyPlot
using PyCall

WavPath = "data/orig/arctic_a0001.wav"

function unwrap(v, inplace=false)
  # currently assuming an array
  unwrapped = inplace ? v : copy(v)
  for i in 2:length(v)
    while unwrapped[i] - unwrapped[i-1] >= pi
      unwrapped[i] -= 2pi
    end
    while unwrapped[i] - unwrapped[i-1] <= -pi
      unwrapped[i] += 2pi
    end
  end
  return unwrapped
end

unwrap!(v) = unwrap(v, true)

y, fs = wavread(WavPath, 50000)
fs = fs / 2
print("$fs\n")
X =abs(fft(y))
plot(X, abs(y*100), ".")
show()
#=for i=(length(X) - 20000):length(X)
	X[i] = 0
end
for i=1:20000
	X[i] = 0
end
=#

#========================================================================== 
print(typeof(y))
x = [y[(i-1) * 2 + 1] for i=1:(div(length(y),2))]
y_new = [y[(i - 1) * 2 + 2] for i=1:(div(length(y),2))]
X = Array{Float64}(1,length(y))
for i=1:length(y)
	X[i] = 0
	for j=0:(length(y) - 1)
		X[i] += abs(y[j + 1] * e^(- 2 * pi * im * j * (i - 1) / length(y)))
	end 
end
m = 
print(string(m, " ", length(y), "\n"))
n = 2^(nextpow2(m));
print(string(n, "\n"))
X = fftshift(y)
f = (0:n-1)*(fs/n)
power = X.*conj(y)/n
==========================================================================#

#========================================================================== 
m = 1024
n = 2^(nextpow2(m))
X=fft(x,n)
f = (0:n-1) * (fs/n)
power = y.*conj(y)/n
plot(X,power)
show()
==========================================================================#

#n = 1:100
#plot(y,"r")
#show()
X = abs(fft(y))
#for i=1:length(X)
#	X[i]=X[i] * (0.54 - 0.46*cos(2* pi * i/(length(X) - 1)))
#end
for i=1:length(X)
	if(X[i] > 100) 
		print(i, " index ", X[i], "\n")
	end
end
#plot(abs(X), y,"r")
#show()
#=plot(abs(y), abs(X), "r")
plot(y, "r")
show()
hist(abs(X), abs(y) * 100)
show()
plot(y, X, "r")
show()
plot(abs(y), X, "r")
show()
plot(X, y, "r")
show()
plot(abs(X), y, "r")
show()
plot(X, abs(y), "r")
show()
plot(abs(X), abs(y), "r")
show()=#
#========================================================================== 
print(y)
print(X)
print("ploted\n")
print(string(typeof(x), " ", typeof(y_new), "\n"))
plot(x=[y[(i-1) * 2 + 1] for i=1:(div(length(y),2))], y=[y[(i - 1) * 2 + 2] for i=1:(div(length(y),2))], Geom.point, Geom.line)
fs = fs/2
==========================================================================#
#wavplay(y, fs)


