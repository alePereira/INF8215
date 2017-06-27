import HiddenLayer
import Logreg
import numpy as np
import theano.tensor as T

class NN(object):
    def __init__(self, input, n_in, n_hidden1, n_hidden2, n_out, batch_size):
        """ Permet de créer un réseau de neurones avec 1 ou 2 couches cachée(s).
        si n_hidden2 vaut 0, il n'y a qu'une seule couche, sinon il y en a 2
        """
        self.hidden1 = HiddenLayer.HiddenLayer(input, n_in, n_hidden1)
        if(n_hidden2 != 0):
            self.hidden2 = HiddenLayer.HiddenLayer(self.hidden1.output, n_hidden1, n_hidden2)
            self.logreg = Logreg.LogisticRegression(self.hidden2.output, n_hidden2, n_out, batch_size)
            self.params = self.hidden1.params + self.hidden2.params + self.logreg.params
            self.L2 = (self.hidden1.W ** 2).sum() + (self.hidden2.W ** 2).sum() + (self.logreg.W ** 2).sum()
        else:
            self.logreg = Logreg.LogisticRegression(self.hidden1.output, n_hidden1, n_out, batch_size)
            self.params = self.hidden1.params + self.logreg.params
            self.L2 = (self.hidden1.W ** 2).sum() + (self.logreg.W ** 2).sum()

        self.input = input
        
    
    def NLL(self, y):
        return self.logreg.loss(y)