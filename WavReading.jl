using PyPlot
using WAV
using MFCC

function splitArrayq(x, channel = 2)
    noise = 0
    for i=1:length(x)
        noise = abs(abs(x[i, 1]) * log(2, abs(x[i, 1]))) + noise
        if(noise != NaN)
            print(noise, "\n")
        end
        print(abs(abs(x[i, 1]) * log(2, abs(x[i, 1]))), "\n")
    end
    print(noise, "\n")
    new_channel = Array{Float64, 1}()
    if(channel == 2)
        new_other_channel = Array{Float64, 1}()
    end
    points = Array{Int64, 1}()
    flag = 1
    count = 1
    flag_1 = 0
    for i = 2:size(x, 1)
        if(abs(x[i, 1]) > 0.02)
            if(flag == 1)
                push!(points, size(new_channel)[1] + 1)
                flag = 0
                count = 0
            end
            push!(new_channel, x[i, 1])
            if(channel == 2)
                push!(new_other_channel, x[i, 2])
            end
        elseif(count <= noise)
            if(abs(x[i-1, 1]) < 0.02 && flag_1 == 1)
                count = count + 1
            elseif(flag_1 == 1 && abs(x[i - 1, 1]) > 0.02)
                count = 0
                flag_1 = 0
            else
                flag_1 = 1
            end
        elseif(count > noise)
            count = count + 1
            if(flag == 0)
                push!(points, size(new_channel)[1])
                flag = 1
            end
        end 
    end
#    print("size: ", size(new_channel, 1), " ", size(new_other_channel, 1), "\n")
    if(channel == 2)
        origin = Array{Float64, 2}(size(new_channel)[1], 2)
        for i = 1:size(origin, 1)
            origin[i, 1] = new_channel[i]
            origin[i, 2] = new_other_channel[i]
        end
        return origin, points
    else
        return new_channel, points
    end
end

function transformToHistogram(x_plot, y_plot)
    x = Array{Float64, 2}(size(x_plot, 1) * 3, size(x_plot, 2) * 3)
    y = Array{Float64, 2}(size(y_plot, 1) * 3, size(y_plot, 2) * 3)
#    print(x[1, 1])
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

#569619
#WavPath = "data/orig/arctic_a0001.wav"
WavPath = "test\ audio\ words/433492.wav"

x, fs, t, format = wavread(WavPath, 1000)
coordinates, fs = wavread(WavPath)
nchannel = convert(Int64, format[:fmt].nchannels)
x, points = splitArrayq(coordinates, nchannel)

#print(x, "\n")
#print("points: ", points[1], " ", points[2], "\n")
print("length(x): ",length(x), "\n")
print(points, "\n")
if(size(points)[1] >= 2)
    for i = 1:div(length(points), 2)
        x_words = Array{Float64, 1}()
        if(nchannel == 2)
            x_words_other_channel = Array{Float64, 1}()
        end
        for i = points[(i - 1) * 2 + 1]:points[(i - 1) * 2 + 2]
            push!(x_words, x[i, 1])
            if(nchannel == 2)
                push!(x_words_other_channel, x[i, 2])
            end
#          x_words[i, 1], x_words[i, 2] = x[i, 1], x[i, 2]          ???
        end

    	print("length: ",length(x_words), "\n")
        if(nchannel == 2)
    	    words = Array{Float64, 2}(length(x_words), 2)

        	print(points,"\n")

	        for i=1:length(x_words)
	            words[i, 1] = x_words[i]
        	    words[i, 2] = x_words_other_channel[i]
	        end

    	    print("print: ", size(words, 1), " ", size(words, 2), "\n")
        else
            words = x_words
        end

    	plot(words, "r")
    	show()
    	wavplay(words, fs)
    end
end
plot(coordinates, "r")
show()
wavplay(coordinates, fs)
#=
+#############################################
#x, y = Array{Float32,1}(), Array{Float32,1}()
print(typeof(coordinates))
print(size(coordinates,1), " ", size(coordinates,2), "\n")
#for i = 1 : size(coordinates, 1)
#   push!(x, coordinates[i ,1])
#   push!(y, coordinates[i, 2])
#   print("coordinates[", i ,", 1] = ", coordinates[i,1], " ", "coordinates[", i, ",2] = ", coordinates[i,2], "\n")
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
-#############################################
=#
end
