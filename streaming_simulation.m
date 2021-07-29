% SPDX-License-Identifier: BSD-3-Clause
%% Setup
clear

% if isempty(gcp('nocreate'))
%     parpool();
% end

datadir = '../data/Data_2020_Insect_Lidar/MLSP-2021';

CLASSIFIERS = {'adaboost', 'rusboost', 'nnet'};

%% Load data
load([datadir filesep 'testing' filesep 'testingData.mat'], 'testingData');
images = vertcat(testingData{:});

%%
for classifier = CLASSIFIERS
    disp(['simulating with ' classifier{:} '...'])
    load([datadir filesep 'training' filesep 'models' filesep classifier{:}]);

    profile on

    labels = cell(size(images));

    for i = 1:numel(images)
        features = extractFeatures(images{i}, 'UseParallel', false);
        labels{i} = predict(model, features);
    end

    disp('saving results...')
     profile off
    profsave(profile('info'), [datadir filesep 'runtimes' filesep ...
        classifier{:} '_streaming_simulation']);
end