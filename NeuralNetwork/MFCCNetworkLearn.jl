push!(LOAD_PATH, "Neurons/")
using MFCCLayer;
dict = Dict();
dict_point = Dict();

MEMORYPATH = "Memory/Str2MFCC.txt"
memory = open(MEMORYPATH, "r")

count = 0

names = Array{ASCIIString, 1}()

for l in eachline(memory)
    if(OS_NAME == :Windows)
        l = chop(l)
    end
    global line = split(l, "/");
    push!(names, line[1]);
    mfcc = line[2];
    points = line[3];
    coeff = [parse(i) for i in split(mfcc[2:end-2], ",")]
    points = [parse(i) for i in split(points[2:end-2], ",")]
    count = count + 1;
    if(count % 100 == 0)
        println(count / 100)
        break;
    end
    dict[line[1]] = coeff;
    dict_point[line[1]] = points;
end

println(length(dict));
pop!(names)
println(names)

l = Layer(1024, 2, :get)
l2 = Layer(256, 6)

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
    points = dict_point[key]
    ans = setInput(l, mfcc) #256 bits
    new_input = Array{Float64, 1}()
    j=1
    for i=1:4:length(ans)
        append!(new_input, ans[i:(i+3)])
        append!(new_input, points[j:(j+1)])
        j = j + 2
    end
    ans = setInput(l2, new_input)
    return ans, new_input
end

count = 0;
while(true)
    count = count + 1
    for i = 1:count
        input = rand(names)
        ans, new_input = getAns(input)
        changeWidth(l2, new_input, convert2bits(input))
        if(check())
            break;
        end
    end
end

println("learned")

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
