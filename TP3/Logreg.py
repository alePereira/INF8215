import theano
import numpy as np

class LogisticRegression(object):

    def __init__(self, input, n_in, n_out, batch_size):
        #initialisation des paramètres
        self.W = theano.shared(
            value=np.ones((n_in, n_out),dtype=theano.config.floatX),
            name='W',
            borrow=True
        )
        self.b = theano.shared(
            value=np.ones((n_out,),dtype=theano.config.floatX),
            name='b',
            borrow=True
        )
        #TODO
        self.p_y_given_x = theano.tensor.nnet.softmax(theano.tensor.dot(input, self.W) + self.b)
        #calcul de l'output
        self.y_pred = theano.tensor.argmax(self.p_y_given_x, axis=1)
        self.params = [self.W, self.b]
        self.input = input

    #calcul de la NLL
    def loss(self, y):
        return -theano.tensor.sum(theano.tensor.log(self.p_y_given_x)[theano.tensor.arange(y.shape[0]), y])

    #calcul de l'erreur
    def errors(self, y):
        return theano.tensor.mean(theano.tensor.neq(self.y_pred, y))