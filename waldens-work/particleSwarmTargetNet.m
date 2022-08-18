function performance=particleSwarmTargetNet(searchParams)
    %% Setup
    tic
    datadir = 'C:\Users\v59g786\Desktop\REU_project\code_by_walden\paramOptimization\data';
    
    % if isempty(gcp('nocreate'))
    %     parpool();
    % end
    costRatio=searchParams(1);
    nAugment=round(searchParams(2));
    undersamplingRatio=searchParams(3);
    
    %% Load data
    load([datadir filesep 'training3' filesep 'trainingData.mat']);
    
    %% Tune cost, aug number and undersampling ratio
    hyperparams.CostRatio=costRatio;    %used to calculate weight vector in cvobjfun.m
    hyperparams.Verbose=0;
    hyperparams.LayerSizes=[100];
    hyperparams.Standardize=true;

    %undersamplingRatio=0.3;
    [objective, ~, ~] = cvobjfun(@NNet, hyperparams, undersamplingRatio, ...
        nAugment, crossvalPartition, trainingFeatures, trainingData, trainingLabels, ...
        scanLabels, 'Progress', false, 'UseParallel', false);
    performance=objective;
    toc

end
