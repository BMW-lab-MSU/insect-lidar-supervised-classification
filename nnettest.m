%%
load trainingData

data = vertcat(trainingData{:});
data = vertcat(data{:});
labels = vertcat(trainingLabels{:});
labels = vertcat(labels{:});

%%
hlayer = 70;

net = fitnet(hlayer, 'traingd');
net.trainParam.epochs = 1000;
net.trainParam.min_grad = 1e-6;
net.trainParam.showWindow = false;
net.trainParam.show = 5;
net.trainParam.showCommandLine = true;

x = double(table2array(data)');
x(isnan(x)) = 0;
y = double(labels)';

trained = train(net, x, y, 'useGPU', 'yes');

%%
layers = [...
    featureInputLayer(30)
    fullyConnectedLayer(50)
    reluLayer
    fullyConnectedLayer(2)
    softmaxLayer
    focalLossLayer
];

options = trainingOptions('sgdm', ...
    'MaxEpochs', 20, ...
    'MiniBatchSize', 128, ...
    'Shuffle', 'every-epoch',...
    'Plots', 'none', ...
    'Verbose', true, ...
    'ExecutionEnvironment', 'cpu');

data.Response = categorical(labels);
net = trainNetwork(data, 'Response', layers, options);
