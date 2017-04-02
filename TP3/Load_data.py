import theano
import numpy as np
import theano.tensor as T

def load_data():
    # load the data set
    dataset = (np.load("./data/dataX.npy"), np.load("./data/dataY.npy"))

    # Separation : Train=50%, Test=Validation=25%
    data_x, data_y = dataset
    size_x, size_y = len(data_x), len(data_y)
    purcentage_train = 0.5
    purcentage_test = 0.25
    i_end_train = int(size_x * purcentage_train)
    i_end_test = int(size_x * (purcentage_train + purcentage_test))

    train_set = (data_x[:i_end_train], data_y[:i_end_train])
    test_set = (data_x[i_end_train:i_end_test], data_y[i_end_train:i_end_test])
    valid_set = (data_x[i_end_test:], data_y[i_end_test:])

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