%% Setup
rng(0, 'twister');

datadir = '/home/trevor/research/afrl/data/Data_2020_Insect_Lidar/MLSP-2021';

%% Load data
load([datadir filesep 'training' filesep 'trainingData.mat']);

load([datadir filesep 'training' filesep 'samplingTuningAdaboost'])
load([datadir filesep 'training' filesep 'hyperparameterTuningAdaboost'], 'bestParams')
undersamplingRatio = result.undersamplingRatio
nAugment = result.nAugment
params = bestParams
clear result

%% Undersample the majority class
idxRemove = randomUndersample(...
    scanLabel, MINORITY_LABEL, ...
    'UndersamplingRatio', undersamplingRatio, ...
    'Reproducible', true);

trainingFeatures(idxRemove) = [];
trainingData(idxRemove) = [];
trainingLabels(idxRemove) = [];

%% Un-nest data/labels
data = nestedcell2mat(trainingData);
features = nestedcell2mat(trainingFeatures);
labels = nestedcell2mat(trainingLabels);

%% Create synthetic features
[synthFeatures, synthLabels] = dataAugmentation(data, ...
    labels, nAugment, 'UseParallel', true);

features = vertcat(features, synthFeatures);
labels = vertcat(labels, synthLabels);
clear('synthFeatures', 'synthLabels');

%% Train the model
model = adaboost(features, labels, params);

mkdir([datadir filesep 'training' filesep ' models']);
save([datadir filesep 'training' filesep 'models' filesep 'adaboost'], 'model');

%% Model fitting function
function model = adaboost(data, labels, params)
    t = templateTree('Reproducible',true, ...
       'MaxNumSplits', params.MaxNumSplits, ...
       'MinLeafSize', params.MinLeafSize, ...
       'SplitCriterion', char(params.SplitCriterion));

    model = compact(fitcensemble(data, labels, 'Method', 'AdaBoostM1', ...
       'Learners', t, 'Cost', [0 1; params.fncost 0], ...
       'NumLearningCycles', params.NumLearningCycles, ...
       'LearnRate', params.LearnRate));
end
