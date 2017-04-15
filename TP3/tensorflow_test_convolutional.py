import numpy as np
import tensorflow as tf
import random

# Load data
dataX = np.load("data/dataX.npy")   # images
dataY = np.load("data/dataY.npy")  # labels
formated = np.zeros([len(dataY), 10])

for i in range(len(dataY)):
    formated[i][int(dataY[i])] = 1

dataY = formated

def shuffle_data(dataX, dataY):
    random_permutation = np.random.permutation(len(dataX))
    return (dataX[random_permutation], dataY[random_permutation])

dataX, dataY = shuffle_data(dataX, dataY)

# Data separtion
train_purcentage = 0.8
test_purcentage = 0.1
size = len(dataX)
indice = int(size*train_purcentage)
indice_test = int(size * (train_purcentage + test_purcentage))
train_data = (dataX[:indice], dataY[:indice])
test_data = (dataX[indice:indice_test], dataY[indice:indice_test])
valid_data = (dataX[indice_test:], dataY[indice_test:])

#print(test_data)

# Constants
learning_rate = 0.0001
batch_size = 300
n_iterations = len(train_data[0]) // batch_size
n_epochs = 1000

def weight_variable(shape):
    initial = tf.truncated_normal(shape, stddev=0.1)
    return tf.Variable(initial)

def bias_variable(shape):
    initial = tf.constant(0.1, shape=shape)
    return tf.Variable(initial)

def conv2d(x, W):
    return tf.nn.conv2d(x, W, strides=[1, 1, 1, 1], padding='SAME')

def max_pool_2x2(x):
    return tf.nn.max_pool(x, ksize=[1, 2, 2, 1],
                        strides=[1, 2, 2, 1], padding='SAME')

x = tf.placeholder(tf.float32, [None, 32*32])
y_ = tf.placeholder(tf.float32, [None, 10])

x_image = tf.reshape(x, [-1,32,32,1])

W_conv1 = weight_variable([5, 5, 1, 37])
b_conv1 = bias_variable([37])

h_conv1 = tf.nn.relu(conv2d(x_image, W_conv1) + b_conv1)
h_pool1 = max_pool_2x2(h_conv1)

W_conv2 = weight_variable([5, 5, 37, 74])
b_conv2 = bias_variable([74])

h_conv2 = tf.nn.relu(conv2d(h_pool1, W_conv2) + b_conv2)
h_pool2 = max_pool_2x2(h_conv2)

W_fc1 = weight_variable([8 * 8 * 74, 1024])
b_fc1 = bias_variable([1024])

h_pool2_flat = tf.reshape(h_pool2, [-1, 8*8*74])
h_fc1 = tf.nn.relu(tf.matmul(h_pool2_flat, W_fc1) + b_fc1)

keep_prob = tf.placeholder(tf.float32)
h_fc1_drop = tf.nn.dropout(h_fc1, keep_prob)

W_fc2 = weight_variable([1024, 10])
b_fc2 = bias_variable([10])

y_conv = tf.matmul(h_fc1_drop, W_fc2) + b_fc2

cross_entropy = tf.nn.softmax_cross_entropy_with_logits(labels=y_, logits=y_conv)
train_step = tf.train.AdamOptimizer(learning_rate).minimize(cross_entropy)

sess = tf.InteractiveSession()
sess.run(tf.global_variables_initializer())

# Accuracy
correct_prediction = tf.equal(tf.argmax(y_conv, 1), tf.argmax(y_,1))
accuracy = tf.reduce_mean(tf.cast(correct_prediction, tf.float32))

n_without_improvement = 0
threshold_without_improvement = 50
max_accuracy = 0
accuracies = []

# Train part
for n in range(n_epochs):
    #Shuffle train data
    train_data = shuffle_data(train_data[0], train_data[1])
    for i in range(n_iterations):
        data_xs, data_ys = train_data[0][i*batch_size:(i+1)*batch_size], train_data[1][i*batch_size:(i+1)*batch_size]
        sess.run(train_step, feed_dict={x:data_xs, y_:data_ys, keep_prob: 0.5})

    train_accuracy = accuracy.eval(feed_dict={x:valid_data[0], y_: valid_data[1], keep_prob: 1.0})
    print("Epoch n°" + str(n+1) + "; Accuracy=", train_accuracy*100, "%")
    accuracies.append(train_accuracy)

    if(train_accuracy > max_accuracy):
        max_accuracy = train_accuracy
        n_without_improvement = 0
        test_accuracy = accuracy.eval(feed_dict={x:test_data[0], y_: test_data[1], keep_prob: 1.0})
        print("\tBetter accuracy... Test Accuracy=", test_accuracy * 100, "%")

    if(n_without_improvement > threshold_without_improvement):
        break
    else:
        n_without_improvement += 1

test_accuracy = accuracy.eval(feed_dict={x:test_data[0], y_: test_data[1], keep_prob: 1.0})
print("Training's over... Test Accuracy=", test_accuracy * 100, "%")

import matplotlib
import matplotlib.pyplot as plt


plt.plot(accuracies)

plt.show()