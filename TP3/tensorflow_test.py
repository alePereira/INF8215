import numpy as np
import tensorflow as tf

# Load data
dataX = np.load("data/dataX.npy")   # images
dataY = np.load("data/dataY.npy")  # labels
formated = np.zeros([len(dataY), 10])

for i in range(len(dataY)):
    formated[i][int(dataY[i])] = 1

dataY = formated

# Data separtion
train_purcentage = 0.5
size = len(dataX)
indice = int(size*train_purcentage)
train_data = (dataX[:indice], dataY[:indice])
test_data = (dataX[indice:], dataY[indice:])

#print(test_data)

# Constants
learning_rate = 0.0005
batch_size = 300
n_iterations = len(train_data[0]) // batch_size
n_epochs = 100

hidden_layer_1_size = 16*16
hidden_layer_2_size = 8*8

# Model

hidden_layer_1 = {'weights': tf.Variable(tf.random_normal([32*32, hidden_layer_1_size])),
                    'bias': tf.Variable(tf.random_normal([hidden_layer_1_size]))}

hidden_layer_2 = {'weights': tf.Variable(tf.random_normal([hidden_layer_1_size, hidden_layer_2_size])),
                    'bias': tf.Variable(tf.random_normal([hidden_layer_2_size]))}

W = tf.Variable(tf.zeros([hidden_layer_2_size, 10]))
b = tf.Variable(tf.zeros([10]))

x = tf.placeholder(tf.float32, [None, 32*32])
y_ = tf.placeholder(tf.float32, [None, 10])

hl1 = tf.matmul(x, hidden_layer_1['weights']) + hidden_layer_1['bias']
hl1 = tf.nn.relu(hl1)

hl2 = tf.matmul(hl1, hidden_layer_2['weights']) + hidden_layer_2['bias']
hl2 = tf.nn.relu(hl2)

y = tf.matmul(hl2, W) + b

cross_entropy = tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y)
train_step = tf.train.AdamOptimizer(learning_rate).minimize(cross_entropy)

sess = tf.InteractiveSession()
sess.run(tf.global_variables_initializer())

# Train part
for n in range(n_epochs):
    for i in range(n_iterations):
        data_xs, data_ys = train_data[0][i*batch_size:(i+1)*batch_size], train_data[1][i*batch_size:(i+1)*batch_size]
        sess.run(train_step, feed_dict={x:data_xs, y_:data_ys})

    # Accuracy
    correct_prediction = tf.equal(tf.argmax(y, 1), tf.argmax(y_,1))
    accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

    print("Epoch n°" + str(n+1) + "; Accuracy=", sess.run(accuracy, feed_dict={x:test_data[0], y_:test_data[1]}) * 100, "%")