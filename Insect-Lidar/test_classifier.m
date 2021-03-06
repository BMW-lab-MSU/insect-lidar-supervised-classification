%% Setup data paths
tic
% box_dir = 'C:/Users/kyler/Box/Data_2020_Insect_Lidar';
box_dir = '../../Data_2020_Insect_Lidar';

datapaths = {
    [box_dir '/' '2020-07-21'];
    [box_dir '/' '2020-07-31'];
    [box_dir '/' '2020-08-13'];
    [box_dir '/' '2020-08-14'];
    [box_dir '/' '2020-09-16'];
    [box_dir '/' '2020-09-17'];
    [box_dir '/' '2020-09-18'];
    [box_dir '/' '2020-09-20'];
 };
%disp('Loading Classifier: CoarseTree');
trained_model_dir = 'classifiers';
load([trained_model_dir '/' 'ldaWeightFN10.mat']);

results = containers.Map();

for datapaths_idx = 6:8   %:numel(datapaths)
    datapath = datapaths{datapaths_idx};
    date = datapath(end-4:end);
    
    disp(['Running on ' date '...']);
    disp('Loading FFTcheck...');
    load([datapath '/' 'events/fftcheck.mat']);
    
    % grab all of the folders, each of which correspond to a single
    % adjusted_data_decmebercal.mat file, for the current date
    sub_folders = {dir(datapath).name};    
    
    for files = 3:length(sub_folders)-2
        disp(['Loading data... ' sub_folders{files}])
        load([datapath '/' sub_folders{files} '/' 'adjusted_data_decembercal.mat']);

        labels = extract_labels(fftcheck.insects, adjusted_data_decembercal);
        
        % convert ground truth labels into a logical vector, for use with
        % confusionmat
        labels = cellfun(@(x) logical(x), labels, 'UniformOutput', false);
        labels_mat = cell2mat(labels);
        labels_vec = labels_mat(:);

        features = feature_extraction([datapath '/' sub_folders{files} '/' 'adjusted_data_decembercal']);
        
        disp(['Classifying... ' sub_folders{files}])
        
        pred_labels = logical(ldaWeightFN10.predictFcn(features));
        
        % turn predicted labels into a cell array, where each cell
        % corresponds to one image
        pred_labels_reshape = reshape(pred_labels, size(labels_mat));
        pred_labels_cell = num2cell(pred_labels_reshape,1);
        
        shot(datapaths_idx - 5,files - 2).PredictedLabels = pred_labels_cell;
        shot(datapaths_idx - 5,files - 2).Labels = labels;
        shot(datapaths_idx - 5,files - 2).ConfusionMatrix = confusionmat(labels_vec,pred_labels);
        shot(datapaths_idx - 5,files - 2).FileName = sub_folders{files};
    end
end

total_confusion = zeros(2);
for folder = 1:size(shot, 1)
    for datafile = 1:size(shot, 2)
        if shot(folder, datafile).ConfusionMatrix
            total_confusion = total_confusion + shot(folder, datafile).ConfusionMatrix;
        else
            %disp(folder)
            %disp(datafile)
        end
    end
end

disp(total_confusion)
[a, p, r, f3] = analyze_confusion(total_confusion)

toc
    
