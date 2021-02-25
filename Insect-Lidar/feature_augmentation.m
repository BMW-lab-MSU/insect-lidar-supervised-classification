function augmented_features = feature_augmentation(adjusted_data_decembercal_filepath, fftcheck_filepath, folder, features)
% This function is fed in the file paths for the adjusted_data_decembercal
% and the fftcheck for a choosen folder and the features extracted using 
% the feature_extraction function. Then, for every insect row indetified in
% fftcheck, 40 variations of the row will be made. The augmented features
% will be concatinated to the end of the orginal features file.
% Joseph Aist

load(adjusted_data_decembercal_filepath);
load(fftcheck_filepath);

count = 0;
files = zeros(length(fftcheck.insects));
range = zeros(length(fftcheck.insects));
ub = zeros(length(fftcheck.insects));
lb = zeros(length(fftcheck.insects));

for i = 1:length(fftcheck.insects)
    if fftcheck.insects(i).name == folder
        count = count+1;
        files(count) = fftcheck.insects(i).filenum;
        range(count) = fftcheck.insects(i).range;
        ub(count) = fftcheck.insects(i).ub;
        lb(count) = fftcheck.insects(i).lb;
    end
end

% Remove excess zeros
files(files==0) = [];
range(range==0) = [];
ub(ub==0) = [];
lb(lb==0) = [];
augmented_features = zeros(count*40,3); % each row will get 40 variations of it created
add_features = zeros(40,3); % intermediate array to fill

for k = 1:count

    % grab the row of an insect hit
    A = adjusted_data_decembercal(files(k)).normalized_data;
    A_insect = A(range(k),:);
    insect = A_insect(lb(k):ub(k));
    
    for j = 1:10

        r = randi(1024,1);
        % Circularly shift the values of the row by some random value r.
        A_shift = circshift(A_insect,r);
    
        % flip(reverse) the values of the row
        B_flip = fliplr(A_shift);
    
        if j<=5
            % Resample at 3 times the original sampling rate using lowpass
            % interpolation
            C_insect = interp(A_shift,3);
            
            % Resample at half the original sampling rate after lowpass filtering
            D_insect = decimate(A_shift,2);
            
            % remove random values until the length is that of the
            % original image
            C_insect(randperm(length(C_insect), length(C_insect) - 1024)) = [];
            
            % Add the mean value of the row until it is the length of
            % the original image
            mean_D = mean(D_insect);
            D_insect = [D_insect, repelem(mean_D, 1024 - length(D_insect))];
            
        else
            % Now repeat decimation and interpolation with the flipped
            % insect row
            C_insect = interp(B_flip,3);
            D_insect = decimate(B_flip,2);
            
            C_insect(randperm(length(C_insect), length(C_insect) - 1024)) = [];
        
            mean_D = mean(D_insect);
            D_insect = [D_insect, repelem(mean_D, 1024 - length(D_insect))];
                     
        end

        % Make a second, Third, and Fourth image to extract features from
        B = A; %flipped
        C = A; %upsampled
        D = A; %downsampled
    
        % replace the insect row with an altered row
        A(range(k),:) = A_shift;
        B(range(k),:) = B_flip;  
        C(range(k),:) = C_insect;
        D(range(k),:) = D_insect;         
    
        % Add white guassian noise to the two images
        A = awgn(A,30);
        B = awgn(B,30);
        C = awgn(C,30);
        D = awgn(D,30);
    
        % Extract the three features.
        % Filter the noise by taking mean of the row and take absolute value
        Azeromean = abs(A - repmat(mean(A,2),1,size(A,2))); 
        Bzeromean = abs(B - repmat(mean(B,2),1,size(B,2))); 
        Czeromean = abs(C - repmat(mean(C,2),1,size(C,2))); 
        Dzeromean = abs(D - repmat(mean(D,2),1,size(D,2))); 
    
        % Subtract the image mean from the row means.
        row_mean = mean(A,2);
        image_mean = mean(A(:));
        row_mean_B = mean(B,2);
        image_mean_B = mean(B(:));  
        row_mean_C = mean(C,2);
        image_mean_C = mean(C(:));
        row_mean_D = mean(D,2);
        image_mean_D = mean(D(:));  
    
        % Take the standard deviation of the filtered rows
        filtered_row_std = std(Azeromean')';
        filtered_row_std_B = std(Bzeromean')';
        filtered_row_std_C = std(Czeromean')';
        filtered_row_std_D = std(Dzeromean')';
    
        % Take max difference from each row
        first_diff = max(abs(diff(Azeromean')))';
        first_diff_B = max(abs(diff(Bzeromean')))';
        first_diff_C = max(abs(diff(Czeromean')))';
        first_diff_D = max(abs(diff(Dzeromean')))';
    
        im_features = [(row_mean(range(k)) - image_mean), filtered_row_std(range(k)), first_diff(range(k));
            (row_mean_B(range(k)) - image_mean_B), filtered_row_std_B(range(k)), first_diff_B(range(k));
            (row_mean_C(range(k)) - image_mean_C), filtered_row_std_C(range(k)), first_diff_C(range(k));
            (row_mean_D(range(k)) - image_mean_D), filtered_row_std_D(range(k)), first_diff_D(range(k))];
    
        for l = 1:3
            add_features((j-1)*4+1:j*4,l) = im_features(:,l);
        end
    
    end 
    
    for l = 1:3
        augmented_features((k-1)*40+1:k*40,l) = add_features(:,l);
    end
end

augmented_features = [features;augmented_features];
end