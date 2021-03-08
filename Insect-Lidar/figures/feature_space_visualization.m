addpath('..')

box_dir = '../../../data/Data_2020_Insect_Lidar';

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
group = categorical(labels_tot, unique(labels_tot), {'Non-insect', 'Insect'});

% plot properties
color = [[178,223,138]; [31,120,180]]/255;
markers = 'od';
sizes = [4 12];
feature_names = ["Difference of means", "Std dev", "Max first difference"];

fig = figure();
[h, ax, bigax] = gplotmatrix(features_tot, [], group, color, markers, sizes, [], 'grpbars', feature_names);

% make plot markers filled
h(2,1,1).MarkerFaceColor = h(2,1,1).Color;
h(2,1,2).MarkerFaceColor = h(2,1,2).Color;
h(3,1,1).MarkerFaceColor = h(3,1,1).Color;
h(3,1,2).MarkerFaceColor = h(3,1,2).Color;
h(1,2,1).MarkerFaceColor = h(1,2,1).Color;
h(1,2,2).MarkerFaceColor = h(1,2,2).Color;
h(1,3,1).MarkerFaceColor = h(1,3,1).Color;
h(1,3,2).MarkerFaceColor = h(1,3,2).Color;
h(2,3,1).MarkerFaceColor = h(2,3,1).Color;
h(2,3,2).MarkerFaceColor = h(2,3,2).Color;
h(3,2,1).MarkerFaceColor = h(3,2,1).Color;
h(3,2,2).MarkerFaceColor = h(3,2,2).Color;

set(ax, 'FontSize', 14)
set(bigax, 'FontSize', 14)

axis(bigax, 'square')

% change legend opacity
lobj = ax(1,3).Legend;
set(lobj.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.8]));
set(lobj.BoxEdge, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[0.8;0.8;0.8;.5]));

% align axis labels
ax(1,1).YLabel.Position(1) = ax(2,1).YLabel.Position(1);
ax(3,1).YLabel.Position(1) = ax(2,1).YLabel.Position(1);

%%
% exportgraphics(fig, 'feature_space.pdf', 'ContentType', 'vector');
exportgraphics(fig, 'feature_space.png', 'ContentType', 'image', 'Resolution', 300);