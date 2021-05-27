%% Setup
rng(0, 'twister');

datadir = '/home/trevor/research/afrl/data/Data_2020_Insect_Lidar/MLSP-2021';

if isempty(gcp('nocreate'))
    parpool();
end

%% Load data
load([datadir filesep 'training' filesep 'trainingData.mat']);

%% Tune sampling ratios
result = tuneSamplingBase(@adaboost, trainingFeatures, trainingData, ...
    trainingLabels, scanLabels, crossvalPartition, ...
    'Progress', true, 'UseParallel', true);

save([datadir filesep 'training' filesep 'samplingTuningAdaboost.mat'], 'result')

%% Model fitting function
function model = adaboost(data, labels, ~)
    t = templateTree('Reproducible',true);
    model = compact(fitcensemble(data, labels, 'Method', 'AdaBoostM1', 'Learners', t, 'ScoreTransform', 'doublelogit'));
end
