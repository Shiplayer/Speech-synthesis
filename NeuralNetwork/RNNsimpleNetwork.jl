push!(LOAD_PATH, "Neurons/")
using RNNNeuron

a = RNNNeuron.Neuron(64);

function getInputs(str)
    if(length(str) == 1)
        str = bits(Int(str[1] - '0'))
        input = [Int(str[i] - '0') for i=1:length(str)]
        return input;
    end
end

str = "1"

while true

#inputStr = bits(1);
#input = [Int(inputStr[i] - '0') for i=1:length(inputStr)]
    input = getInputs(str);
    next = RNNNeuron.step(a, input);
    s = ""
    for i=1:length(next)
        s = string(s, next[i])
    end
    println(parse(Int, s, 2))
    buf = readline();
    buf = chop(buf)
    if(buf == "inc")
        println("incrementing")
        RNNNeuron.inc(a, input);
    elseif(buf == "dec")
        println("decrementing")
        RNNNeuron.dec(a, input);
    else
        str = buf
    end
end



#=using PyCall
using PyPlot
using RNNNeuron


s = open(readall, "../tmp/coordinates.tmp")
s = split(s, '\n');
s_len = length(s);
if s[s_len] == ""
    pop!(s);
    s_len = s_len - 1;
end

coordinates = [parse(Float64, s[i]) for i=1:s_len];
plot(coordinates, "r");
title("test");
plt[:show]();


=#
