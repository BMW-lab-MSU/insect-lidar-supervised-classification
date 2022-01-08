% SPDX-License-Identifier: BSD-3-Clause
%%
datadir = '../../data/insect-lidar/MLSP-2021';
cvResults = load([datadir filesep 'training' filesep 'cvResults']);
testResults = load([datadir filesep 'testing' filesep 'results']);

%% Results tables

% cross validatoin results
cvRowResults = struct2table([cvResults.Net.Row, cvResults.Adaboost.Row, cvResults.RUSBoost.Row], ...
    'AsArray', true, 'RowNames', ["Neural Network (row)", "AdaBoost (row)", "RUSBoost (row)"]);
cvImageResults = struct2table([cvResults.Net.Image, cvResults.Adaboost.Image, cvResults.RUSBoost.Image], ...
    'AsArray', true, 'RowNames', ["Neural Network (image)", "AdaBoost (image)", "RUSBoost (image)"]);

cvRowResults = removevars(cvRowResults, {'Confusion', 'CVResults', 'Accuracy'});
cvImageResults = removevars(cvImageResults, {'Confusion', 'Accuracy'});

cvResultsTable = [cvRowResults; cvImageResults];

cvResultsTable.Variables = round(cvResultsTable.Variables, 3);

writetable(cvResultsTable, 'cvResults.csv', 'WriteRowNames', true);

% testing results
testRowResults = struct2table([testResults.nnet.Row, testResults.adaBoost.Row, testResults.rusBoost.Row], ...
    'AsArray', true, 'RowNames', ["Neural Network (row)", "AdaBoost (row)", "RUSBoost (row)"]);
testImageResults = struct2table([testResults.nnet.Image, testResults.adaBoost.Image, testResults.rusBoost.Image], ...
    'AsArray', true, 'RowNames', ["Neural Network (image)", "AdaBoost (image)", "RUSBoost (image)"]);

testRowResults = removevars(testRowResults, {'Confusion', 'PredLabels', 'Accuracy'});
testImageResults = removevars(testImageResults, {'Confusion', 'Accuracy'});

testResultsTable = [testRowResults; testImageResults];

testResultsTable.Variables = round(testResultsTable.Variables, 3);

writetable(testResultsTable, 'testResults.csv', 'WriteRowNames', true);

%% Confusion matrices
classNames = ["Non-insect", "Insect"];

cvConfusionFig = figure('Units', 'Inches', 'Position', [2 2 3.39 1.75]);

cvConfusion = tiledlayout(cvConfusionFig, 2, 1);

nexttile
cvRowConf = confusionchart(cvResults.Adaboost.Row.Confusion, classNames);
sortClasses(cvRowConf, classNames);
cvRowConf.FontSize = 10;
cvRowConf.XLabel = '';
cvRowConf.YLabel = '';
cvRowConf.Title = 'Observation';
set(gca, 'FontName', 'CMU Serif')


nexttile
cvImageConf = confusionchart(cvResults.Adaboost.Image.Confusion, classNames);
sortClasses(cvImageConf, classNames);
cvImageConf.FontSize = 10;
cvImageConf.XLabel = '';
cvImageConf.YLabel = '';
cvImageConf.Title = 'Image';

cvConfusion.XLabel.String = 'Predicted class';
cvConfusion.YLabel.String = 'True class';
cvConfusion.XLabel.FontSize = 10;
cvConfusion.YLabel.FontSize = 10;
set(gca, 'FontName', 'CMU Serif')

cvConfusion.Padding = 'tight';
cvConfusion.TileSpacing = 'tight';
cvConfusion.XLabel.FontName = 'CMU Serif';
cvConfusion.YLabel.FontName = 'CMU Serif';


exportgraphics(cvConfusionFig, 'cvConfusion.pdf', 'ContentType', 'vector')


testConfusionFig = figure('Units', 'Inches', 'Position', [2 2 3.39 1.75]);

testConfusion = tiledlayout(testConfusionFig, 2, 1);

nexttile
testRowConf = confusionchart(testResults.adaBoost.Row.Confusion, classNames);
sortClasses(testRowConf, classNames);
testRowConf.FontSize = 10;
testRowConf.XLabel = '';
testRowConf.YLabel = '';
testRowConf.Title = 'Observation';
set(gca, 'FontName', 'CMU Serif');

nexttile
testImageConf = confusionchart(testResults.adaBoost.Image.Confusion, classNames);
sortClasses(testImageConf, classNames);
testImageConf.FontSize = 10;
testImageConf.XLabel = '';
testImageConf.YLabel = '';
testImageConf.Title = 'Image';

testConfusion.XLabel.String = 'Predicted class';
testConfusion.YLabel.String = 'True class';
testConfusion.XLabel.FontSize = 10;
testConfusion.YLabel.FontSize = 10;
testConfusion.XLabel.FontName = 'CMU Serif';
testConfusion.YLabel.FontName = 'CMU Serif';

testConfusion.Padding = 'tight';
testConfusion.TileSpacing = 'tight';

set(gca, 'FontName', 'CMU Serif');

exportgraphics(testConfusionFig, 'testConfusion.pdf', 'ContentType', 'vector')

