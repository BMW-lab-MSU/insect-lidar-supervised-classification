%%Load relevant files
load('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\training3\PSONetaugcost.mat')
load('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\training3\trainingData.mat')
%%
undersamplingRatio=result.US;
costRatio=result.costRatio;
nAugment=round(result.nAugment);
%%
%trainingFeatures=nestedcell2mat(trainingFeatures);
%trainingLabels=nestedcell2mat(trainingLabels);
%% 
hyperparams.CostRatio=costRatio;    %used to calculate weight vector in cvobjfun.m
hyperparams.Verbose=1;
hyperparams.LayerSizes=[100];
hyperparams.Standardize=true;


[objective, ~, userdata] = cvobjfun(@NNet, hyperparams, undersamplingRatio, ...
        nAugment, crossvalPartition, trainingFeatures, trainingData, trainingLabels, ...
        scanLabels, 'Progress', false, 'UseParallel', false);

save('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\training3\Net_w_optimal_imbal_params.mat',"userdata")