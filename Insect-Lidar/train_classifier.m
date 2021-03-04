box_dir = 'C:/Users/kyler/Box/Data_2020_Insect_Lidar';
datapath = [box_dir '/' '2020-09-16'];
load([datapath '/' 'events/fftcheck.mat']);
sub_folders = ls(datapath);
for files = 3:length(sub_folders)-2
    disp(['Loading data... ' sub_folders(files,1:end)])
    load([datapath '/' sub_folders(files,1:end) '/' 'adjusted_data_decembercal.mat']);
    labels = extract_labels(fftcheck.insects, adjusted_data_decembercal);
    labels = cellfun(@(x) logical(x), labels, 'UniformOutput', false);
    labels_mat = cell2mat(labels);
    [h,w] = size(labels_mat);
    labels_mat = reshape(labels_mat,h*w,1);
    features = feature_extraction([datapath '/' sub_folders(files,1:end) '/' 'adjusted_data_decembercal']);
    if files == 3
        labels_tot = labels_mat;
        features_tot = features;
    else
        labels_tot = [labels_tot; labels_mat];
        features_tot = [features_tot; features];
    end
end
for_classification = [labels_tot features_tot];
disp("Yo, I'm done");

% disp('loading training data');
% box_dir = 'C:/Users/kyler/Box/Data_2020_Insect_Lidar';
% load([box_dir '/' 'training_data_09-24_undersampled75_just_fish']);
% 
% %% Train the RUSBoost ensemble
% disp('training Coarse Tree ensemble');
% rusBoost = trainClassifier([data.xpol_processed; data.labels].');
% save([box_dir filesep 'rusBoost'], 'rusBoost');
