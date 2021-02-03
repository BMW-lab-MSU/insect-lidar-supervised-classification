%%
close all;
A = adjusted_data_decembercal(36).normalized_data;
%% Just Print Raw Data
figure(1); imagesc(A); colorbar; title('Raw Data');
%% First Difference 
Afin = diff(A')';
figure(2); imagesc(Afin); colorbar; title('First Difference of Each Row');
%% Subtract Mean Column from each column
Afin = A - repmat(mean(A,2),1,size(A,2));
figure(3); imagesc(Afin); colorbar; title('Subtract mean column from each column');
%% First Difference - Absolute Value
Afin = diff(A')';
figure(4); imagesc(abs(Afin)); colorbar; title('First Difference of Each Row - with the absolute value');
%% Subtract Mean Column from each column - Absolute Value
Afin = A - repmat(mean(A,2),1,size(A,2));
figure(5); imagesc(abs(Afin)); colorbar; title('Subtract mean column from each column - with the absolute value');
%% Subtract Mean from Each Column then take first difference
Azeromean = A - repmat(mean(A,2),1,size(A,2));
Afin = diff(Azeromean')';
figure(6); imagesc(Afin); colorbar; title('Subtract mean then take difference');
%% Subtract Mean from Each Column then take first difference - Absolute Value
Azeromean = A - repmat(mean(A,2),1,size(A,2));
Afin = diff(Azeromean')';
figure(7); imagesc(abs(Afin)); colorbar; title('Subtract mean then take difference with abs');
%% Take first difference then subtract mean of each column
Adiff = diff(A')';
Afin = Adiff - repmat(mean(A,2),1,size(A(:,1:end-1),2));
figure(8); imagesc(Afin); colorbar; title('First difference then subtract the mean');
%% Take first difference then subtract mean of each column - Absolute Value
Adiff = diff(A')';
Afin = Adiff - repmat(mean(A,2),1,size(A(:,1:end-1),2));
figure(9); imagesc(abs(Afin)); colorbar; title('First difference then subtract the mean - Absolute Value');
%% 
means = zeros([178 1]);
for i = 1:178
    means(i) = mean(Afin(i,:));
end
disp(means(9));
figure();
histogram(means);
%% 
% Load adjusted_data_decembercal from 2020-09-20/HyaliteCreekWhite-192904
% Run GitHub/afrl-project/Insect-Lidar/quick_diff_test.m
% Then rerun the subsection of code that makes Figure 5 (subtract mean column from each column, then take absolute value)
row_mean = mean(A,2);
image_mean = mean(A(:));
filtered_row_std = std(Azeromean')';
features = [(row_mean - image_mean), filtered_row_std];

% This gives two features per row. We may need additional features to get a decent classifier, but this should give us a good start.

% After you do all that, you can visualize a classifier like this:

labels = zeros(178,1);
labels(8:9) = 1; % Rows 8 and 9 have insects
figure(1);
scatter(features(labels==0,1),features(labels==0,2),'bo');
hold on;
scatter(features(labels==1,1),features(labels==1,2),'rx');
legend({'None','Insect'}); hold off;
