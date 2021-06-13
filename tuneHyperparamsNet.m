%% Setup
rng(0, 'twister');

datadir = '../data/Data_2020_Insect_Lidar/MLSP-2021';

if isempty(gcp('nocreate'))
    parpool();
end

%% Load data
load([datadir filesep 'training' filesep 'trainingDataMRMR.mat']);

load([datadir filesep 'training' filesep 'samplingTuningNetMRMR'])
undersamplingRatio = result.undersamplingRatio
nAugment = result.nAugment
min(result.objective)
clear result

%% Tune nnet hyperparameters
nObservations = height(nestedcell2mat(trainingFeatures));

optimizeVars = [
   optimizableVariable('LayerSizes',[10,50], 'Type', 'integer'),...
   optimizableVariable('Lambda',1/nObservations * [1e-2,1e2]),...
   optimizableVariable('activations', {'relu', 'tanh', 'sigmoid'}),...
];

minfun = @(hyperparams)cvobjfun(@nnet, hyperparams, ...
    undersamplingRatio, nAugment, crossvalPartition, trainingFeatures, ...
    trainingData, trainingLabels, scanLabels, 'UseParallel', true, ...
    'Progress', true);

results = bayesopt(minfun, optimizeVars, ...
    'IsObjectiveDeterministic', true, 'UseParallel', false, ...
    'AcquisitionFunctionName', 'expected-improvement-plus', ...
    'MaxObjectiveEvaluations', 25);

bestParams = bestPoint(results);

conf = sum(results.UserDataTrace{results.IndexOfMinimumTrace(end)}.confusion,3)
[a, p, r, f2, mcc] = analyzeConfusion(conf)

save([datadir filesep 'training' filesep 'hyperparameterTuningNetMRMR.mat'],...
    'results', 'bestParams', '-v7.3');

%% Model fitting function
function model = nnet(data, labels, params)
    model = compact(fitcnet(data, labels, 'Standardize', true, ...
        'LayerSizes', params.LayerSizes, ...
        'Activations', char(params.activations), ...
        'Lambda', params.Lambda));
end
