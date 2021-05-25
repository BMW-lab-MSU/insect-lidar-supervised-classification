function [objective, constraints, userdata] = cvobjfun(fitcfun, hyperparams, undersamplingRatio, crossvalPartition, data, labels, scanLabel, opts)
% cvobjfun Optimize hyperparameters via cross-validation
arguments
    fitcfun (1,1) function_handle
    hyperparams
    undersamplingRatio (1,1) double
    crossvalPartition (1,1) cvpartition
    data (:,1) cell
    labels (:,1) cell
    scanLabel (:,1) logical
    opts.Progress (1,1) logical = false
end

MINORITY_LABEL = 0;

crossvalConfusion = zeros(2, 2, crossvalPartition.NumTestSets);
losses = nan(1, crossvalPartition.NumTestSets);

if opts.Progress
    progressbar = ProgressBar(crossvalPartition.NumTestSets, ...
        'UpdateRate', inf, 'Title', 'Cross validation');
    progressbar.setup([], [], []);
end

for i = 1:crossvalPartition.NumTestSets
    % Get validation and training partitions
    validationSet = test(crossvalPartition, i); 
    trainingSet = training(crossvalPartition, i);
    
    trainingDataScans = data(trainingSet);
    trainingLabelScans = labels(trainingSet);

    % Undersample the majority class
    idxRemove = randomUndersample(...
        scanLabel(trainingSet), MINORITY_LABEL, ...
        'UndersamplingRatio', undersamplingRatio, ...
        'Reproducible', true, 'Seed', i);
    
    trainingDataScans(idxRemove) = [];
    trainingLabelScans(idxRemove) = [];
    
    % Un-nest data out of cell arrays
    trainingData = nestedcell2mat(trainingDataScans);
    trainingLabels = nestedcell2mat(trainingLabelScans);
    testingData = nestedcell2mat(data(validationSet));
    testingLabels = nestedcell2mat(labels(validationSet));
    
    % Train the model
    model = fitcfun(trainingData, trainingLabels, hyperparams);

    % Predict labels on the validation set
    predLabels = predict(model, testingData);

    % Compute performance metrics
    crossvalConfusion(:, :, i) = confusionmat(testingLabels, predLabels);

    losses(i) = loss(model, testingData, testingLabels, 'loss', @focalLoss);
    
    if opts.Progress
        progressbar([], [], []);
    end
end

if opts.Progress
    progressbar.release();
end

% [~, ~, ~, f2score] = analyzeConfusion(sum(crossvalConfusion, 3));
objective = mean(losses);

constraints = [];

userdata.confusion = crossvalConfusion;
end
