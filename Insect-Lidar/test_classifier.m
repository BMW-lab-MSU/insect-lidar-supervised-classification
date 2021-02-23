%%
addpath('../common')

%% Setup data paths
box_dir = 'C:/Users/kyler/Box/Data_2020_Insect_Lidar';

datapaths = {
    [box_dir '/' '2020-07-21'],
    [box_dir '/' '2020-07-31'],
    [box_dir '/' '2020-08-13'],
    [box_dir '/' '2020-08-14'],
    [box_dir '/' '2020-09-16'],
    [box_dir '/' '2020-09-17'],
    [box_dir '/' '2020-09-18'],
    [box_dir '/' '2020-09-20'],
 };
disp('Loading Classifier: WeightedKNN');
trained_model_dir = box_dir;
load([trained_model_dir '/' 'WeightedKNN.mat']);

results = containers.Map();

for datapaths_idx = 5:numel(datapaths)
    datapath = datapaths{datapaths_idx};
    date = datapath(end-4:end);
    disp(['Running on ' date '...']);
    disp('Loading FFTcheck...');
    load([datapath '/' 'events/fftcheck.mat']);
    sub_folders = ls(datapath);
    for files = 3:length(sub_folders)-2
        disp('Loading data...')
        load([datapath '/' sub_folders(files,1:end) '/' 'adjusted_data_decembercal.mat']);
        %TODO: insert label creation function
        labels = extract_labels(fftcheck.insects, adjusted_data_decembercal);
        %TODO: insert feature extraction function
        features = feature_extraction([datapath '/' sub_folders(files,1:end) '/' 'adjusted_data_decembercal']);
        %TODO: add prediction functions
        disp('Classifying...')
        shot.Labels = labels;
        shot.PredictedLabels = logical(WeightedKNN.predictFcn(features));
%         shot.Confusion = confusionmat(shot.Labels, shot.PredictedLabels);
%         [~, precision, recall, f3] = analyze_confusion(shot.Confusion);
%         shot.Precision = precision;
%         shot.Recall = recall;
%         shot.F3 = f3;
% 
%         roi.Labels = groupLabels(labels, TRUE_LABEL_THRESHOLD, WINDOW_SIZE, OVERLAP);
%         roi.PredictedLabels = groupLabels(shot.PredictedLabels, ...
%         PREDICTED_LABEL_THRESHOLD, WINDOW_SIZE, OVERLAP);
%         roi.Confusion = confusionmat(roi.Labels, roi.PredictedLabels);
%         [~, precision, recall, f3] = analyze_confusion(roi.Confusion);
%         roi.Precision = precision;
%         roi.Recall = recall;
%         roi.F3 = f3;
% 
%         results(date) = struct('Shot', shot, 'Roi', roi);
    end
end
%% Create summary of results from all days
shot = struct();
roi = struct();
roi.F3 = 0;
roi.Recall = 0;
roi.Precision = 0;
roi.Confusion = zeros(2);
shot.F3 = 0;
shot.Recall = 0;
shot.Precision = 0;
shot.Confusion = zeros(2);

disp('computing average results');
for date = results.keys
    shot.Precision = shot.Precision + results(date{:}).Shot.Precision;
    shot.Recall = shot.Recall + results(date{:}).Shot.Recall;
    shot.F3 = shot.F3 + results(date{:}).Shot.F3;
    shot.Confusion = shot.Confusion + results(date{:}).Shot.Confusion;

    roi.Precision = roi.Precision + results(date{:}).Roi.Precision;
    roi.Recall = roi.Recall + results(date{:}).Roi.Recall;
    roi.F3 = roi.F3 + results(date{:}).Roi.F3;
    roi.Confusion = roi.Confusion + results(date{:}).Roi.Confusion;
end

% average results
shot.Precision = shot.Precision / double(results.Count);
shot.Recall = shot.Recall / double(results.Count);
shot.F3 = shot.F3 / double(results.Count);
roi.Precision = roi.Precision / double(results.Count);
roi.Recall = roi.Recall / double(results.Count);
roi.F3 = roi.F3 / double(results.Count);

results('average') = struct('Shot', shot, 'Roi', roi);

save('results', 'results', '-v7.3');

%% Display results
for date = results.keys
    disp([date{:} ' results'])
    disp('shot')
    disp(results(date{:}).Shot)
    disp(results(date{:}).Shot.Confusion)
    disp('roi')
    disp(results(date{:}).Roi)
    disp(results(date{:}).Roi.Confusion)
end
    