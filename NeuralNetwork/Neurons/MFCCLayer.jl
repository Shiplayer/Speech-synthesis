module MFCCLayer
using MFCCNeuron

    export Layer
    export setInput
    export changeWidth
    export showWidth

    type Layer
        neurons
        layerSize
        inputDataSize
        Layer(size::Int64, widthSize::Int64) = new([Neuron(widthSize) for i=1:size], size, widthSize)
    end

    function showWidth(l::Layer)
        for n in neurons
            println(n.width)
        end
    end

    function setInput(l::Layer, input)
        ans = Array{Int64, 1}()
        for i=1:l.layerSize
            if(i*l.inputDataSize <= length(input))
                buf = input[((i-1) * l.inputDataSize + 1):(i * l.inputDataSize)];
                ansNeuron = setInputData(l.neurons[i], buf)
                push!(ans, ansNeuron);
            elseif((i-1) * l.inputDataSize + 1 <= length(input))
                data = [0.0 for j=1:l.inputDataSize]
                n=1;
                for j=((i-1) * l.inputDataSize + 1):length(input)
                    data[n] = input[j]
                end
                push!(ans, setInputData(l.neurons[i], data));
            else
                push!(ans, setInputData(l.neurons[i], [0. for j=1:l.inputDataSize]));
            end
        end
        return ans;
    end

    function changeWidth(l::Layer, input, output)
        ans = setInput(l, input)
        for i=1:length(ans)
            if(ans[i] != output[i])
                changeWidthNeuron(l.neurons[i], getFrame(input, i, l.inputDataSize))
            end
        end
    end

    function getFrame(input, index, size)
        #=println("input: ", input)
        println("length(input) = ", length(input))
        println("index: ", index, "; index * size = ", index * size)
        println("size: ", size)
        =#

        if(index * size <= length(input))
            return input[((index - 1) * size + 1):(index * size)];
        elseif (index - 1) * size + 1 <= length(input)
            data = [0.0 for j=1:size]
            n=1;
            for j=((index-1) * size + 1):length(input)
                data[n] = input[j]
            end
            return data;
        else
            println("empty")
            return [0. for i=1:size]
        end
    end

end
