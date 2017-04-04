import HiddenLayer
import Logreg
import numpy as np
import theano.tensor as T

class NN(object):
    def __init__(self, input, n_in, n_hidden, n_out, batch_size):
        self.hidden = HiddenLayer.HiddenLayer(input, n_in, n_hidden)
        self.logreg = Logreg.LogisticRegression(self.hidden.output, n_hidden, n_out, batch_size)

        self.input = input
        self.params = self.hidden.params + self.logreg.params
        self.L2 = (self.hidden.W ** 2).sum() + (self.logreg.W ** 2).sum()
    
    def NLL(self, y):
        return self.logreg.loss(y)