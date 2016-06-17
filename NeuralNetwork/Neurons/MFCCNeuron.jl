module MFCCNeuron

    export Neuron
    export setInputData
    export changeWidthNeuron

    srand(1234567890)

    type Neuron
        width
        h
        lim
        Neuron(size) = new([rand() for i=1:size], 0.01, 0.75)
    end

    function setInputData(n::Neuron, input, m::Symbol = :just)
        s = sum(input .* n.width)
        if(m == :width)
            return s;
        end
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

    function changeWidthNeuron(n::Neuron, input, output, false_output)
        #println("after: ", n.width)
        #println((input))

        s = setInputData(n, input)
        n.width = n.width .+ (n.h .* (output .- s) .* input)
        #println("before: ", n.width)
    end

    function sigmoid(x)
        return 1. / (1. + exp(-x))
    end

end
