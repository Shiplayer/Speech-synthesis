module MFCCNeuron

    export Neuron
    export setInputData
    export changeWidthNeuron

    srand(1234567890)

    type Neuron
        width                   # веса нашего нейрона
        h                       # скорость обучения
        lim                     # порог
        o                       # значение, которое нейрон возвращает (не относится к скрытому слою)
        Neuron(size) = Neuron(size, 0.75)
        Neuron(size, limit) = new([rand() - 0.5 for i=1:size], 0.01, limit, 0)
    end

    # первый аргумент, нейрон, в котором мы хотим произвести вычисления
    # второй аргумент, входные данные в нейрон
    # третий аргумент, символ, по которому мы определяем, что мы хотим получить от нейрона
    function setInputData(n::Neuron, input, m::Symbol = :just)
        if(length(input) != length(n.width))
            println(length(input), " ", length(n.width))        #2048 1024
            #println("input: ", input)
        end
        s = sum(input .* n.width)
        if(m == :width)
            return s;
        end
        ans = sigmoid(s)
        #println("sigmoid: ", ans)
        if(m == :just)
            if(ans >= n.lim)
                n.o = 1;
            else
                n.o = 0;
            end
            return n.o;
        else
            return ans;
        end
    end

    # первый аргумент, нейрон, в котором мы хотим изменить веса
    # второй аргумент, входные данные в нейрон
    # третий аргумент, данные, которое должны были выйти из нейрона
    # четвертый аргумент, данные, которые мы получили после этого нейрона
    function changeWidthNeuron(n::Neuron, input, output, false_output)
        #println("after: ", n.width)
        #println((input))

        s = setInputData(n, input)
        if(s == false_output)
            #println(s, " ", input, " ", output, " ",)
        end
        n.width = n.width .+ (n.h .* (output .-  false_output) .* input)
        #println("before: ", n.width)
    end

    function sigmoid(x)
        return 1. / (1. + exp(-x))
    end

end
