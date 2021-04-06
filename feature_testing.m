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

box_dir = '../Data_2020_Insect_Lidar';

datapath = [box_dir '/' '2020-09-16'];

% load labels
load([datapath '/' 'events/fftcheck.mat']);

%%
sub_folders = {dir(datapath).name};

for files = 3:length(sub_folders)-2
    disp(['Loading data... ' sub_folders{files}])
    load([datapath '/' sub_folders{files} '/' 'adjusted_data_decembercal.mat']);
    
    labels = extract_labels(fftcheck.insects, adjusted_data_decembercal);
    labels = cellfun(@(x) logical(x), labels, 'UniformOutput', false);
    labels_mat = cell2mat(labels);
    [h,w] = size(labels_mat);
    labels_mat = reshape(labels_mat,h*w,1);
    
    features = table;
    for i = 1:numel(adjusted_data_decembercal)
        tmp = extractFeatures(adjusted_data_decembercal(i).data);
        features = [features; tmp];
    end
    
    if files == 3
        labels_tot = labels_mat;
        features_tot = features;
    else
        labels_tot = [labels_tot; labels_mat];
        features_tot = [features_tot; features];
    end
end


%% Visualize
featureMat = table2array(features_tot);
featureNames = features_tot.Properties.VariableNames;

visualize_feature_distributions(featureMat, labels_tot, featureNames);
