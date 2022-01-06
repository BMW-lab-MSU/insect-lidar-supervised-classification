% Load in the classification model

modelDir = "../models/";
modelName = "nnet";
load(modelDir + modelName);
% Add path to use extractFeatures

addpath ../insect-lidar-supervised-classification/
% Find all relevant files

dataDir = "../2020-08-13/";
files = dir(dataDir + "/*/adjusted_data_decembercal.mat"); %finding all relevant files
% Create a struct to easily identify flagged insect images

%struct array for storing filename and labels for images with insects

nnetInsectImages = struct('fileName', 'None', 'labels', zeros(178,1,"logical"), 'isInsect', 'None', 'insectRows', []);
i = 1;
a = 1;
nnetInsectImageFilesArray = string.empty;
insectExists = "false";
% Loop through all images from all the files and add a row to the struct

for k = 1:length(files)
    %grab the next file
    currFileName = files(k).name;
    currFolder = files(k).folder;
    currFileFullName = fullfile(currFolder, currFileName);

    %grab the data for the current file
    matData = load(currFileFullName);
    
    % for each image in the scan
    for imageIdx = 1:numel(matData.adjusted_data_decembercal)
        
        image = matData.adjusted_data_decembercal(imageIdx);
        currData = image.normalized_data;
    
        %extract features
        features = extractFeatures(currData);
    
        %predict labels
        labels = predict(model,features);
        
        insectDetected = any(labels);

        %save label output
        if insectDetected
            insectDetectedStr = "insect";
            insectExists = "true";
        else
            insectDetectedStr = "no-insect";
        end

        %array for storing rows where insects were detected
        insect_rows = []
        idx = 1
        if insectDetected
            for rowIdx = 1:size(labels)
                if labels(rowIdx) == 1
                    insect_rows(idx) = rowIdx
                    idx = idx + 1
                end
            end    
        end

        imageFilenameTmp = split(replace(string(image.filename), "/", "-"), ".");
        imageFilename = imageFilenameTmp(1); % remove the file extension
        outprefix = join([modelName, imageFilename, insectDetectedStr], "-");

        %use struct array to store file names, labels for images that
        %contain insects
        if insectDetected
            nnetInsectImageFilesArray(a) = extractBetween(imageFilename, 1,15);
            a = a + 1;
            if i == 1
                nnetInsectImages.fileName = imageFilename;
                nnetInsectImages.labels = labels;
                nnetInsectImages.isInsect = insectDetectedStr;
                nnetInsectImages.insectRows = insect_rows;
                i = 2;
            else
                nnetInsectImages(i).fileName = imageFilename;
                nnetInsectImages(i).labels = labels;
                nnetInsectImages(i).isInsect = insectDetectedStr;
                nnetInsectImages(i).insectRows = insect_rows
                i = i + 1;
            end
        end
    end
    
end    
%%
temp = []
%% 
% Fill the temporary array with all the true unique images that contained insects

for i = 1:23
    temp = [temp; manual.insects(i).name];
end
temp2 = unique(temp, 'rows');
%% 
% Convert the string array that was created above into a cell array.

nnetPredictedCMatrix = convertStringsToChars(nnetInsectImageFilesArray)
%% 
% Convert the cell array to a character vector, so that it is the same type 
% as temp2.

nnetPredictedCharArray = char(nnetPredictedCMatrix)
%% 
% Create a confusion matrix

cMatrix = confusionchart(temp2, nnetPredictedCharArray)