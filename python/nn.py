from keras.models import Sequential
from keras.layers import Dense, Activation
from keras.optimizers import SGD
import numpy as np
model = Sequential()
model.add(Dense(512, input_dim=4096))
model.add(Dense(1024))
model.add(Dense(512))
model.add(Activation('sigmoid'))
model.compile(optimizer=SGD(lr=0.01, momentum=0.9, nesterov=True), loss='binary_crossentropy')

txt = open('../NeuralNetwork/Memory/Str2MFCC.txt')
d = txt.read().split('\n')
names = list()

words = 1700
examples = words - 50

data = np.zeros((words, 4096))
labels = np.zeros((words, 512), dtype=np.int)
for i in range(words):
    q = np.zeros(4096)
    line = d[i].split('/')
    names += [line[0]]
    floats = line[1].replace('[', '').replace(']','').split(',')
    for j in range(len(floats)):
        q[j] = float(floats[j])

    data[i] = q
    buf = np.zeros(512, dtype=np.int)
    for j in range(len(line[0])):
        s = bin(ord(line[0][j]))[2:]
        while len(s) < 8:
            s = '0' + s
        index = 0
        for m in range(j * 8, j * 8 + 8):
            buf[m] = int(float(s[index]))
            index += 1
    labels[i] = buf

# generate dummy data
print'\n', names[0], labels[0]

# train the model, iterating on the data in batches
# of 32 samples

#model.save_weights('my_model_weights.h5')

model.fit(data, labels, nb_epoch=20, batch_size=16)

score = model.evaluate(data[:examples], labels[:examples], batch_size=1)
from keras import backend as K

# with a Sequential model
get_3rd_layer_output = K.function([model.layers[0].input],
                                  [model.layers[1].output])
layer_output = get_3rd_layer_output([data[0:1]])
print '\nlayer_output', layer_output

#model.save_weights('my_model_weights.h5')

proba = model.predict_proba(data[examples:], batch_size=1)
for n in range(proba.size):
    p = np.zeros(proba[n].size, dtype=np.int)
    for i in range(proba[n].size):
        p[i] = np.round(proba[n][i])
    word = ""
    for i in range(0, p.size, 8):
        test = p[i:i+8]
        word += chr(int(''.join(np.array(map(str,p[i:i+8]))), 2))
        if(np.array_equal(np.zeros(8), test)):
            break;
    print(word, names[examples + n])
    print '\n',


#from keras import backend as K
#get_activations = K.function([model.layers[0].input, K.learning_phase()], [model.layers[0].output])
#activations = get_activations([data])[0]
