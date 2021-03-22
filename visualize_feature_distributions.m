function visualize_feature_distributions(features, labels)

group = categorical(labels, [0, 1], {'Non-insect', 'Insect'});

% plot properties
% color = [[178,223,138]; [31,120,180]]/255;
color = [];
markers = 'od';
sizes = [];
feature_names = ["Difference of means", "Std dev", "Max first difference"];

figure
[h, ax, bigax] = gplotmatrix(features, [], group, color, markers, sizes, [], 'grpbars', feature_names);

end