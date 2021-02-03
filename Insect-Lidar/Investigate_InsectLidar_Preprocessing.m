%% Investigating preprocessing the insect LIDAR images
% Joseph Aist
clear all; close all; clc; 

fp = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-16/HyaliteCreek-193218/adjusted_data_decembercal.mat";
load(fp);

Shot = adjusted_data_decembercal(47).normalized_data;

Adiff = diff(Shot')';

figure(1); 
imagesc(Shot); colorbar;
title('Original Shot');

figure(2); 
imagesc(Adiff); colorbar; 
title('First Difference of Each Row');

Azeromean = Shot - repmat(mean(Shot,2),1,size(Shot,2));
figure(3); 
imagesc(Azeromean); colorbar; 
title('Subtract mean column from each column');

%-------------------------------------------------------------------------%
mean_diff = diff(Azeromean')'; 
figure(4);
imagesc(mean_diff); colorbar;
title('Subtract mean column from each column, then take first difference of each row');

diff_mean = Adiff - repmat(mean(Adiff,2),1,size(Adiff,2));
figure(5);
imagesc(diff_mean); colorbar;
title('First difference of each row, then subtract mean column from each column');

% These results look almost identical

%-------------------------------------------------------------------------%
abs_mean_diff = abs(mean_diff);
figure(6);
imagesc(abs_mean_diff); colorbar;
title('Absolute values of Subtract mean column from each column, then take first difference of each row');

abs_diff_mean = abs(diff_mean);
figure(7);
imagesc(abs_diff_mean); colorbar;
title('Absolute values of First difference of each row, then subtract mean column from each column');

%-------------------------------------------------------------------------%
medfilt = medfilt2(Shot);
figure(8);
imagesc(medfilt); colorbar;
title('Median filtering');
% not promising

mean_med = medfilt2(Azeromean);
figure(9);
imagesc(mean_med); colorbar;
title('Subtract mean column from each column then Median filtering');

diff_med = medfilt2(Adiff);
figure(10);
imagesc(diff_med); colorbar;
title('First Difference of Each Row then median filtering');

% these don't seem that good

%-------------------------------------------------------------------------%

