push!(LOAD_PATH, "Neurons/")
using MFCCLayer;
dict = Dict();
dict_point = Dict();
dict_output_layout = Dict();

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
    append!(coeff, [0 for i=length(coeff)+1:2048])
    dict[line[1]] = coeff;
    dict_point[line[1]] = points;
    dict_output_layout[line[1]] = rand((0:1), 512)
    if(count % 10 == 0)
        println(count / 100)
        break;
    end
end

println(length(dict));
#pop!(names)
println(names)

#l = Layer(1024, 2048, :get) # скрытый слой, который возвращает значение сигмойдной функции
l_out = Layer(512, 2048, :just, 0.75)    # отправляем в слой значение сигмойдной функции и получаем бинарное представление
#l2 = Layer(256, 1024, :get) # скрытый слой, который принимает бинарное представление из 512 и еще в кажждый нейрон отправляем значение амплитуд
l2_out = Layer(256, 1024)   # отправляем значение сигмойдной функции из слоя выше и получаем бинарное представление слова

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

function check(s::Symbol)
    if(s == :two)
        for i in keys(dict)
            ans, _ = getAnsfromLayer(i, s)
            ans = convert2word(ans)
            if(i != ans)
                return false;
            end
        end
        return true;
   elseif s == :one
       for i in keys(dict)
           ans, _ = getAnsfromLayer(i, s)
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

function getAns(key)
    ans = setInputAllinAll(l_out, dict[key])
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
    for k in keys(dict)
        ans = getAns(k)
        if(dict_output_layout[k] != ans)
            return false;
        end
    end
    println("CHECK SUCCESSFUL!!!!")
    return true;
end


# обучаем первый слой
while(!checkAns())
    input = rand(names)
    #ans = getAnsfromLayer(input, :one)
    ans = getAns(input)
    #println(length(ans), length(dict_output_layout[input]))
    #println("false_ans: ", ans)
    #println("ans: ", dict_output_layout[input])
    #println("ans: ", convert2bits(input))
    println(errors(ans, dict_output_layout[input]))
    #println(convert2word(ans), " vs ", input)
    #changeWidthLayers(l, l2, new_input, convert2bits(input), ans)

    changeWidth(l_out, dict[input], dict_output_layout[input], ans)
    
    #println(dict[input])
    #println(dict_output_layout[input])
    #println(ans)
end

println("layout1 is learned")

function getAnsLayer2(key)
    ans = setInputAllinAll(l_out, dict[key])
    ans = convert(Array{Float64, 1}, ans)
    append!(ans, dict_point[key])
    ans = setInputAllinAll(l2_out, ans)
end

function checkAnsLayer2()
    for k in keys(dict)
        ans = getAnsLayer2(k)
        if(convert2bits(k) != ans)
            return false;
        end
    end
    println("CHECK SUCCESSFUL!!!!")
    return true;
end

while(!checkAnsLayer2())
    input = rand(names)
    ans = getAnsLayer2(input)
    println(errors(ans, convert2bits(input)))
    changeWidth(l2_out, dict[input], convert2bits(input), ans)
end
count_2 = 0
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
