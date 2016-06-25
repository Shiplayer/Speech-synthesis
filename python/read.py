import numpy as np
import h5py

with h5py.File('my_model_weights.h5','r') as hf:
    print('List of arrays in this file: \n', hf.keys())
    a = hf.get('dense_1')
    print a.items()
    ab = np.array(a.get('dense_1_W'))
    print ab
    print ab.size
