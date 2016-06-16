module MFCCNeuron

    export Neuron
    export sigmoid
    export setInputData

    type Neuron
        width
        h
        lim
        Neuron(size) = new([rand(Float64) for i=1:size], 0.1, 0.7)
    end

    function setInputData(n::Neuron, input)
        s = sum(input .* n.width)
        ans = sigmoid(s)
        if(ans > n.lim)
            return 1;
        end
        return 0;
    end

    function changeWidth(n::Neuron, input)
        n.width = n.width .+ n.h .* (input - n.width)
    end

    function sigmoid(x)
        return 1. ./ (1. .+ exp(-x))
    end

end
