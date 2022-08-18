function performance=particleSwarmTargetSVM(searchParams)
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
    
    %% Tune cost and aug ratios
    
    hyperparams=struct();
    hyperparams.ShrinkagePeriod=1000;
    hyperparams.Solver='ISDA';
    hyperparams.IterationLimit=30E3;
    hyperparams.Verbose=0;

    hyperparams.Cost=[0,1;costRatio,0];
    hyperparams.ClassNames=logical([0,1]);

    %undersamplingRatio=0.3;
    [objective, ~, ~] = cvobjfun(@twoClassSVM, hyperparams, undersamplingRatio, ...
        nAugment, crossvalPartition, trainingFeatures, trainingData, trainingLabels, ...
        scanLabels, 'Progress', false, 'UseParallel', false);
    performance=objective;
    toc

end
