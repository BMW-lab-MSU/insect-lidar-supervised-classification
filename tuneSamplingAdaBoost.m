% SPDX-License-Identifier: BSD-3-Clause
%% Setup
rng(0, 'twister');

datadir = '../hannah-22';

if isempty(gcp('nocreate'))
    parpool();
end

%% Load data
load([datadir filesep 'combinedTraining' filesep 'trainingData.mat']);

%% Tune sampling ratios
result = tuneSamplingBase(@adaboost, trainingFeatures, trainingData, ...
    trainingLabels, scanLabels, crossvalPartition, ...
    'Progress', true, 'UseParallel', true);

min(result.objective)
result.undersamplingRatio
result.nAugment

save([datadir filesep 'combinedTraining' filesep 'samplingTuningAdaboost.mat'], 'result')

%% Model fitting function
function model = adaboost(data, labels, ~)
    t = templateTree('Reproducible',true);
    model = compact(fitcensemble(data, labels, 'Method', 'AdaBoostM1', 'Learners', t, 'ScoreTransform', 'doublelogit'));
end
