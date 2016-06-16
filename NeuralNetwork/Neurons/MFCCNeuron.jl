module MFCCNeuron

    export Neuron
    export setInputData
    export changeWidthNeuron

    type Neuron
        width
        h
        lim
        Neuron(size) = new([0. for i=1:size], 0.01, 0.9)
    end

    function setInputData(n::Neuron, input, m::Symbol = :just)
        s = sum(input .* n.width)
        ans = sigmoid(s)
        if(m == :just)
            if(ans > n.lim)
                return 1;
            end
            return 0;
        else
            return ans;
        end
    end

    function changeWidthNeuron(n::Neuron, input)
        #println("after: ", n.width)
        #println((input))
        n.width = n.width .+ (n.h .* (input .- n.width))
        #println("before: ", n.width)
    end

    function sigmoid(x)
        return 1. / (1. + exp(-x))
    end

end
