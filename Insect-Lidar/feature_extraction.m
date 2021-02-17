function features = feature_extraction(file_path)
% This function extracts three features per row of an image and
% concatinates the features of an image vertically. 
%
% file_path should be the path to the "adjusted_data_decembercal" of the
% folder whos features are being extracted
%
% Created by Joseph Aist

load(file_path);

features = zeros(length(adjusted_data_decembercal)*178,3);

for i = 1:length(adjusted_data_decembercal)

    A = adjusted_data_decembercal(i).normalized_data;

    Azeromean = abs(A - repmat(mean(A,2),1,size(A,2))); % Take mean of each row and take absolute value
    row_mean = mean(A,2);
    image_mean = mean(A(:));
    filtered_row_std = std(Azeromean')';
    first_diff = max(abs(diff(Azeromean')))';
    
    im_features = [(row_mean - image_mean), filtered_row_std, first_diff];

    features((i-1)*178+1:i*178,1) = im_features(:,1);
    features((i-1)*178+1:i*178,2) = im_features(:,2);
    features((i-1)*178+1:i*178,3) = im_features(:,3);

end 
end
