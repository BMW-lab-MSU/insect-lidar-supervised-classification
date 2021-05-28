function [objective, constraints, userdata] = cvobjfun(fitcfun, hyperparams, undersamplingRatio, nAugment, crossvalPartition, features, data, labels, scanLabel, opts)
% cvobjfun Optimize hyperparameters via cross-validation
arguments
    fitcfun (1,1) function_handle
    hyperparams
    undersamplingRatio (1,1) double
    nAugment (1,1) double
    crossvalPartition (1,1) cvpartition
    features (:,1) cell
    data (:,1) cell
    labels (:,1) cell
    scanLabel (:,1) logical
    opts.Progress (1,1) logical = false
    opts.UseParallel (1,1) logical = false
end

MINORITY_LABEL = 0;

if opts.UseParallel
    statset('UseParallel', true);
end

crossvalConfusion = zeros(2, 2, crossvalPartition.NumTestSets);
% losses = nan(1, crossvalPartition.NumTestSets);
models = cell(1, crossvalPartition.NumTestSets);

if opts.Progress
    progressbar = ProgressBar(crossvalPartition.NumTestSets, ...
        'UpdateRate', inf, 'Title', 'Cross validation');
    progressbar.setup([], [], []);
end

for i = 1:crossvalPartition.NumTestSets
    % Get validation and training partitions
    validationSet = test(crossvalPartition, i); 
    trainingSet = training(crossvalPartition, i);
    
    trainingFeatureScans = features(trainingSet);
    trainingDataScans = data(trainingSet);
    trainingLabelScans = labels(trainingSet);

    % Undersample the majority class
    idxRemove = randomUndersample(...
        scanLabel(trainingSet), MINORITY_LABEL, ...
        'UndersamplingRatio', undersamplingRatio, ...
        'Reproducible', true, 'Seed', i);
    
    trainingFeatureScans(idxRemove) = [];
    trainingDataScans(idxRemove) = [];
    trainingLabelScans(idxRemove) = [];
    
    % Un-nest data out of cell arrays
    trainingFeatures = nestedcell2mat(trainingFeatureScans);
    trainingData = nestedcell2mat(trainingDataScans);
    trainingLabels = nestedcell2mat(trainingLabelScans);
    testingFeatures = nestedcell2mat(features(validationSet));
    testingLabels = nestedcell2mat(labels(validationSet));

    clear('trainingDataScans', 'trainingLabelScans', 'trainingFeatureScans');

    % Create synthetic features
    [synthFeatures, synthLabels] = dataAugmentation(trainingData, ...
        trainingLabels, nAugment, 'UseParallel', opts.UseParallel);
    trainingFeatures = vertcat(trainingFeatures, synthFeatures);
    trainingLabels = vertcat(trainingLabels, synthLabels);
    clear('synthFeatures', 'synthLabels');
    
    % Train the model
    models{i} = fitcfun(trainingFeatures, trainingLabels, hyperparams);

    % Predict labels on the validation set
    predLabels = predict(models{i}, testingFeatures);

    % Compute performance metrics
    crossvalConfusion(:, :, i) = confusionmat(testingLabels, predLabels);

    % losses(i) = loss(models{i}, testingData, testingLabels, 'loss', @focalLoss);
    
    if opts.Progress
        progressbar([], [], []);
    end
end

if opts.Progress
    progressbar.release();
end

[~, ~, ~, f2, mcc] = analyzeConfusion(sum(crossvalConfusion, 3));
objective = -f2;

constraints = [];

userdata.confusion = crossvalConfusion;
userdata.model = models;
userdata.f2 = f2;
userdata.mcc = mcc;
end
