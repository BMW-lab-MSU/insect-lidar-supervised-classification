%%
clear

addpath('..');

datadir = '../../data/Data_2020_Insect_Lidar/MLSP-2021';
load([datadir filesep 'training' filesep 'trainingData'], ...
    'trainingFeatures', 'trainingLabels');

features = nestedcell2mat(trainingFeatures);
labels = nestedcell2mat(trainingLabels);

%%
close all;
[idx, scores] = fscmrmr(features, labels);

fig = figure('Units', 'inches', 'Position', [2 2 3.39*2 2.5]);

bar(scores(idx));
xlabel('Rank')
ylabel('Importance score')
xticks(1:numel(idx))
xticklabels(features.Properties.VariableNames(idx))
set(gca, 'FontSize', 9)

exportgraphics(fig, 'featureRanking.pdf', 'ContentType', 'vector')


