push!(LOAD_PATH, "Neurons/")
using MFCCLayer;
dict = Dict();

MEMORYPATH = "Memory/Str2MFCC.txt"
memory = open(MEMORYPATH, "r")

count = 0

for l in eachline(memory)
    global line = split(l, "=");
    mfcc = line[2];
    if(OS_NAME == :Windows)
        mfcc = chop(mfcc)
    end
    coeff = [parse(i) for i in split(mfcc[2:end-2], ",")]
    count = count + 1;
    if(count % 25 == 0)
        println(count / 100)
        break;
    end
    dict[line[1]] = coeff;
end

println(length(dict));

l = Layer(256, 8)

function convert2bits(str::ASCIIString)
    ans = Array{Int64, 1}()
    for i=1:length(str)
        append!(ans, bits(str[i])[end-7:end])
    end
    return ans
end

function convert2word(str::Array{Int64, 1})
    ans = ""
    for i=1:8:length(str)
        a = str[(length(str) - i + 1):length(str)]
        s = sum([a[i] * 2^(length(a) - i) for i=1:length(a)])
        if(s == 0)
            break;
        end
        ans = string(ans, s)
    end
    return ans;
end
input = "child"
while(true)
    println("next command:")
    cmd = readline();
    if(OS_NAME == :Windows)
        cmd = chop(cmd)
    end
    cmd = chop(cmd)
    if(cmd == "change")
        println(convert2bits(input))
        #l.changeWidth(l, input, )
    elseif cmd == "exit"
        break;
    else
        input = cmd;
        if(get(dict, input, -1) == -1)
            println("i dont know this word")
            continue;
        end
        mfcc = dict[input];
        ans = setInput(l, mfcc) #256 bits
        ans = convert2word(ans)
        if(length(ans) > 0)
            println(ans)
        else
            println("ans is empty");
        end
    end
end
