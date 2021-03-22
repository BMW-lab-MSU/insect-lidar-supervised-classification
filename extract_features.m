function features = extract_features(X)
% This function extracts three features per row of an image and
% concatinates the features of an image vertically. 
%
% file_path should be the path to the "adjusted_data_decembercal" of the
% folder whos features are being extracted
%
% Created by Joseph Aist

% Obtain the number of files from adjusted_data_decembercal and multiply
% the number of files by the height of the files for to find the number of
% rows to extract the features from.

rows = height(X);
nfeatures = 3;

features = zeros(rows, nfeatures);

% Extract the three features.

% Subtract the image mean from the row means.
row_mean = mean(X,2);
image_mean = mean(X(:));

% Take the standard deviation of the filtered rows
filtered_row_std = std(X, 0, 2);

% Take max difference from each row
first_diff = max(abs(diff(X, 1, 2)), [], 2);

features = [(row_mean - image_mean), filtered_row_std, first_diff];

end
