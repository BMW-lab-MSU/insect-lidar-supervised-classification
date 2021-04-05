function features = extractHarmonicFeatures(psd, nHarmonics)
% TODO: make nBins an input parameter

nBins = 2;
nRows = height(psd);

harmonicCombinations = nchoosek(1:nHarmonics, 2);
nHarmonicCombinations = height(harmonicCombinations);

peakHeight = cell(nRows, 1);
peakLoc = cell(nRows, 1);
peakWidth = cell(nRows, 1);
peakProminence = cell(nRows, 1);

harmonicHeight = zeros(nRows, nHarmonics);
harmonicLoc = zeros(nRows, nHarmonics);
harmonicWidth = zeros(nRows, nHarmonics);
harmonicProminence = zeros(nRows, nHarmonics);
harmonicHeightRatio = zeros(nRows, nHarmonicCombinations);
harmonicWidthRatio = zeros(nRows, nHarmonicCombinations);
harmonicProminenceRatio = zeros(nRows, nHarmonicCombinations);

fundamental = estimateFundamentalFreq(psd);

for i = 1:nRows
    [peakHeight{i}, peakLoc{i}, peakWidth{i}, peakProminence{i}] = findpeaks(psd(i,:));

    freqBinDiffs = peakLoc{i}/fundamental(i) - fix(peakLoc{i}/fundamental(i));

    tmp = find(1 - freqBinDiffs <= nBins/fundamental(i) | freqBinDiffs <= nBins/fundamental(i));
    
    if numel(tmp) >= nHarmonics
        harmonicLoc(i,:) = peakLoc{i}(tmp(1:nHarmonics));
        harmonicWidth(i,:) = peakWidth{i}(tmp(1:nHarmonics));
        harmonicProminence(i,:) = peakProminence{i}(tmp(1:nHarmonics));
        harmonicHeight(i,:) = peakHeight{i}(tmp(1:nHarmonics));
    else
        harmonicLoc(i,:) = [peakLoc{i}(tmp), nan(1, nHarmonics - numel(tmp))];
        harmonicWidth(i,:) = [peakWidth{i}(tmp), nan(1, nHarmonics - numel(tmp))];
        harmonicProminence(i,:) = [peakProminence{i}(tmp), nan(1, nHarmonics - numel(tmp))];
        harmonicHeight(i,:) = [peakHeight{i}(tmp), nan(1, nHarmonics - numel(tmp))];
    end
    
    for n = 1:nHarmonicCombinations
        harmonic1 = harmonicCombinations(n, 1);
        harmonic2 = harmonicCombinations(n, 2);

        harmonicHeightRatio(i, n) = harmonicHeight(i, harmonic1) / harmonicHeight(1, harmonic2);

        harmonicWidthRatio(i, n) = harmonicWidth(i ,harmonic1) / harmonicWidth(1, harmonic2);

        harmonicProminenceRatio(i, n) = harmonicProminence(i ,harmonic1) / harmonicProminence(1, harmonic2);
    end
end

features = table;

for n = 1:nHarmonics
    features.(['HarmonicHeight' num2str(n)]) = harmonicHeight(:, n);
    features.(['HarmonicLoc' num2str(n)]) = harmonicLoc(:, n);
    features.(['HarmonicWidth' num2str(n)]) = harmonicWidth(:, n);
    features.(['HarmonicProminence' num2str(n)]) = harmonicProminence(:, n);
end

for n = 1:nHarmonicCombinations
    ratioStr = strrep(num2str(harmonicCombinations(n,:)), ' ', '');
    features.(['HarmonicHeightRatio' ratioStr]) = harmonicHeightRatio(:, n);
    features.(['HarmonicWidthRatio' ratioStr]) = harmonicWidthRatio(:, n);
    features.(['HarmonicProminenceRatio' ratioStr]) = harmonicProminenceRatio(:, n);
end
end