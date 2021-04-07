function features = extractPsdStats(psd)

avg_psd = mean(psd, 2);
std_psd = std(psd, 0, 2);
median_psd = median(psd, 2);
mad_psd = mad(psd, 1, 2);
skew_psd = skewness(psd, 1, 2);
skew_psd = skew_psd - mean(skew_psd);
kurtosis_psd = kurtosis(psd, 1, 2);
kurtosis_psd = kurtosis_psd - mean(kurtosis_psd);


% compute the index at which 90% of energy is contained
energypct = cumsum(psd,2)./sum(psd,2);
energy99pct = zeros(height(psd), 1);
energy99pct_no_dc = zeros(height(psd), 1);

for row = 1:height(psd)
    % ignore dc component because it contains basically all the energy
    % NOTE: actually, ignoring the dc component might not be important;
    %       in this case, removing the dc component only makes a difference
    %       of 1 index at most
    energy99pct(row) = find(energypct(row,1:end) >= 0.99, 1);
    energy99pct_no_dc(row) = find(energypct(row,2:end) >= 0.99, 1);

end

features = table;
features.MeanPsd = avg_psd;
features.StdPsd = std_psd;
features.MedianPsd = median_psd;
features.MadPsd = mad_psd;
features.SkewnessPsd = skew_psd;
features.KurtosisPsd = kurtosis_psd;
% features.Bin99PctEnergy = energy99pct;

end