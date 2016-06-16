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
    ans = [0 for i =1:(256 - length(str) * 8)]
    for i=1:length(str)
        a = bits(str[i])[end-7:end]
        buf = [Int(a[j] - '0') for j=1:length(a)]
        println(buf)
        append!(ans, buf)
    end
    return ans
end

function convert2word(str::Array{Int64, 1})
    ans = ""
    for i=1:8:length(str)-1
        #a = str[(length(str) - i + 1):(length(str) - i + 7)]
        a = str[i:(i+7)]
        s = sum([a[j] * 2^(length(a) - j) for j=1:length(a)])
        println(s)
        if(s == 0)
            continue
        end
        ans = string(ans, Char(s))
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
        changeWidth(l, input, convert2bits(input))
    elseif(cmd == "show")
        showWidth(l)
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
        println(ans)
        ans = convert2word(ans)
        if(length(ans) > 0)
            println(ans)
        else
            println("ans is empty");
        end
    end
end
