import Load_data
import theano.tensor as T
import Logreg
import theano
import numpy as np
import matplotlib.pyplot as plt



def sgd_optimization(learning_rate=0.13, n_epochs=1000,
                           batch_size=300):
    datasets = Load_data.load_data()

    train_set_x, train_set_y = datasets[0]
    valid_set_x, valid_set_y = datasets[1]
    test_set_x, test_set_y = datasets[2]

    # TODO : compute number of minibatches for training, validation and testing from the size of a minibatch
    n_train_batches = 0
    n_valid_batches = 0
    n_test_batches =0

    #TODO : 1.3.1
    logreg = Logreg.LogisticRegression()
    test_model = theano.function(
        #TODO
    )
    validate_model = theano.function(
        #TODO
    )

    g_W = 0#TODO
    g_b = 0#TODO
    updates = [(logreg.W, logreg.W - learning_rate * g_W),
               (logreg.b, logreg.b - learning_rate * g_b)]
    train_model = theano.function(
        #TODO
    )
    #TODO : 1.3.2
    while epoch < n_epochs:
        epoch = epoch + 1
        for minibatch_index in range(n_train_batches):
            print()
            # TODO train model
        # TODO : valid model, print error
    # TODO : test model, print result

    #TODO : plot with matplotlib the train NLL and the error on test for each minibatch/epoch


if __name__ == '__main__':
    n_epochs=0;batch_size=0;learning_rate=0
    sgd_optimization(n_epochs,batch_size, learning_rate)