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
    threshold_without_improvement = 100
    errors = []

    while epoch < n_epochs:
        epoch = epoch + 1
        for minibatch_index in range(n_train_batches):
            train_model(minibatch_index)

        # Vérification du model à chaque epoch
        validation_state = [validate_model(i) for i in range(n_valid_batches)]
        #print(validation_state)
        validation_loss = np.mean(validation_state)
        errors.append(validation_loss)
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
    # Plot de l'évolution du taux d'erreur et aussi la matrice de poids (rouge noir = poids négatif ; blanc = poids positif)
    import matplotlib
    import matplotlib.pyplot as plt

    test_error_line = [test_loss] * epoch

    ax_error = plt.subplot2grid((2,10), (0,0), colspan=5, rowspan=2)
    ax_error.plot(errors)
    ax_error.plot(test_error_line, 'r--')
    ax_error.set_title("learning_rate = " + str(learning_rate))

    aux = np.array([[value[i] for value in logreg.W.get_value()] for i in range(10)])

    titles = ['Alpha', 'Beta', 'Gamma', 'Delta', 'Epsilon', 'Zeta', 'Eta', 'Theta', 'Iota', 'Kappa']

    for i in range(2):
        for j in range(5):
            axs = plt.subplot2grid((2,10), (i,j+5))
            axs.imshow(aux[i*5+j].reshape((32,32)),cmap=matplotlib.cm.hot)
            axs.axis('off')
            axs.set_title(titles[i*5+j])

    plt.show()


if __name__ == '__main__':
    n_epochs=1000
    batch_size=200
    learning_rate=0.00005
    sgd_optimization(learning_rate=learning_rate, n_epochs=n_epochs, batch_size=batch_size)