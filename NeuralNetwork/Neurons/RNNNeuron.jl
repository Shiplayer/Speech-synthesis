module RNNNeuron

type Neuron
    width
    widthHidden
    widthOut
    h
    size
    Neuron(s::Int) = new([0. for i=1:s+1], [0. for i=1:s+1], [0. for i=1:s+1], [0. for i=1:(s+1)*2], s)
end

function getInfo(n::Neuron)
    println(" n.size = ", n.size, " length(n.width) = ", length(n.width))
    println("length(n.widthHidden) = ", length(n.widthHidden), "length(n.widthOut) = ", length(n.widthOut), "length(n.h) = ", length(n.h))
end

function step(n::Neuron, input)
    for i = 1:n.size
        n.h[i] = n.h[n.size + i]
    end
    local y = [0 for i = 1:n.size];
    for i = 1:n.size
        buf = dot(n.widthHidden[i], n.h[i])
        buf2 = dot(n.width[i], input[i])
        n.h[n.size + i] = tanh(buf + buf2);
        #println(n.h[n.size + i], " ", i, " n.size = ", n.size, " length(n.width) = ", length(n.width), )
        #getInfo(n)
        print(dot(n.widthOut[i], n.h[n.size + i]), " ")
        limit = dot(n.widthOut[i], n.h[n.size + i])
        if(limit > 0.7)
            y[i] = 1
        end
    end
    println()
    println(y)
    return y;
end

function inc(n::Neuron, input)
    for i = 1:n.size
        n.widthHidden[i] = n.widthHidden[i] + n.h[i];
        n.width[i] = n.width[i] + input[i]
        n.widthOut[i] = n.widthOut[i] + n.h[n.size + i]
    end
end

function dec(n::Neuron, input)
    for i = 1:n.size
        n.widthHidden[i] = n.widthHidden[i] - n.h[i];
        n.width[i] = n.width[i] - input[i]
        n.widthOut[i] = n.widthOut[i] - n.h[n.size + i]
    end
end

end
