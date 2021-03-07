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
load([trained_model_dir '/' 'subspaceDiscriminant.mat']);

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
        
        pred_labels = logical(subspaceDiscriminant.predictFcn(features));
        
        % turn predicted labels into a cell array, where each cell
        % corresponds to one image
        pred_labels_reshape = reshape(pred_labels, size(labels_mat));
        pred_labels_cell = num2cell(pred_labels_reshape,1);
        
        % compute per-row results
        row_results(files - 2).FileName = sub_folders{files};
        row_results(files - 2).PredictedLabels = pred_labels_cell;
        row_results(files - 2).Labels = labels;
        
        confusion = confusionmat(labels_vec, pred_labels);
        if numel(confusion) == 1
            confusion = [confusion 0; 0 0];
        end
        row_results(files - 2).ConfusionMatrix = confusion;

        % compute per-image results
        image_results(files - 2).FileName = sub_folders{files};
        image_results(files - 2).PredictedLabels = cellfun(@(p) any(p), pred_labels_cell);
        image_results(files - 2).Labels = cellfun(@(l) any(l), labels);

        confusion = confusionmat(image_results(files - 2).Labels, image_results(files - 2).PredictedLabels);
        if numel(confusion) == 1
            confusion = [confusion 0; 0 0];
        end
        image_results(files - 2).ConfusionMatrix = confusion;
    end

    results(date) = struct('PerRow', row_results, 'PerImage', image_results);
end

row_total_confusion = zeros(2);
image_total_confusion = zeros(2);

for date = results.keys
    for i = 1:numel(results(date{:}).PerRow)
        row_total_confusion = row_total_confusion + results(date{:}).PerRow(i).ConfusionMatrix;
    end
    for i = 1:numel(results(date{:}).PerImage)
        image_total_confusion = image_total_confusion + results(date{:}).PerImage(i).ConfusionMatrix;
    end
end

disp('row results')
disp(row_total_confusion)
sum(row_total_confusion, 'all')
[a, p, r, f3] = analyze_confusion(row_total_confusion)

disp('image results')
disp(image_total_confusion)
sum(image_total_confusion, 'all')
[a, p, r, f3] = analyze_confusion(image_total_confusion)

toc
    
