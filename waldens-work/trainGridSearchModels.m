%%
dataDir='C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data';
load([dataDir '\training3\' 'trainingData.mat']);
%%
parsAda=importdata([dataDir '\training3\' 'augCostTuningADA.mat']);
parsRus=importdata([dataDir '\training3\' 'augCostTuningRUS.mat']);
parsNet=importdata([dataDir '\training3\' 'augCostTuningNet.mat']);
undersamplingRatio=0.3;
%% ADAboost
hyperparams=struct();
hyperparams.Cost=[0,1;parsAda.CostRatio,0];
hyperparams.ClassNames=logical([0,1]);
hyperparams.LearnRate=0.1;

[objective, ~, userdata] = cvobjfun(@ADAboost, hyperparams, undersamplingRatio, ...
        parsAda.nAugment, crossvalPartition, trainingFeatures, trainingData, trainingLabels, ...
        scanLabels, 'Progress', false, 'UseParallel', false);

save('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\notFinalButUseful\preIntermediateModels\postGridAda.mat',"userdata")
%% RUSboost
hyperparams=struct();
hyperparams.Cost=[0,1;parsRus.CostRatio,0];
hyperparams.ClassNames=logical([0,1]);
hyperparams.LearnRate=0.1;

[objective, ~, userdata] = cvobjfun(@RUSboost, hyperparams, undersamplingRatio, ...
        parsRus.nAugment, crossvalPartition, trainingFeatures, trainingData, trainingLabels, ...
        scanLabels, 'Progress', false, 'UseParallel', false);

save('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\notFinalButUseful\preIntermediateModels\postGridRus.mat',"userdata")
%% NNet
hyperparams=struct();
hyperparams.CostRatio=parsNet.CostRatio;  %used to calculate weight vector in cvobjfun.m
hyperparams.Verbose=0;
hyperparams.LayerSizes=[100];
hyperparams.Standardize=true;

[objective, ~, userdata] = cvobjfun(@NNet, hyperparams, undersamplingRatio, ...
        parsNet.nAugment, crossvalPartition, trainingFeatures, trainingData, trainingLabels, ...
        scanLabels, 'Progress', false, 'UseParallel', false);

save('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\notFinalButUseful\preIntermediateModels\postGridNet.mat',"userdata")