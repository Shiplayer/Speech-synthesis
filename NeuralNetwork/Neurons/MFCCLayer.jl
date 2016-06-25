module MFCCLayer
using MFCCNeuron

    export Layer
    export setInput
    export changeWidth
    export showWidth
    export setInputAllinAll
    export saveWidth
    export loadWidth

    srand(1234567890)

    type Layer
        neurons
        layerSize
        inputDataSize
        mode
        Layer(size::Int64, widthSize::Int64) = Layer(size, widthSize, :just) #new([Neuron(widthSize) for i=1:size], size, widthSize, :just)
        Layer(size::Int64, widthSize::Int64, m, limit) = new([Neuron(widthSize, limit) for i=1:size], size, widthSize, m)
        Layer(size::Int64, widthSize::Int64, m) = new([Neuron(widthSize) for i=1:size], size, widthSize, m)
    end

    function loadWidth(l::Layer, path::ASCIIString)
        println("Loading width for layer")
        fileWithWidth = open(path, "r")
        countLine = 0;
        lines = split(readall(fileWithWidth),"\n")
        pop!(lines)
        for f in lines
            countLine = countLine + 1
            println(countLine)
            if(OS_NAME == :Windows)
                f = chop(f)
            end
            index = searchindex(f, '[') + 1
            w = f[index:end-1]
            l.neurons[countLine].width = [parse(i) for i in split(w, ",")]
        end
        close(fileWithWidth)
        println("Width for layer loaded")
    end

    function saveWidth(l::Layer, path::ASCIIString, file::ASCIIString)
        backup = false
        if(isfile(string(path, file)))
            println("Backup widths")
            mv(string(path, file), string(path, ".", file, ".backup"))
            backup = true
        end
        println("Saving width for layer")
        fileWithWidth = open(string(path, file), "w")
        for n in l.neurons
            write(fileWithWidth, string(n.width), "\n")
        end
        close(fileWithWidth)
        println("Saved width for layer")
        if(backup)
            rm(string(path, ".", file, ".backup"))
            println("backup file deleted")
        end
    end

    function showWidth(l::Layer)
        for n in l.neurons
            println("width: ", n.width)
        end
    end

    function setInput(l::Layer, input)
        if(l.mode == :just)
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
        elseif(l.mode == :get)
            ans = Array{Float64, 1}()
            for i=1:l.layerSize
                #println(i, " ", l.inputDataSize, " ", length(input))
                frame = getFrame(input, i, l.inputDataSize)
                push!(ans, setInputData(l.neurons[i], frame, l.mode))
            end
            return ans;
        end
    end

    function setInputAllinAll(l::Layer, input, mode::Symbol = :just)
        ans = Array{Int64, 1}()
        if(mode == :get)
            ans = convert(Array{Float64, 1}, ans)
        end
        for i=1:l.layerSize
            buf = setInputData(l.neurons[i], input, mode)
            #println(buf, " ", typeof(ans), mode)
            push!(ans, buf)
        end
        return ans
    end

    function changeWidth(l::Layer, input, output, false_output)
        for i=1:length(output)

            if(output != false_output)
                changeWidthNeuron(l.neurons[i], input, output[i], false_output[i])
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
            #println("empty")
            return [0. for i=1:size]
        end
    end

end
