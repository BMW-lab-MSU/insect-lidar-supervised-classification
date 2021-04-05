function features = extractTimeDomainFeatures(X)

rowMean = mean(X, 2);
imageMean = mean(X(:));

rowStd = std(X, 0, 2);

maxDiff = max(abs(diff(X, 1, 2)), [], 2);

features = table;
features.RowMeanMinusImageMean = rowMean - imageMean;
features.StdDev = rowStd;
features.MaxDiff = maxDiff;
end