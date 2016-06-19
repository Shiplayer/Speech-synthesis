push!(LOAD_PATH, "Neurons/")
using MFCCLayer;
include("MFCCNetwork.jl")

dictionary = Array{Dict, 1}()
dict = Dict();
dict_point = Dict();
dict_output_layout = Dict();
dict_bits = Dict();

rewrite = false;

MEMORYDIR = "Memory/"
WIDTHFILE = "width.txt"
WIDTHFILELOAD = WIDTHFILE
DATA = "Str2MFCC.txt"
EXAMPLESDIR = "../Examples/"
NUMBERWORDS = -1

for k in ARGS
    if(contains(k, "="))
        m = match(r"(?P<c>[-]{1,2}\w*)[=](?P<w>\w.*)", k)
        if(m[:c] == "--out")
            WIDTHFILE = convert(ASCIIString, m[:w])
        end
        if(m[:c] == "--load")
            WIDTHFILELOAD = convert(ASCIIString, m[:w])
        end
        if(m[:c] == "--words")
            NUMBERWORDS = Int(floor(parse(m[:w])))
        end
    end
    if(k == "-r")
        rewrite = true;
    end
end

memory = open(string(MEMORYDIR, DATA), "r")

count = 0

#l = Layer(1024, 2048, :get) # скрытый слой, который возвращает значение сигмойдной функции
length_layer1 = 256
l_out = Layer(length_layer1, 4096, :just, 0.75)    # отправляем в слой значение сигмойдной функции и получаем бинарное представление
#l2 = Layer(256, 1024, :get) # скрытый слой, который принимает бинарное представление из 512 и еще в кажждый нейрон отправляем значение амплитуд
l2_out = Layer(256, 1024)   # отправляем значение сигмойдной функции из слоя выше и получаем бинарное представление слова

names = Array{ASCIIString, 1}()

function convert2bits(str::AbstractString)
    str = reverse(str)
    ans = [0 for i =1:(length_layer1 - length(str) * 8)]
    for i=1:length(str)
        a = bits(str[i])[end-7:end]
        buf = [Int(a[j] - '0') for j=1:length(a)]
        append!(ans, buf)
    end
    return reverse(ans)
end

for l in eachline(memory)
    if(OS_NAME == :Windows)
        l = chop(l)
    end
    l = chop(l)
    global line = split(l, "/");
    push!(dictionary, Dict())
    #push!(names, line[1]);
    mfcc = line[2];
    #points = line[3];
    #numbers = split(line[4][2:end-1],",");
    coeff = [parse(i) for i in split(mfcc[2:end-1], ",")]
    #points = [parse(i) for i in split(points[2:end-1], ",")]
    #numbers = [parse(i) for i in numbers]
    count = count + 1;
    append!(coeff, [0 for i=length(coeff)+1:4096])
    dictionary[count][:input] = line[1]
    dictionary[count][:coeff] = coeff
    dictionary[count][:bits] = convert2bits(line[1])
    dictionary[count][:count] = count
    #dict_point[line[1]] = points;
    #dict_output_layout[line[1]] = numbers
    if(count % 100 == 0)
        println(count / 100)
    end
    if(count == NUMBERWORDS)
        break;
    end
end

close(memory)

println(length(dictionary));
#pop!(names)
#println(dictionary)

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

function check(s::Symbol)
    if(s == :two)
        for word in dictionary
            ans, _ = getAnsfromLayer(word, s)
            ans = convert2word(ans)
            if(word[:input] != ans)
                return false;
            end
        end
        return true;
   elseif s == :one
       for word in dictionary                   # word::Dict
           ans, _ = getAnsfromLayer(word, s)
           bin = dict_output_layout[i]
           if(bin != ans)
               return false;
           end
       end
       return true;
   end

end

function getAnsfromLayer(key, s::Symbol)
    if(s == :two)
        ans = getAnsfromLayer(key, :one)         # получаем бинарное представление MFCC из 512 битов
        points = dict_point[key]
        ans = setInput(l2, ans)                         # прогоняем через скрытый слой и получаем значени сигмойдной функции каждого нейрона (256 значений)
        new_input = Array{Float64, 1}()
        j=1
        for i=1:2:length(ans)                           # добавляем к значениям сигмойдной функции значения амплитуд (сперва идут 2 значения сигмойдной функции и 2 значения амплитуды)
            append!(new_input, ans[i:(i+1)])
            append!(new_input, points[j:(j+1)])
            j = j + 1
        end
        ans = setInput(l2_out, new_input)               # проучаем двоичное представление слова
        return ans, new_input                           # возвращаем двоичное значение слова и входные данные, которые были отправлены во второй слой
    elseif s == :one
        mfcc = dict[key];
        ans = setInput(l, mfcc)                         # получаем значение сигмойдной функции для каждого нейрона (512 значени)
        #println(ans)
        ans = setInput(l_out, ans)                      # получаем бинарное представление mfcc
        return ans
    end
end

function getAns(word)
    #println(key, " ", length(dict[key]))
    ans = setInputAllinAll(l_out, word[:coeff])
    #ans = convert(Array{Float64, 1}, ans)
    #append!(ans, dict_point[key])
    #ans = setInputAllinAll(l2_out, ans)
end

#function changeWidthLayers(layer::Layer, layer2::Layer, new_input, ans, false_ans)

#end

function errors(false_ans, ans)
    s = sum((false_ans .- ans).^2) / 2
end

function checkAns()
    for word in dictionary
        ans = getAns(word)
        if(word[:bits] != ans)
            return false;
        end
    end
    println("CHECK SUCCESSFUL!!!!")
    return true;
end
# "width_layer1.data"
if(isfile(string(MEMORYDIR, WIDTHFILELOAD)) && !rewrite)
    loadWidth(l_out, string(MEMORYDIR, WIDTHFILELOAD))
else
    if(isfile(string(MEMORYDIR, WIDTHFILELOAD)))
        loadWidth(l_out, string(MEMORYDIR, WIDTHFILELOAD))
    end
    println("lerning first layer is started")
    count = 0;
    countErrors = 1;
    err = 0
    # обучаем первый слой
    while(!checkAns())
        if(countErrors >= 1)
            inputArr = rand(dictionary, Int(round(length(dictionary) * 3 / 4)))
            #countErrors = 0
        else
            println("full dictionary")
            inputArr = dictionary
        end
        count = count + 1
        err = 0
        for i=1:count
            flag = true
            for i=1:length(inputArr)
                word = inputArr[i]
                #ans = getAnsfromLayer(input, :one)
                ans = getAns(word)
                #println(length(ans), length(dict_output_layout[input]))
                #println("false_ans: ", ans)
                #println("ans: ", dict_output_layout[input])
                #println("ans: ", convert2bits(input))S
                showErr = errors(ans, word[:bits])
                info = string(count, " эпоха, ", showErr, "(", countErrors, ")")
                err = err + showErr
                println(info, ", pos: ", word[:count], ",\t", word[:input], " vs ", convert2word(ans))
                #println(convert2word(ans), " vs ", input)
                #changeWidthLayers(l, l2, new_input, convert2bits(input), ans)
                if(word[:bits] != ans)
                    flag = false
                    changeWidth(l_out, word[:coeff], word[:bits], ans)
                end

            end
            if(flag)
                println("clear")
                break;
            end
            #println(dict[input])
            #println(dict_output_layout[input])
            #println(ans)
        end
        countErrors = err / length(inputArr)
        saveWidth(l_out, MEMORYDIR, WIDTHFILE)
    end

    println("layout1 is learned and saved")

end

function getAnsLayer(key)
    ans = setInputAllinAll(l_out, dict[key])
    #ans = convert(Array{Float64, 1}, ans)
    #append!(ans, dict_point[key])
    println(length(ans))
    #input_new = ans
    #ans = setInputAllinAll(l2_out, ans)
    return ans;
end

function checkAnsLayer2()
    println("check")
    for k in keys(dict)
        ans, _ = getAnsLayer(k)
        ans = convert2word(ans)
        println(ans, " vs ", k)
        if(k != ans)
            return false;
        end
    end
    println("CHECK SUCCESSFUL!!!!")
    return true;
end

#=
if(isfile(string(MEMORYDIR, "width_layer2.data")) && !rewrite)
    println("loading width")
    loadWidth(l2_out, string(MEMORYDIR, "width_layer2.data"))
else
    while(!checkAnsLayer2())
        input = rand(names)
        ans, input_new = getAnsLayer(input)
        println(errors(ans, convert2bits(input)))
        changeWidth(l2_out, input_new, convert2bits(input), ans)
    end

    saveWidth(l2_out, MEMORYDIR, "width_layer2.data")
    println("learned and saved")
end
=#
#=count_2 = 0
while(true)
    count_2 = count_2 + 1
    for i = 1:count_2
        input = rand(names)
        ans, new_input = getAnsfromLayer(input, :two)
        #println("false_ans: ", ans)
        #println("ans: ", convert2bits(input))
        if(errors(ans, convert2bits(input)) == 0.)
            println(convert2word(ans), " vs ", input)
        end
        #changeWidthLayers(l, l2, new_input, convert2bits(input), ans)
        changeWidth(l2_out, new_input, convert2bits(input), ans)
    end
    if(check(:two))
        break;
    end
end
=#

while(true)
    println("enter your command or word(see in Examples dir):")
    cmd = readline();
    if(OS_NAME == :Windows)
        cmd = chop(cmd)
    end
    cmd = chop(cmd)
    if cmd == "exit"
        break;
    else
        input = cmd;
        mfcc = word2MFCC(EXAMPLESDIR,input)
        if(typeof(mfcc) == Int)
            println("An error has occurred. Code error: ", mfcc)
        end
        ans = getAns(mfcc)
        ans = convert2word(ans)
        println(ans)
        if(length(ans) > 0)
            println(ans)
        else
            println("ans is empty");
        end
    end
end
