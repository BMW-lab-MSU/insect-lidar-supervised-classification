function [train,test] = randomizeData(data_size,train_size)
all_indicies = 1:data_size;
train = randsample(data_size, train_size);
test = setdiff(all_indicies,train);
