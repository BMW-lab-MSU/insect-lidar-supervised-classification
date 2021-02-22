function features = feature_extraction(file_path)
% This function extracts three features per row of an image and
% concatinates the features of an image vertically. 
%
% file_path should be the path to the "adjusted_data_decembercal" of the
% folder whos features are being extracted
%
% Created by Joseph Aist

% Load the adjusted_data_decembercal data for the set of data whose
% features are being extracted.
load(file_path);

% Obtain the number of files from adjusted_data_decembercal and multiply
% the number of files by the height of the files for to find the number of
% rows to extract the features from.
rows = length(adjusted_data_decembercal)*178;
number_features = 3;

features = zeros(rows,number_features);

for i = 1:rows

    A = adjusted_data_decembercal(i).normalized_data;

    % Extract the three features.
    % Filter the noise by taking mean of the row and take absolute value
    Azeromean = abs(A - repmat(mean(A,2),1,size(A,2))); 
    % Subtract the image mean from the row means.
    row_mean = mean(A,2);
    image_mean = mean(A(:));
    % Take the standard deviation of the filtered rows
    filtered_row_std = std(Azeromean')';
    % Take max difference from each row
    first_diff = max(abs(diff(Azeromean')))';
    
    im_features = [(row_mean - image_mean), filtered_row_std, first_diff];

    for k = 1:number_features
        % Assign the current features to their locations within the feature
        % array.
        features((i-1)*178+1:i*178,k) = im_features(:,k);
    end
            
end 
end
