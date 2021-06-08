function confmat = imageConfusion(pred, target, crossvalPartition)

% split predicted labels for each test set into 178x1 vectors for each image
tmp = cellfun(@(c) mat2cell(c, 178*ones(1,numel(c)/178), 1), pred, 'UniformOutput', false);

% group the image labels into scans; ensure that the images end up in the appropriate scan position using the cv split indices; we need this primarily so the predicted labels are in the same order as the ground truth labels
for i = 1:crossvalPartition.NumTestSets
    predScanLabels(test(crossvalPartition, i)) = mat2cell(tmp{i}, cellfun('length', target(test(crossvalPartition, i))), 1);
end
predScanLabels = predScanLabels';

% get vectors of image labels
trueImageLabels = cellfun(@(c) any(c), vertcat(target{:}));
predImageLabels = cellfun(@(c) any(c), vertcat(predScanLabels{:}));

confmat = confusionmat(trueImageLabels, predImageLabels);
