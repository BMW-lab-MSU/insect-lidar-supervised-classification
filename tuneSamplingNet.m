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
result = tuneSamplingBase(@nnet, trainingFeatures, trainingData, ...
    trainingLabels, scanLabels, crossvalPartition, ...
    'Progress', true, 'UseParallel', true);

min(result.objective)
result.undersamplingRatio
result.nAugment

save([datadir filesep 'combinedTraining' filesep 'samplingTuningNet.mat'], 'result')

%% Model fitting function
function model = nnet(data, labels, ~)
    model = compact(fitcnet(data, labels, 'LayerSizes', [100], ...
        'Standardize', true));
end
