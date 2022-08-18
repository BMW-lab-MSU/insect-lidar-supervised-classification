 % SPDX-License-Identifier: BSD-3-Clause
%% Setup
rng(0, 'twister');

datadir = 'C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data';

% if isempty(gcp('nocreate'))
%     parpool();
% end

%% Load data
load([datadir filesep 'training3' filesep 'trainingData.mat']);

load([datadir filesep 'training3' filesep 'PSORUSaugcost.mat'])

%% Tune RUSboost hyperparameters

undersamplingRatio = result.US;
nAugment = round(result.nAugment);
costRatio = result.costRatio;
fixedParams=struct();
fixedParams.CostRatio=costRatio;    %used to calculate weight vector in cvobjfun.m
fixedParams.ScoreTransform='doublelogit';
fixedParams.Cost=[0,1;costRatio,0];
fixedParams.ClassNames=logical([0,1]);
fixedParams.SplitCriterion='gdi';
fixedParams.LearnRate=0.1;

nObservations = height(nestedcell2mat(trainingFeatures));

optimizeVars = [
   optimizableVariable('NumLearningCycles',[10, 200], 'Type', 'integer', 'Transform','log'),...
   optimizableVariable('MaxNumSplits',[1, nObservations - 1],'Transform','log', 'Type', 'integer'),...
   optimizableVariable('MinLeafSize',[1 3],'Transform','log', 'Type', 'integer')
];

minfun = @(optParams)hyperTuneObjFun(@RUSboost, optParams, fixedParams, ...
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

save([datadir filesep 'training3' filesep 'hyperparameterTuningRUS.mat'],...
    'bestParams', '-v7.3');
