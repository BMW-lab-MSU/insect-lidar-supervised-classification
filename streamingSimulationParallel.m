% SPDX-License-Identifier: BSD-3-Clause
%% Setup
clear

if isempty(gcp('nocreate'))
    parpool();
end

datadir = '../data/insect-lidar/MLSP-2021';

CLASSIFIERS = {'adaboost', 'rusboost', 'nnet'};

datafilename = [datadir filesep 'testing' filesep 'streamingSimData.mat'];
matobj = matfile(datafilename);
N_IMAGES = size(matobj, 'images', 1);

%%
for classifier = CLASSIFIERS
    disp(['simulating with ' classifier{:} '...'])
    load([datadir filesep 'training' filesep 'models' filesep classifier{:}]);

    imageReader = dsp.MatFileReader(datafilename, 'images', 178);

    labels = cell(N_IMAGES, 1);

    runtimes = zeros(N_IMAGES, 1);
    dataLoadtime = zeros(N_IMAGES, 1);
    predictionRuntime = zeros(N_IMAGES, 1);
    featureExtractionRuntime = zeros(N_IMAGES, 1);
    preprocessingRuntime = zeros(N_IMAGES, 1);

    profile on

    % stream in the data
    imageNum = 0;
    while ~imageReader.isDone
        tStart = tic;

        imageNum = imageNum + 1;

        img = imageReader();

        dataLoadtime(imageNum) = toc(tStart);

        tPreprocessingStart = tic;

        img = normalize(img, 'range');

        preprocessingRuntime(imageNum) = toc(tPreprocessingStart);

        tFeatureExtractionStart = tic;
        features = extractFeatures(img, 'UseParallel', true);

        featureExtractionRuntime(imageNum) = toc(tFeatureExtractionStart);

        tPredictStart = tic;

        labels{imageNum} = predict(model, features);

        predictionRuntime(imageNum) = toc(tPredictStart);

        runtimes(imageNum) = toc(tStart);
    end

     profile off

    disp('saving results...')

    meanDataLoadtime = mean(dataLoadtime);
    maxDataLoadtime = max(dataLoadtime);
    stdDataLoadtime = std(dataLoadtime);
    meanFeatureExtractionRuntime = mean(featureExtractionRuntime);
    maxFeatureExtractionRuntime = max(featureExtractionRuntime);
    stdFeatureExtractionRuntime = std(featureExtractionRuntime);
    meanPredictionRuntime = mean(predictionRuntime);
    maxPredictionRuntime = max(predictionRuntime);
    stdPredictionRuntime = std(predictionRuntime);
    meanRuntime = mean(runtimes);
    maxRuntime = max(runtimes);
    stdRuntime = std(runtimes);
    meanPreprocessingRuntime = mean(preprocessingRuntime);
    maxPreprocessingRuntime = max(preprocessingRuntime);
    stdPreprocessingRuntime = std(preprocessingRuntime);


    save([datadir filesep 'runtimes' filesep classifier{:} ...
        '_parallel_streaming_simulation.mat'], 'meanDataLoadtime', ...
        'maxDataLoadtime', 'stdDataLoadtime', 'meanFeatureExtractionRuntime',...
        'maxFeatureExtractionRuntime', 'stdFeatureExtractionRuntime', ...
        'meanPredictionRuntime', 'maxPredictionRuntime', ...
        'stdPredictionRuntime', 'meanRuntime', 'maxRuntime', 'stdRuntime', ...
        'meanPreprocessingRuntime', 'maxPreprocessingRuntime', ...
        'stdPreprocessingRuntime', 'dataLoadtime','featureExtractionRuntime',...
        'predictionRuntime', 'runtimes', 'preprocessingRuntime')

    profsave(profile('info'), [datadir filesep 'runtimes' filesep ...
        classifier{:} '_parallel_streaming_simulation']);
end