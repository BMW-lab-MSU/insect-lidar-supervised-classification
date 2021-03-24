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


%% Trevor's dumb tests
close all
load('InsectLidarDataTutorial/exampledata.mat')

data = exampledata(1).normalized_data;

psd = abs(fftshift(fft(data, [], 2), 2)).^2;

% we are only interested on plotting the positive frequencies,
% so we start at end/2; however, the dc component dominates, so
% we cut that out by starting at end/2 + 5 (arbitrarily)
figure
imagesc(data)
title('original data: insect at row 97')
figure
imagesc(psd(:,end/2+5:end), [0, 100])
title('psd')


figure
plot(psd(160,end/2+5:end))
hold on 
plot(psd(97,end/2+5:end), 'LineWidth', 3)
title('psd')


avg_psd = mean(psd, 2);
std_psd = std(psd, 0, 2);
median_psd = median(psd, 2);
mad_psd = mad(psd, 1, 2);
skew_psd = skewness(psd, 1, 2);
kurtosis_psd = kurtosis(psd, 1, 2);

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
