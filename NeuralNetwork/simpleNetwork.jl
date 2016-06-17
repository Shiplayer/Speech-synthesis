print("enter your char: ");

base = readline();
if(length(base) > 1)
    base = base[1];
end


limit = 9;

dict = [bin(i) for i = Int('a'):Int('z')];

width = [0 for i=1:length(dict[1])];


function test(width)
    while true
        ch = readline();
        if(ch == "exit")
            break;
        end
        if(length(ch) > 1)
            ch = ch[1];
        end
        ans = getAns(bin(ch), width)
        println("width: ", width);
        println("input: ", bin(ch));
        println("Is it char $base? $ans")
    end
end

function getAns(input, width)
    summ = sum([Int(input[i]) * width[i] for i = 1:length(input)])
    return summ < limit;
end

function learn(width, base)
    count = 0;
    while true
        count = count + 1;
        ch = rand(('a':'z'))
        if(length(ch) > 1)
            ch = ch[1];
        end
        binch = bin(ch);
        println(width);
        ans = getAns(binch, width)
        if (ans && ch == base) || (!ans && ch != base)
            width = [width[i] - Int(binch[i] - '0') for i=1:length(width)];
        elseif (ans && ch != base) || (!ans && ch == base)
            width = [width[i] + Int(binch[i] - '0') for i=1:length(width)];
        end
        println("check");
        if(check(width, base) != false)
            break;
        end
    end
    println(count);
    return width;
end

function check(width, base)
    for i = 1:length(dict)
        if getAns(dict[i], width) != (dict[i] == bin(base))
            return false;
        end
    end
    return true;
end

width = learn(width, base);

test(width);
