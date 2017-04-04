import numpy as np
import tensorflow as tf

# Load data
dataX = np.load("data/dataX.npy")   # images
dataY = np.load("data/dataY.npy")  # labels
size = len(dataX)
formated = np.zeros([size, 10])

for i in range(size):
    formated[i][int(dataY[i])] = 1

dataY = formated

# Shuffle data
random_permutation = np.random.permutation(size)
dataX_shuffled = [dataX[i] for i in random_permutation]
dataY_shuffled = [dataY[i] for i in random_permutation]

dataX = dataX_shuffled
dataY = dataY_shuffled

# Data separtion
train_purcentage = 0.5
test_purcentage = 0.25

indice_train = int(size*train_purcentage)
indice_test = int(size * (train_purcentage + test_purcentage))
train_data = (dataX[:indice_train], dataY[:indice_train])
test_data = (dataX[indice_train:indice_test], dataY[indice_train:indice_test])
valid_data = (dataX[indice_test:], dataY[indice_test:])

#print(test_data)

# Constants
learning_rate = 0.0001
batch_size = 1
n_iterations = len(train_data[0]) // batch_size
n_epochs = 1000

hidden_layer_1_size = 16*16
hidden_layer_2_size = 8*8

# Model

hidden_layer_1 = {'weights': tf.Variable(tf.random_normal([32*32, hidden_layer_1_size])),
                    'bias': tf.Variable(tf.random_normal([hidden_layer_1_size]))}

hidden_layer_2 = {'weights': tf.Variable(tf.random_normal([hidden_layer_1_size, hidden_layer_2_size])),
                    'bias': tf.Variable(tf.random_normal([hidden_layer_2_size]))}

W = tf.Variable(tf.zeros([32*32, 10]))
b = tf.Variable(tf.zeros([10]))

x = tf.placeholder(tf.float32, [None, 32*32])
y_ = tf.placeholder(tf.float32, [None, 10])

hl1 = tf.matmul(x, hidden_layer_1['weights']) + hidden_layer_1['bias']
hl1 = tf.nn.relu(hl1)

hl2 = tf.matmul(hl1, hidden_layer_2['weights']) + hidden_layer_2['bias']
hl2 = tf.nn.relu(hl2)

y = tf.matmul(x, W) + b

cross_entropy = tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y)
train_step = tf.train.AdamOptimizer(learning_rate).minimize(cross_entropy)

sess = tf.InteractiveSession()
sess.run(tf.global_variables_initializer())

# Accuracy
correct_prediction = tf.equal(tf.argmax(y, 1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

max_accuracy = 0
n_without_improvement = 0
treshold_without_improvement = 50

def shuffle_train_data(train_data):
    dataX, dataY = train_data
    size = len(dataX)
    random_permutation = np.random.permutation(size)
    dataX_shuffled = [dataX[i] for i in random_permutation]
    dataY_shuffled = [dataY[i] for i in random_permutation]
    return (dataX_shuffled, dataY_shuffled)

# Train part
for n in range(n_epochs):
    train_data = shuffle_train_data(train_data)
    for i in range(n_iterations):
        data_xs, data_ys = train_data[0][i*batch_size:(i+1)*batch_size], train_data[1][i*batch_size:(i+1)*batch_size]
        sess.run(train_step, feed_dict={x:data_xs, y_:data_ys})

    current_accuracy = sess.run(accuracy, feed_dict={x:valid_data[0], y_:valid_data[1]})
    print("Epoch n°" + str(n+1) + "; Accuracy=", current_accuracy * 100, "%")
    if(current_accuracy > max_accuracy):
        max_accuracy = current_accuracy
        n_without_improvement = 0
    else:
        n_without_improvement += 1

    if n_without_improvement > treshold_without_improvement:
        break

final_accuracy = sess.run(accuracy, feed_dict={x:test_data[0], y_:test_data[1]})
print("Final Accuracy=", final_accuracy * 100, "%")

import matplotlib
import matplotlib.pyplot as plt


aux = np.array([[value[i] for value in W.eval()] for i in range(10)])

f, axs = plt.subplots(2, 5)
f.suptitle("Matrice de poids pour chaque classe")

titles = ['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta', 'Theta', 'Iota', 'Kappa']

for i in range(2):
    for j in range(5):
        axs[i][j].imshow(aux[i*5+j].reshape((32,32)),cmap=matplotlib.cm.viridis)
        axs[i][j].axis('off')
        axs[i][j].set_title(titles[i*5+j])

plt.show()

