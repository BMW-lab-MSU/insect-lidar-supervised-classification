addpath('..')

box_dir = '/mnt/data/trevor/research/afrl/Data_2020_Insect_Lidar';

datapath = [box_dir '/' '2020-09-16'];

load([datapath '/' 'events/fftcheck.mat']);

sub_folders = {dir(datapath).name};

for files = 3:length(sub_folders)-2
    disp(['Loading data... ' sub_folders{files}])
    load([datapath '/' sub_folders{files} '/' 'adjusted_data_decembercal.mat']);
    
    labels = extract_labels(fftcheck.insects, adjusted_data_decembercal);
    labels = cellfun(@(x) logical(x), labels, 'UniformOutput', false);
    labels_mat = cell2mat(labels);
    [h,w] = size(labels_mat);
    labels_mat = reshape(labels_mat,h*w,1);
    
    features = feature_extraction([datapath '/' sub_folders{files} '/' 'adjusted_data_decembercal']);
    
    if files == 3
        labels_tot = labels_mat;
        features_tot = features;
    else
        labels_tot = [labels_tot; labels_mat];
        features_tot = [features_tot; features];
    end
end

%%
close all
scatter3(features_tot(labels_tot==0,1),features_tot(labels_tot==0,2),features_tot(labels_tot==0,3), 50, 'o', 'LineWidth', 1);
hold on;
scatter3(features_tot(labels_tot==1,1),features_tot(labels_tot==1,2),features_tot(labels_tot==1,3), 100, 'd', 'LineWidth', 1);
legend({'None','Insect'}); 
xlabel('Row Mean - Image Mean');
ylabel('Standard Diviation');
zlabel('Max Difference of Azeromean');