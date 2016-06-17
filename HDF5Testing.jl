using HDF5;

A = [1:64];

h5write("./tmp/test.hdf5", "data/label", A);
#=h5open("./tmp/test.hdf5", "w") do file
    g = g_create(file, "data");
    g["label"] = A;
    #write(file, "data", A);
end=#
