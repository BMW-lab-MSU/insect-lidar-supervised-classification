% SPDX-License-Identifier: BSD-3-Clause
%% Setup
rng(0, 'twister');

datadir = 'C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data';

% if isempty(gcp('nocreate'))
%     parpool();
% end

%% Load data
load([datadir filesep 'training3' filesep 'trainingData.mat']);

load([datadir filesep 'training3' filesep 'PSONetaugcost.mat'])

%% Tune nnet hyperparameters

undersamplingRatio = result.US;
nAugment = round(result.nAugment);
fixedParams=struct();
fixedParams.CostRatio=result.costRatio;    %used to calculate weight vector in cvobjfun.m
fixedParams.Verbose=0;
fixedParams.Standardize=true;

nObservations = height(nestedcell2mat(trainingFeatures));

optimizeVars = [
   optimizableVariable('LayerSizes',[10,300], 'Type', 'integer', 'Transform', 'log'),...
   optimizableVariable('Lambda',1/nObservations * [1e-5,1e5], 'Transform', 'log'),...
   optimizableVariable('activations', {'relu', 'tanh', 'sigmoid'}),...
];

minfun = @(optParams)hyperTuneObjFun(@NNet, optParams, fixedParams, ...
    undersamplingRatio, nAugment, crossvalPartition, trainingFeatures, ...
    trainingData, trainingLabels, scanLabels, 'UseParallel', false, ...
    'Progress', false);
%hyperTuneObjFun() is identical to cvobjfun() except that it takes two
%hyperparam arguments and concatenates them inside. This allows us to keep
%some hyperparams fixed while varying others

results = bayesopt(minfun, optimizeVars, ...
    'IsObjectiveDeterministic', true, 'UseParallel', false, ...
    'AcquisitionFunctionName', 'expected-improvement-plus', ...
    'MaxObjectiveEvaluations', 100, 'Verbose', 1);

bestParams = bestPoint(results);

sum(results.UserDataTrace{results.IndexOfMinimumTrace(end)}.confusion,3)

save([datadir filesep 'training3' filesep 'hyperparameterTuningNet.mat'],...
    'bestParams', '-v7.3');
