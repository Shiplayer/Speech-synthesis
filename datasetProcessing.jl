using WAV

DatasetPath = "data/etc/txt.done.data"
WavPath = "data/orig/"

dataset = Dict{AbstractString, AbstractString}()
count = 0
for l in readlines(open(DatasetPath))
    m = match(r"(?P<wav>a\w*\d*\S)\s[\"](?P<text>.*)[\"]", l)
    setindex!(dataset, m[2], m[1]);
end
dataset = sort(collect(dataset))
for (k,v) in dataset
    println("$k.wav ($v)")
end
