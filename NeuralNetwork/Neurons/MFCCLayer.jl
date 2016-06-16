module MFCCLayer
using MFCCNeuron

    export Layer
    export setInput
    export changeWidth

    type Layer
        neurons
        layerSize
        inputDataSize
        Layer(size::Int64, widthSize::Int64) = new([Neuron(widthSize) for i=1:size], size, widthSize)
    end

    function setInput(l::Layer, input)
        ans = Array{Int64, 1}()
        for i=1:l.layerSize
            if(i*l.inputDataSize <= length(input))
                buf = input[((i-1) * l.inputDataSize + 1):(i * l.inputDataSize)];
                println(typeof(buf))
                println(buf);
                ansNeuron = Neuron.setInput(l.neurons[i], buf)
                push!(ans, ansNeuron);
            elseif((i-1) * l.inputDataSize + 1 <= length(input))
                data = [0.0 for j=1:l.inputDataSize]
                n=1;
                for j=((i-1) * l.inputDataSize + 1):length(input)
                    data[n] = input[j]
                end
                push!(ans, Neuron.setInput(l.neurons[i], data));
            else
                push!(ans, Neuron.setInput(l.neurons[i], [0. for j=1:l.inputDataSize]));
            end
        end
        return ans;
    end

    function changeWidth(l::Layer, input, output)
        ans = setInput(l, input)
        for i=1:length(ans)
            if(ans[i] != output[i])
                Neuron.changeWidth(l.neurons[i], getFrame(input, i, l.widthSize))
            end
        end
    end

    function getFrame(input, index, size)
        if(index * size <= length(input))
            return input[((index - 1) * size + 1):(index * size)];
        elseif (index - 1) * size + 1 <= length(input)
            data = [0.0 for j=1:l.inputDataSize]
            n=1;
            for j=((i-1) * l.inputDataSize + 1):length(input)
                data[n] = input[j]
            end
            return data;
        else
            return [0. for i=1:size]
        end
    end

end
