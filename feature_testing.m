%% Kyle's Dumb Tests

load('InsectLidarDataTutorial/exampledata.mat')

data=exampledata(1).normalized_data(97,:);              % Identify data of interest
nop=1024;                                               % Number of laser pulses per dataset
delta_f=1/(exampledata(1).time(end));                   % Frequency step size
fqdata=(-nop/2:nop/2-1).*delta_f;
freq_signal = fftshift(fft(data,1024,2),2);                         % Frequencies to use in plot
Y = freq_signal.*conj(freq_signal);
plot(fqdata,Y);            % Plot the power spectral density (power/wavelength)
title('Frequency Spectrum of Insect in Range Bin 97');  % Add title
xlim([-10 2*nop]);                                       % Set limits for x axis
ylim([0 nop/4]);                                          % Set limits for y axis
ylabel('Amplitude');                                    % Add y axis label
xlabel('Frequency [Hz]');                               % Add x axis label 
set(gca,'FontSize',18);                                 % Use font size 18

[pks,locs] = findpeaks(Y);
disp(pks(2)*1024/2);
max_loc = find(Y == max(Y))

[pks,locs] = findpeaks(Y);
sorted_pks = sort(pks);
idx = [1 3 7];
for i = 1:3
    har_pks = find(pks == sorted_pks(end-idx(i)));
    loc_har = locs(har_pks(2));
    freq_har(i) = fqdata(loc_har);
    amp_har(i) = Y(loc_har);
end

% first_har_pks = find(pks == sorted_pks(end-3)); % shift over three because there are two copies of first harmonic
% loc_first_har = locs(first_har_pks(2));
% freq_first_har = fqdata(loc_first_har);
% amp_first_har = Y(loc_first_har);
% 
% second_har_pks = find(pks == sorted_pks(end-5)); % shift over three because there are two copies of first harmonic
% loc_second_har = locs(second_har_pks(2));
% freq_second_har = fqdata(loc_second_har);
% amp_second_har = Y(loc_second_har);


%% Trevor's dumb tests
close all
load('InsectLidarDataTutorial/exampledata.mat')

data = exampledata(1).normalized_data;
% data = medfilt1(data, 10, [], 2);

X = fft(data, [], 2);
psd = abs(X).^2;
psd = psd(:,1:end/2);

normalized_psd = psd./psd(:,1);

spectralphase = angle(X);


avg_psd = mean(psd, 2);
std_psd = std(psd, 0, 2);
median_psd = median(psd, 2);
mad_psd = mad(psd, 1, 2);
skew_psd = skewness(psd, 1, 2);
kurtosis_psd = kurtosis(psd, 1, 2);


% compute the index at which 90% of energy is contained
energypct = cumsum(psd,2)./sum(psd,2);
energy90pct = zeros(1, height(psd));
energy90pct_no_dc = zeros(1, height(psd));

for row = 1:height(psd)
    % ignore dc component because it contains basically all the energy 
    % NOTE: actually, ignoring the dc component might not be important;
    %       in this case, removing the dc component only makes a difference
    %       of 1 index at most
    energy90pct(row) = find(energypct(row,1:end) >= 0.90, 1);
    energy90pct_no_dc(row) = find(energypct(row,2:end) >= 0.90, 1);

end


insectpsd = psd(97,:);
treepsd = psd(160,:);



%% Find the fundamental frequency via the Harmonic Product Spectrum
% If I multiply 4 downsampled spectra, I get a fundamental of 17;
% when I use 3 downsampled spectra, I get a fundamental of 33.
insectpsd2 = insectpsd(1:2:end);
insectpsd3 = insectpsd(1:3:end);
insectpsd4 = insectpsd(1:4:end);
hps = insectpsd(1:numel(insectpsd3)) .* insectpsd2(1:numel(insectpsd3)) .* insectpsd3;

[~, fundamental_loc] = findpeaks(hps, 'NPeaks', 1, 'SortStr', 'descend');

%% Find the harmonics
% Once we know what the fundamental frequency is, we can determine the
% harmonic locations as follows; due to noise, the harmonics will generally
% not be exactly at integer multiples of the fundmantal frequency bin,
% so we need to find peaks that are within a few frequency bins of an integer mutliple
[pks_insect, locs_insect, pkwidth_insect, pkprom_insect] = findpeaks(insectpsd);

bin_differences = locs_insect/fundamental_loc - fix(locs_insect/fundamental_loc);
nbins = 2;
tmp = find(1 - bin_differences <= nbins/fundamental_loc | bin_differences <= nbins/fundamental_loc);
harmonic_locs = locs_insect(tmp);
harmonic_widths = pkwidth_insect(tmp);
haromnic_prom = pkprom_insect(tmp);
harominc_pks = pks_insect(tmp);

%%
figure
imagesc(data)
title('original data: insect at row 97')

figure
imagesc(psd, [0, 100])
title('psd')

% figure
% imagesc(spectralphase)
% title('phase')

% figure
% plot(spectralphase(97,:))
% hold on
% plot(spectralphase(160,:))

figure
plot(psd(160,:))
hold on 
plot(psd(97,:), 'LineWidth', 3)
title('psd')


figure
plot(avg_psd)
title('mean psd')

figure
plot(std_psd)
title('std psd')

figure
plot(median_psd)
title('median psd')

figure
plot(mad_psd)
title('median absolute deviation of psd')

figure
plot(skew_psd - mean(skew_psd))
title('skewness of psd')

figure
plot(kurtosis_psd)
title('kurtosis of psd')

figure
plot(sum(psd, 2))
title('total energy')

figure
boxplot(quantile(data([97,160],:), [0.25, 0.5, 0.75], 2)')
xticklabels({'insect', 'hard object'})

figure
plot(energy90pct)
hold on
plot(energy90pct_no_dc)
title('90% energy index')

