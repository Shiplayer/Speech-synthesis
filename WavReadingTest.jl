using WAV
WavPath = "data/orig/arctic_a000"
for i=1:9
	wav = string(WavPath, i, ".wav")
	riff = read(wav, UInt8, 4)
	if riff != b"RIFF"
		error("Invalid Wav file")
	end
	
	chunk_size = ltoh(read(wav, UInt32))

	form = read(wav, UInt8, 4)
	
	print(wav, "\n")
	y, fs, nbits, opt = wavread(wav)
	print(typeof(y), " ", typeof(fs), " ", typeof(nbits), " ", typeof(opt),"\n")
	print(nbits, "\n")
	print(opt, "\n")
	print(length(y), "\n")
	print(chunk_size/16, "\n")
end
