% SPDX-License-Identifier: BSD-3-Clause
%% Setup
rng(0, 'twister');

datadir = '../hannah-22';

if isempty(gcp('nocreate'))
	parpool();
end
statset('UseParallel', true);

%% Load data
load([datadir filesep 'combinedTraining' filesep 'trainingData.mat']);

load([datadir filesep 'combinedTraining' filesep 'samplingTuningRUSBoost'])
load([datadir filesep 'combinedTraining' filesep 'hyperparameterTuningRUSBoost'], 'bestParams')
undersamplingRatio = result.undersamplingRatio
nAugment = result.nAugment
params = bestParams
clear result

%% Undersample the majority class
idxRemove = randomUndersample(...
    scanLabels(training(holdoutPartition)), 0, ...
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
model = rusboost(features, labels, params);

mkdir([datadir filesep 'combinedTraining' filesep 'models']);
save([datadir filesep 'combinedTraining' filesep 'models' filesep 'rusboost'], 'model');

%% Model fitting function
function model = rusboost(data, labels, params)
    t = templateTree('Reproducible',true, ...
       'MaxNumSplits', params.MaxNumSplits, ...
       'MinLeafSize', params.MinLeafSize, ...
       'SplitCriterion', char(params.SplitCriterion));

    model = compact(fitcensemble(data, labels, 'Method', 'RUSBoost', ...
       'Learners', t, 'Cost', [0 1; params.fncost 0], ...
       'NumLearningCycles', params.NumLearningCycles, ...
       'LearnRate', params.LearnRate));
end
