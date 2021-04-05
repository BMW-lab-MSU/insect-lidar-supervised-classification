function visualize_feature_distributions(features, labels, feature_names)

groups = categorical(labels, [0, 1], {'Non-insect', 'Insect'});

% plot properties
% color = [[178,223,138]; [31,120,180]]/255;
% color = [];
% markers = 'od';
% sizes = [];

% figure
% [h, ax, bigax] = gplotmatrix(features, [], group, color, markers, sizes, [], 'grpbars', feature_names);

tlayout = tiledlayout('flow');

nFeatures = width(features);

for n = 1:nFeatures
    nexttile
    ghistogram(features(:, n), groups)
    title(feature_names(n));
end
legend(categories(groups))