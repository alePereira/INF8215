import theano
import theano.tensor as T
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
        self.p_y_given_x = 0
        #calcul de l'output
        self.y_pred = 0
        self.params = []
        self.input = 0

    #calcul de la NLL
    def loss(self, y):
        #TODO
        return 0

    #calcul de l'erreur
    def errors(self, y):
        #TODO
        return 0