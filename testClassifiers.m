%% Setup
clear

datadir = '../data/Data_2020_Insect_Lidar/MLSP-2021';

%% Load data
load([datadir filesep 'scans.mat']);

imageLabels = vertcat(scans(test(holdoutPartition)).ImageLabels);
clear scans

load([datadir filesep 'testing' filesep 'testingData.mat']);

features = nestedcell2mat(testingFeatures);
labels = nestedcell2mat(testingLabels);


%% Test AdaBoost
disp('Testing AdaBoost....')
disp('---------------')
disp('')
load([datadir filesep 'training' filesep 'models' filesep 'adaboost.mat']);

%%%%%%%%%%%%%%%%%%
% row results
%%%%%%%%%%%%%%%%%%
adaBoost.Row.PredLabels = predict(model, features);

adaBoost.Row.Confusion = confusionmat(labels, adaBoost.Row.PredLabels);

[a, p, r, f2, mcc] = analyzeConfusion(adaBoost.Row.Confusion);
adaBoost.Row.Accuracy = a;
adaBoost.Row.Precision = p;
adaBoost.Row.Recall = r;
adaBoost.Row.F2 = f2;
adaBoost.Row.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% image results
%%%%%%%%%%%%%%%%%%
adaBoost.Image.Confusion = imageConfusion(adaBoost.Row.PredLabels, labels, holdoutPartition);

[a, p, r, f2, mcc] = analyzeConfusion(adaBoost.Image.Confusion);
adaBoost.Image.Accuracy = a;
adaBoost.Image.Precision = p;
adaBoost.Image.Recall = r;
adaBoost.Image.F2 = f2;
adaBoost.Image.MCC = mcc;

%%%%%%%%%%%%%%%%%%
% Display results
%%%%%%%%%%%%%%%%%%
disp('Row results')
disp(adaBoost.Row.Confusion)
disp(adaBoost.Row)
disp('Image results')
disp(adaBoost.Image.Confusion)
disp(adaBoost.Image)
