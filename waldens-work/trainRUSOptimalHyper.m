%% Load relevant files
load('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\training3\PSORUSaugcost.mat')            %"result"
load('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\training3\hyperparameterTuningRUS.mat')  %"results"
load('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\training3\trainingData.mat')
%% extract the optimal hyperparameter values
undersamplingRatio=result.US;
costRatio=result.costRatio;
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

%% train the model

[objective, ~, userdata] = cvobjfun(@RUSboost, hyperparams, undersamplingRatio, ...
        nAugment, crossvalPartition, trainingFeatures, trainingData, trainingLabels, ...
        scanLabels, 'Progress', false, 'UseParallel', false);

save('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\training3\finalModelRUS',"userdata")