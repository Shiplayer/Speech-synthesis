push!(LOAD_PATH, "Neurons/")
using WAV;
#using PyPlot
using MFCC;

function getWordPoints(x::Array{Float64, 2})
    pns = Array{Int64, 1}();
    flag = 0;
    lim = 0.0002
    count_sound = 0;
    count = 0;
    points = 600
    for j=2:length(x)
        buf = abs(abs(x[j-1]) - abs(x[j]))
        if(buf > lim)
            count_sound = count_sound + 1
            if(flag == 0)
                push!(pns, j)
            end
            flag = 1;
            count = 0
        elseif(buf <= lim && count < 600)
            count = count + 1;
        elseif(count >= 600)
            if(flag == 1)
                push!(pns, j - 400);
                flag = 0;
                count_sound = 0;
            end
        end
    end
    return pns
end

function getMFCC(file::ASCIIString)
    x, fs = wavread(file)
    return getMFCC(x)
end

function getMFCC(x::Array{Float64, 2})
    pns = getWordPoints(x)
    if(length(pns) == 1)
        push!(pns, length(x))
    elseif(length(pns) == 2 || length(pns) == 4)
        word = x[pns[1]:pns[2]]
        coeff = mfcc(word)[1]
        if(length(coeff) > 4096)
            println(length(coeff))
            return -2
        end
        coeff = vec(coeff)
        append!(coeff, [0 for i=length(coeff)+1:4096])
        return coeff;
    else
        println(length(pns))
        return -1
    end
end

function word2MFCC(pathDir::ASCIIString, word)
    exampleDir = readdir(pathDir)
    for f in exampleDir
        file = string(pathDir, f)
        if(isfile(file) && contains(f, ".wav"))
            name = f;
            if(contains(name, word))
                return getMFCC(file)
            end
        end
    end
    return 0
end

AUDIO_DIR = "../test audio words/wav/";
dir = readdir(AUDIO_DIR)
files = Dict{Int64, ASCIIString}()
for i=1:length(dir)
    if(isfile(string(AUDIO_DIR,dir[i])) && contains(dir[i], ".wav"))
        files[i] = dir[i][1:end-4]
    end
end

#=
MEMORYDIR = "Memory/Str2MFCC.txt"
AUDIO = "002 aunt.wav";

if(!ispath(MEMORYDIR))
    global memory = open(MEMORYDIR, "w")
end
rewrite = false;
for k in ARGS
    if(k == "-r")
        rewrite = true;
        global memory = open(MEMORYDIR, "w")
    end
end

for i=1:length(files)
    x, fs = wavread(string(AUDIO_DIR, files[i], ".wav"))

    pns = getWordPoints(x)
    word = x[pns[1]:pns[2]]
    if(length(pns) != 4)
        println(pns)
        plot(x, "r")
        title(files[i])
        plt[:show]()
        plot(word, "r")
        title(files[i])
        plt[:show]()
    end

    word_mfcc = mfcc(word)
    if(rewrite && length(word_mfcc[1]) <= 4096 && length(pns) == 4)
        coeff = Array{Float64, 1}()
        for j in word_mfcc[1]
            append!(coeff, [n for n in j])
        end
        write(memory, string(files[i][5:end], "/", coeff, "\n"))
    end
    #println(length(x[pns[1]:pns[2]]))
    #println(length(word_mfcc[1]))
    #println(count, " ", count_sound, " ", pns);
    if(length(pns) > 4)
        println(files[i])
        break;
    end
end

=#
