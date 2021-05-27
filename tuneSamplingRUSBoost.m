%% Setup
rng(0, 'twister');

datadir = '../data/MLSP-2021';

if isempty(gcp('nocreate'))
    parpool();
end

%% Load data
load([datadir filesep 'training' filesep 'trainingData.mat']);

%% Tune sampling ratios
result = tuneSamplingBase(@rusboost, trainingFeatures, trainingData, ...
    trainingLabels, scanLabels, crossvalPartition, ...
    'Progress', true, 'UseParallel', true);

save([datadir filesep 'training' filesep 'samplingTuningRUSBoost.mat'], 'result')

%% Model fitting function
function model = rusboost(data, labels, ~)
    t = templateTree('Reproducible',true);
    model = compact(fitcensemble(data, labels, 'Method', 'RUSBoost', 'Learners', t, 'ScoreTransform', 'doublelogit'));
end
