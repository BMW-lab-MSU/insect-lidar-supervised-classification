%%
addpath('../common')

%% Setup data paths
tic
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

for datapaths_idx = 5   %:numel(datapaths)
    datapath = datapaths{datapaths_idx};
    date = datapath(end-4:end);
    disp(['Running on ' date '...']);
    disp('Loading FFTcheck...');
    load([datapath '/' 'events/fftcheck.mat']);
    sub_folders = ls(datapath);
    for files = 3:length(sub_folders)-2
        disp(['Loading data... ' sub_folders(files,1:end)])
        load([datapath '/' sub_folders(files,1:end) '/' 'adjusted_data_decembercal.mat']);
        %TODO: insert label creation function
        labels = extract_labels(fftcheck.insects, adjusted_data_decembercal);
        %TODO: insert feature extraction function
        features = feature_extraction([datapath '/' sub_folders(files,1:end) '/' 'adjusted_data_decembercal']);
        %TODO: add prediction functions
        disp(['Classifying... ' sub_folders(files,1:end)])
        %TODO: turn final answer into a 1 by 109 cell array where each cell
        %is 178 by 1 cell array
        pred_labels = logical(WeightedKNN.predictFcn(features));
        pred_labels_reshape = reshape(pred_labels,109,178);
        pred_labels_cell = mat2cell(pred_labels_reshape,109,1,178);
        shot(files - 2).PredictedLabels = pred_labels_reshape;
        shot(files - 2).Labels = labels;
        %TODO: add confusion mat to shot structure
        shot(files-2).ConfusionMatrix = confusionmat(double(labels(:)),double(pred_labels_cell(:)));
    end
end
toc
    