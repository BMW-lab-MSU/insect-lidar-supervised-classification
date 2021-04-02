function fundamental = estimateFundamentalFreq(psd)

fundamental = zeros(height(psd), 1);

hps = harmonicProductSpectrum(psd, 3);

for i = 1:height(psd)
    [~, fundamental(i)] = findpeaks(hps(i,:), 'NPeaks', 1, ...
        'SortStr', 'descend');
end

end