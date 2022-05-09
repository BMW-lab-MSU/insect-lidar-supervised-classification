% SPDX-License-Identifier: BSD-3-Clause
%% Setup
clear

if isempty(gcp('nocreate'))
    parpool();
end

% Set random number generator properties for reproducibility
rng(0, 'twister');

datadir = '../hannah-22';
datafile = 'scans.mat';
hdatafile = 'hscans.mat';

%%Load Hyalite data and assign to hscans
load([datadir filesep hdatafile])
hscans = scans;

%% Load data
load([datadir filesep datafile])


%% Extract features
scanFeatures = cell(numel(scans), 1);

for i = progress(1:numel(scans))
    scanFeatures{i} = cellfun(@(X) extractFeatures(X, 'UseParallel', true), ...
        scans(i).Data, 'UniformOutput', false);
end

hscanFeatures = cell(numel(hscans), 1);

for i = progress(1:numel(hscans))
    hscanFeatures{i} = cellfun(@(X) extractFeatures(X, 'UseParallel', true), ...
        hscans(i).Data, 'UniformOutput', false);
end

%%
labels = {scans.Labels}';
scanLabels = vertcat(scans.ScanLabel);

hlabels = {hscans.Labels}';
hscanLabels = vertcat(hscans.ScanLabel);

%% Partition into training and test sets
TEST_PCT = 0.2;

holdoutPartition = cvpartition(scanLabels, 'Holdout', TEST_PCT, 'Stratify', true);


trainingData = vertcat({scans(training(holdoutPartition)).Data}', hscans.Data);
testingData = {scans(test(holdoutPartition)).Data}';
trainingFeatures = vertcat(scanFeatures(training(holdoutPartition)), hscanFeatures);
testingFeatures = scanFeatures(test(holdoutPartition));
trainingLabels = vertcat(labels(training(holdoutPartition)), hlabels);
testingLabels = labels(test(holdoutPartition));

%% Partition the data for k-fold cross validation
N_FOLDS = 5;

crossvalPartition = cvpartition(scanLabels(training(holdoutPartition)), ...
    'KFold', N_FOLDS, 'Stratify', true);


%% Save training and testing data
mkdir(datadir, 'combinedTesting');
save([datadir filesep 'combinedTesting' filesep 'testingData.mat'], ...
    'testingData', 'testingFeatures', 'testingLabels', ...
    'holdoutPartition', 'scanLabels', '-v7.3');

mkdir(datadir, 'combinedTraining');
save([datadir filesep 'combinedTraining' filesep 'trainingData.mat'], ...
    'trainingData', 'trainingFeatures', 'trainingLabels', ...
    'crossvalPartition', 'holdoutPartition', 'scanLabels', '-v7.3');
