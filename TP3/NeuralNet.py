import HiddenLayer
import Logreg
import numpy as np
import theano.tensor as T

class NN(object):
    def __init__(self, input, n_in, n_hidden1, n_hidden2, n_out, batch_size):
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