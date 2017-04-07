from SGD_opt import sgd_optimization

learning_rate = [0.0005]
batch_size = [100]#, 200, 100]
n_epochs = 1000

for lr in learning_rate:
    for bs in batch_size:
        for i in range(5):
            sgd_optimization(n_epochs = 1000, learning_rate = lr, batch_size = bs, id = i, print_debug = False)
            print("Lr = " + str(lr) + " ; bs = " + str(bs) + " ; id = " + str(i) + "... Done")