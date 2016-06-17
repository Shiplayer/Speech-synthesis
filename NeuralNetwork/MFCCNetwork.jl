push!(LOAD_PATH, "Neurons/")
using WAV;
#using PyPlot
using MFCC;
using MFCCLayer;

#=function splitArray(x, channels = 2)
    noise = 0
    for i=1:size(x, 1)
        if(x[i, 1] != 0)
            n=0
            for j=1:size(x, 1)
                if(x[i,1] == x[j,1])
                    n = n + 1
                end
            end
            noise = abs(x[i, 1]/n) * log(2, abs(x[i, 1]/n)) + noise
        end
#        print(abs(abs(x[i, 1]) * log(2, abs(x[i, 1]))), "\n")
    end
    noise = abs(noise / size(x,1))
    print(noise, "\n")
    new_channel = Array{Float64, 1}()
    if(channels == 2)

        new_other_channel = Array{Float64, 1}()
    end
    points = Array{Int64, 1}()
    noise = 0.02
    flag = 1
    count = 1
    counts = 500
    flag_1 = 0
    for i = 2:size(x, 1)
        if(abs(x[i, 1]) > noise)
            if(flag == 1)
                push!(points, size(new_channel)[1] + 1)
                flag = 0
                count = 0
            end
            push!(new_channel, x[i, 1])
            if(channels == 2)
                push!(new_other_channel, x[i, 2])
            end
        elseif(abs(abs(x[i-1, 1]) - abs(x[i, 1])) < 0.0005)

        elseif(count <= counts)
            if(abs(x[i-1, 1]) - abs(x[i, 1]) < 0.0001 && flag_1 == 1)
                count = count + 1
            elseif(flag_1 == 1 && abs(x[i - 1, 1]) > 0.02)
                count = 0
                flag_1 = 0
            else
                flag_1 = 1
            end
        elseif(count > counts)
            count = count + 1
            if(flag == 0)
                push!(points, size(new_channel)[1])
                flag = 1
            end
        end
    end
#    print("size: ", size(new_channel, 1), " ", size(new_other_channel, 1), "\n")
    if(channels == 2)
        origin = Array{Float64, 2}(size(new_channel)[1], 2)
        for i = 1:size(origin, 1)
            origin[i, 1] = new_channel[i]
            origin[i, 2] = new_other_channel[i]
        end
        return origin, points
    else
        return new_channel, points
    end
end =#

function getWordPoints(x::Array{Float64, 2})
    pns = Array{Int64, 1}();
    flag = 0;
    lim = 0.0002
    count_sound = 0;
    count = 0;
    for j=2:length(x)
        buf = abs(abs(x[j-1]) - abs(x[j]))
        if(buf > lim)
            count_sound = count_sound + 1
            if(flag == 0)
                push!(pns, j)
            end
            flag = 1;
            count = 0
        elseif(buf <= lim && count < 500)
            count = count + 1;
        elseif(count >= 500)
            if(flag == 1)
                push!(pns, j - 400);
                flag = 0;
                count_sound = 0;
            end
        end
    end
    return pns
end

function init()
end

AUDIO_DIR = "../test audio words/wav/";
dir = readdir(AUDIO_DIR)
files = Dict{Int64, ASCIIString}()
for i=1:length(dir)
    if(isfile(string(AUDIO_DIR,dir[i])) && contains(dir[i], ".wav"))
        files[i] = dir[i][1:end-4]
    end
end

MEMORYPATH = "Memory/Str2MFCC.txt"
AUDIO = "002 aunt.wav";

if(!ispath(MEMORYPATH))
    global memory = open(MEMORYPATH, "w")
end
rewrite = false;
for k in ARGS
    if(k == "-r")
        rewrite = true;
        global memory = open(MEMORYPATH, "w")
    end
end

l1 = Layer(256, 8)

for i=1:length(files)
#for i=1:2
    #coordinates, fs = wavread(string(AUDIO_DIR, dir[i]), 30000);
    println(files[i])
    x, fs = wavread(string(AUDIO_DIR, files[i], ".wav"))
    #=min = 100.0
    avr = 0.0;
    max = 0.0;

    for j=2:length(x_word)
        buf = abs(abs(x_word[j-1]) - abs(x_word[j]))
        if(buf > max)
            max = buf
        end
        if(buf < min && buf != 0.0)
            min = buf
        end
        avr = avr + buf;
    end
    println(avr/length(x_word))
    println(max)
    println(min)=#
    pns = getWordPoints(x)
    word = x[pns[1]:pns[2]]
    word_mfcc = mfcc(x[pns[1]:pns[2]])
    if(length(word_mfcc[1]) > 4096)
        println(files[i])
        continue;
    end
    if(rewrite)
        coeff = Array{Float64, 1}()
        for j in word_mfcc[1]
            append!(coeff, [n for n in j])
        end
        write(memory, string(files[i][5:end], "/", coeff, "/", sort(word)[(end - 512 + 1):end], "\n"))
    end
    #println(length(x[pns[1]:pns[2]]))
    #println(length(word_mfcc[1]))
    #println(count, " ", count_sound, " ", pns);
    if(length(pns) > 4)
        println(files[i])
        break;
    end
end
#=plot(x_word, "r")
title(files[i])
plt[:show]()=#
#println(points)
#=new_coordinates = Array{Float64, 1}()
for j=11000:length(coordinates)
    push!(new_coordinates, coordinates[j])
end
plot(new_coordinates, "r")
title(files[i])
plt[:show]()
end=#

#=
println(length(coordinates), size(coordinates, 1));

new_coordinates = Array{Float64, 1}()
for i=11000:length(coordinates)
    push!(new_coordinates, coordinates[i])
end

test = Array{Float64, 1}()
for i=1:768
    push!(test, new_coordinates[i]);
end

#println(test)


coff = mfcc(new_coordinates);
println(length(new_coordinates))
println(size(coff, 1), " ", size(coff[1], 1), " ", size(coff[2], 1))
#println(coff[1], " ", coff[2]);
=#
