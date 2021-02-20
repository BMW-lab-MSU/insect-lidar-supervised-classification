function features = feature_extraction(file_path,number_features)
% This function extracts three features per row of an image and
% concatinates the features of an image vertically. 
%
% file_path should be the path to the "adjusted_data_decembercal" of the
% folder whos features are being extracted
%
% Created by Joseph Aist

load(file_path);

rows = length(adjusted_data_decembercal)*178;

features = zeros(rows,number_features);

for i = 1:rows

    A = adjusted_data_decembercal(i).normalized_data;

    Azeromean = abs(A - repmat(mean(A,2),1,size(A,2))); % Take mean of each row and take absolute value
    row_mean = mean(A,2);
    image_mean = mean(A(:));
    filtered_row_std = std(Azeromean')';
    first_diff = max(abs(diff(Azeromean')))';
    
    im_features = [(row_mean - image_mean), filtered_row_std, first_diff];

    for k = 1:number_features
        features((i-1)*178+1:i*178,k) = im_features(:,k);
    end
            
end 
end
