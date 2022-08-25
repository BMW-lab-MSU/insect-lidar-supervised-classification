basedir = '../data/projects/optec2022';
%% Load relevant files
load([basedir filesep 'training' filesep 'augCostTuningRUS']);            %"result"
load([basedir filesep 'training' filesep 'hyperparameterTuningRUS.mat'])  %"results"
load([basedir filesep 'training' filesep 'trainingData']);

%% extract the optimal hyperparameter values
undersamplingRatio=result.undersamplingRatio;
costRatio=result.CostRatio;
nAugment=round(result.nAugment);
NumLearningCycles=bestParams.NumLearningCycles;
MaxNumSplits=bestParams.MaxNumSplits;
MinLeafSize=bestParams.MinLeafSize;

%% create hyperparameter structure
hyperparams=struct();
hyperparams.ScoreTransform='doublelogit';
hyperparams.Cost=[0,1;costRatio,0];
hyperparams.ClassNames=logical([0,1]);
hyperparams.SplitCriterion='gdi';
hyperparams.LearnRate=0.1;
hyperparams.NumLearningCycles=NumLearningCycles;
hyperparams.MaxNumSplits=MaxNumSplits;
hyperparams.MinLeafSize=MinLeafSize;

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

%% train the model
model = RUSboost(features, labels, hyperparams);

mkdir([basedir filesep 'training' filesep 'models']);
save([basedir filesep 'training' filesep 'models' filesep 'RUSBoost.mat'] ,"model")
