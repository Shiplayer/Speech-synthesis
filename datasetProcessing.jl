using WAV

DatasetPath = "data/etc/"
DatasetFile = "txt.done.data"
DatasetStrings = "txt.done.string.data"
WavPath = "data/orig/"

dataset = Dict{AbstractString, AbstractString}()
count = 0
for l in readlines(open(string(DatasetPath, DatasetFile)))
    m = match(r"(?P<wav>a\w*\d*\S)\s[\"](?P<text>.*)[\"]", l)
    setindex!(dataset, m[2], m[1]);
end
dataset = sort(collect(dataset))
out = open(string(DatasetPath, DatasetStrings), "w");
for (k,v) in dataset
    write(out, "$v\n")
    println("$k.wav ($v)")
end
close(out);
