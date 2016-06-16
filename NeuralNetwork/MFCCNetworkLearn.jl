push!(LOAD_PATH, "Neurons/")
using MFCCLayer;
dict = Dict();

MEMORYPATH = "Memory/Str2MFCC.txt"
memory = open(MEMORYPATH, "r")

count = 0

names = Array{ASCIIString, 1}()

for l in eachline(memory)
    global line = split(l, "=");
    push!(names, line[1]);
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
pop!(names)
println(names)

l = Layer(256, 8)

function convert2bits(str::ASCIIString)
    str = reverse(str)
    ans = [0 for i =1:(256 - length(str) * 8)]
    for i=1:length(str)
        a = bits(str[i])[end-7:end]
        buf = [Int(a[j] - '0') for j=1:length(a)]
        append!(ans, buf)
    end
    return reverse(ans)
end

function convert2word(str::Array{Int64, 1})
    str = reverse(str)
    ans = ""
    for i=1:8:length(str)-1
        #a = str[(length(str) - i + 1):(length(str) - i + 7)]
        a = str[i:(i+7)]
        s = sum([a[j] * 2^(length(a) - j) for j=1:length(a)])
        if(s == 0)
            continue
        end
        ans = string(ans, Char(s))
    end
    return reverse(ans);
end
input = "child"

function check()
    for i in keys(dict)
        ans = convert2word(getAns(i))
        if(i != ans)
            return false;
        end
    end
    return true;
end

function getAns(key)
    mfcc = dict[key];
    ans = setInput(l, mfcc) #256 bits
end

count = 0;
while(true)
    count = count + 1
    input = rand(names)
    ans = getAns(input)
    if(count % 100 == 0)
        println(ans)
        println("width begin");
        showWidth(l);
        println("width end");
        println(count)
    end
    ans = convert2word(ans)
    if(ans != input)
        changeWidth(l, dict[input], convert2bits(input))
    else
        println("check")
        if(check())
            break;
        end
    end
end

while(true)
    println("next command:")
    cmd = readline();
    if(OS_NAME == :Windows)
        cmd = chop(cmd)
    end
    cmd = chop(cmd)
    if(cmd == "change")
        changeWidth(l, dict[input], convert2bits(input))
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
