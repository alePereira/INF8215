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
    n_train_batches = train_set_x.get_value(borrow=True).shape[0] // batch_size
    n_valid_batches = valid_set_x.get_value(borrow=True).shape[0] // batch_size
    n_test_batches = test_set_x.get_value(borrow=True).shape[0] // batch_size

    #TODO : 1.3.1
    index = T.lscalar()
    x = T.matrix('x')
    y = T.ivector('y')
    logreg = Logreg.LogisticRegression(x, 32*32, 10, batch_size)
    cost = logreg.loss(y)

    test_model = theano.function(
        inputs=[index],
        outputs=logreg.errors(y),
        givens={
            x: test_set_x[index*batch_size:(index+1)*batch_size],
            y: test_set_y[index*batch_size:(index+1)*batch_size]
        }
    )
    validate_model = theano.function(
        inputs=[index],
        outputs=logreg.errors(y),
        givens={
            x: valid_set_x[index*batch_size:(index+1)*batch_size],
            y: valid_set_y[index*batch_size:(index+1)*batch_size]
        }
    )

    g_W = T.grad(cost=cost, wrt=logreg.W)
    g_b = T.grad(cost=cost, wrt=logreg.b)

    updates = [(logreg.W, logreg.W - learning_rate * g_W),
               (logreg.b, logreg.b - learning_rate * g_b)]

    train_model = theano.function(
        inputs=[index],
        outputs=logreg.loss(y),
        updates=updates,
        givens={
            x: train_set_x[index*batch_size:(index+1)*batch_size],
            y: train_set_y[index*batch_size:(index+1)*batch_size]
        }
    )
    #TODO : 1.3.2
    epoch = 0
    min_loss = 1
    n_without_improvement = 0
    threshold_without_improvement = 50

    while epoch < n_epochs:
        epoch = epoch + 1
        for minibatch_index in range(n_train_batches):
            train_model(minibatch_index)

        # Vérification du model à chaque epoch
        validation_state = [validate_model(i) for i in range(n_valid_batches)]
        #print(validation_state)
        validation_loss = np.mean(validation_state)
        print("Epoch n°" + str(epoch) + " Erreur de validation: " + str(validation_loss*100) + "%")

        if(min_loss > validation_loss):
            min_loss = validation_loss
            n_without_improvement = 0
        else:
            n_without_improvement += 1

        if(n_without_improvement > threshold_without_improvement):
            break

    
    test_state = [test_model(i) for i in range(n_test_batches)]
    test_loss = np.mean(test_state)
    print("Fin de l'entrainement avec " + str(epoch) + " epochs. Erreur finale sur l'ensemble de test: " + str(test_loss*100) + "%")

    #TODO : plot with matplotlib the train NLL and the error on test for each minibatch/epoch


if __name__ == '__main__':
    n_epochs=1000
    batch_size=300
    learning_rate=0.001
    sgd_optimization(learning_rate=learning_rate, n_epochs=n_epochs, batch_size=batch_size)