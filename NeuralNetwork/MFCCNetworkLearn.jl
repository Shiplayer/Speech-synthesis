push!(LOAD_PATH, "Neurons/")
using MFCCLayer;
dict = Dict();

MEMORYPATH = "Memory/Str2MFCC.txt"
memory = open(MEMORYPATH, "r")

for l in eachline(memory)
    global line = split(l, "=");
    mfcc = line[2];
    if(OS_NAME == :Windows)
        mfcc = chop(mfcc)
    end
    coeff = [parse(i) for i in split(mfcc[2:end-2], ",")]
end

println(length(dict));
