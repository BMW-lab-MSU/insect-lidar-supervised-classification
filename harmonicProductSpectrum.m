function hps = harmonicProductSpectrum(spectrum, nSpectra)

rows = height(spectrum);
cols = floor(width(spectrum) / nSpectra);
spectra = zeros(nSpectra, rows, cols);
hps = zeros(rows, cols);

% Downsample the spectrum
for j = 1:nSpectra
    spectra(j, :, :) = spectrum(:, 1:j:(j * cols));
end

hps = squeeze(prod(spectra));
end