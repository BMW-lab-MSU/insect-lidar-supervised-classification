function loss = focalLoss(target, scores, weights, cost)

tmp = focalCrossEntropy(dlarray(scores, 'CB'), dlarray(double(target)));
loss = extractdata(tmp);