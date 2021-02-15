%% Observe Features of a Large Data-set w/ a third dimension to prepare for classification learner
% There will be a reduction of zeros and an augmentation of ones
clear all; close all; clc;

%%
tic;
load("/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-17/HyaliteCreekWhite-193146/adjusted_data_decembercal.mat");
load("/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-17/events/fftcheck.mat");
folder = 'HyaliteCreekWhite-193146';

feature_label = zeros(length(adjusted_data_decembercal)*178,1);
features_tot = zeros(length(adjusted_data_decembercal)*178,3);

figure();
for i = 1:length(adjusted_data_decembercal)
    
    A = adjusted_data_decembercal(i).normalized_data;

    for k = 1:length(fftcheck.insects)
        if strcmp(fftcheck.insects(k).name,folder)  == 1
            if fftcheck.insects(k).filenum == i
                for j = 1:178
                    A(j,:) = A(fftcheck.insects(k).range,:);
                end 
            end
        end
    end
    
    % random shifts
    % up sampling
    % down sampling
    % add random gausian noise
    % reverse it 
    % combinations of these too
    % probably add noise to all
    % 90% non-insects 10% insects
    % Send a sample to liz to verify that it still looks like an insect
    
    Azeromean = abs(A - repmat(mean(A,2),1,size(A,2))); % Take mean of each row and take absolute value
    row_mean = mean(A,2);
    image_mean = mean(A(:));
    filtered_row_std = std(Azeromean')';
    first_diff = max(abs(diff(Azeromean')))';

    features = [(row_mean - image_mean), filtered_row_std, first_diff];

    features_tot((i-1)*178+1:i*178,1) = features(:,1);
    features_tot((i-1)*178+1:i*178,2) = features(:,2);
    features_tot((i-1)*178+1:i*178,3) = features(:,3);
  

    labels = zeros(178,1);
    
    for k = 1:length(fftcheck.insects)
        if strcmp(fftcheck.insects(k).name,folder)  == 1
            if fftcheck.insects(k).filenum == i
                labels(:) = 1;
                feature_label((fftcheck.insects(k).filenum-1)*178:(fftcheck.insects(k).filenum)*178) = 1;
            end
        end
    end
    

    scatter3(features(labels==0,1),features(labels==0,2),features(labels==0,3),'bo');
    hold on;
    scatter3(features(labels==1,1),features(labels==1,2),features(labels==1,3),'rx');
    legend({'None','Insect'}); 
    title('Features of 2020-09-17: HyaliteCreekWhite-193146');
    xlabel('Row Mean - Image Mean');
    ylabel('Standard Diviation');
    zlabel('Max Difference of Azeromean');
end
toc