function features = extractFeatures(X)

timeFeatures = extractTimeDomainFeatures(X);
freqFeatures = extractFreqDomainFeatures(X);

features = [timeFeatures, freqFeatures];
end
