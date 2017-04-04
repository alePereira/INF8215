import theano
import numpy as np
import theano.tensor as T

def load_data():

    # Load data
    dataX = np.load("data/dataX.npy")   # images
    dataY = np.load("data/dataY.npy")  # labels

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
    train_set = (dataX[:indice_train], dataY[:indice_train])
    test_set = (dataX[indice_train:indice_test], dataY[indice_train:indice_test])
    valid_set = (dataX[indice_test:], dataY[indice_test:])

    print('... loading data')

    def shared_dataset(data_xy, borrow=True):
        data_x, data_y = data_xy
        shared_x = theano.shared(np.asarray(data_x, dtype=theano.config.floatX), borrow=borrow)
        shared_y = theano.shared(np.asarray(data_y, dtype=theano.config.floatX), borrow=borrow)
        return shared_x, T.cast(shared_y, 'int32')

    test_set_x, test_set_y = shared_dataset(test_set)
    valid_set_x, valid_set_y = shared_dataset(valid_set)
    train_set_x, train_set_y = shared_dataset(train_set)

    rval = [(train_set_x, train_set_y), (valid_set_x, valid_set_y),
            (test_set_x, test_set_y)]
    return rval