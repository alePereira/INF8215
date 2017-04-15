from SGD_opt import sgd_optimization
from NLP import test_mlp

learning_rate = [0.01, 0.001, 0.0001]
batch_size = [100, 200, 300]
L2 = [0.1, 0.01, 0.001]
hidden_size = [32*16, 16*16, 8*16, 8*8]
n_epochs = 1000
best_parameters = None
min_error = 1.0

for lr in learning_rate:
    for bs in batch_size:
        for l2_coeff in L2:
            for hs in hidden_size:
                parameters = {'learning_rate':lr, 'batch_size':bs, 'L2_reg':l2_coeff, 'n_hidden':hs}
                # sgd_optimization(n_epochs = 1000, learning_rate = lr, batch_size = bs, id = i, print_debug = False)
                # print("Lr = " + str(lr) + " ; bs = " + str(bs) + " ; id = " + str(i) + "... Done")
                print(str(parameters), "Starting...")
                error = test_mlp(learning_rate=lr, n_epochs=n_epochs, batch_size=bs, L2_reg = l2_coeff, n_hidden1=hs, print_debug=False)         
                print("Over with error : ", error * 100, "%")     
                if error < min_error:
                    min_error = error
                    best_parameters = parameters

print("Over, best parameters found:")
print(str(best_parameters))
print("With min error:", min_error*100, "%")