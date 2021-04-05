function features = extractFreqDomainFeatures(X)

nHarmonics = 3;

psd = abs(fft(X, [], 2).^2);

% Only look at the positive frequencies
psd = psd(:,1:end/2);

% Normalize by the DC component
psd = psd./psd(:,1);

psdStats = extractPsdStats(psd);
harmonicFeatures = extractHarmonicFeatures(psd, nHarmonics);

features = [psdStats, harmonicFeatures];
end