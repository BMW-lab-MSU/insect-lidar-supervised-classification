% Load in the classification model

modelDir = "../../models/";
modelName = "adaboost";
load(modelDir + modelName);
load ("../../2020-08-13/events/manual")
% Add path to use extractFeatures and extractLabels

addpath ../insect-lidar-supervised-classification/
% Find all relevant files

dataDir = "../../2020-08-13/";
files = dir(dataDir + "/*/adjusted_data_decembercal.mat"); %finding all relevant files
% Create a struct to easily identify flagged insect images

%struct array for storing filename and labels for images with insects

adaInsectImages = struct('fileName', 'None', 'labels', zeros(178,1,"logical"), 'isInsect', 'None', 'insectRows', []);
i = 1;
x = 1;
adaInsectImageFilesArray = string.empty;
insectExists = "false";
predictedLabels = [];
predictedLabelsCharArray = char.empty;
trueInsectsArray = [];
trueInsectFiles = [];
trueInsects = [];
% Set up the arrays for the ground truth insects

for f = 1:23
    trueInsects = [trueInsects; manual.insects(f).name];

    trueInsectFiles = [trueInsectFiles; manual.insects(f).filenum];
end

nextInsectFileNameChrs = trueInsects(x,:);
nextInsectFileName = convertCharsToStrings(nextInsectFileNameChrs);
nextInsecFileNum = trueInsectFiles(x);
% Loop through all images from all the files and add a row to the struct

for k = 1:length(files)
    %grab the next file
    currFileName = files(k).name;
    currFolder = files(k).folder;
    currFileFullName = fullfile(currFolder, currFileName);

    %grab the data for the current file
    matData = load(currFileFullName);

    %creating an array of the manual label data and concatenate all image
    %labels for each folder
    manualLabels = extractLabels(manual.insects, matData.adjusted_data_decembercal);
    manualImageLabels = cellfun(@(labels) any(labels), manualLabels);

    %keep track of the maybe insect labels
    manualLabels = extractLabels(manual.maybe_insect, matData.adjusted_data_decembercal);
    manualImagesMaybeInsects = cellfun(@(labels) any(labels), manualLabels);

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

        %grab the file name
        imageFilenameTmp = split(replace(string(image.filename), "/", "-"), ".");
        imageFilename = imageFilenameTmp(1); % remove the file extension
        outprefix = join([modelName, imageFilename, insectDetectedStr], "-");

        %grab the file name use in comparison to the ground truth
        compFilename = extractBetween(imageFilename, 1, 15);

        %create the ground truth array
        if compFilename == nextInsectFileName
            if imageIdx == nextInsecFileNum
                trueInsectsArray = [trueInsectsArray; 1];
                if(x < 23)
                    x = x + 1;
                    nextInsectFileNameChrs = trueInsects(x,:);
                    nextInsectFileName = convertCharsToStrings(nextInsectFileNameChrs);
                    nextInsecFileNum = trueInsectFiles(x);
                    
                end
            else
                trueInsectsArray = [trueInsectsArray; 0];
            end
        else
            trueInsectsArray = [trueInsectsArray; 0];
        end

        %add prediction to predicted insects array
        predictedLabels = [predictedLabels; insectDetected]

        %array for storing rows where insects were detected
        insect_rows = [];
        idx = 1;
        if insectDetected
            for rowIdx = 1:size(labels)
                if labels(rowIdx) == 1
                    insect_rows(idx) = rowIdx;
                    idx = idx + 1;
                end
            end 
        end

        %use struct array to store file names, labels for images that
        %contain insects
        if insectDetected
            tempFileName = char(imageFilename);
            predictedLabelsCharArray = [predictedLabelsCharArray; tempFileName(1:15)];
            if i == 1
                adaInsectImages.fileName = imageFilename;
                adaInsectImages.labels = labels;
                adaInsectImages.isInsect = insectDetectedStr;
                adaInsectImages.insectRows = insect_rows;
                i = 2;
            else
                adaInsectImages(i).fileName = imageFilename;
                adaInsectImages(i).labels = labels;
                adaInsectImages(i).isInsect = insectDetectedStr;
                adaInsectImages(i).insectRows = insect_rows
                i = i + 1;
            end
        end
    end
    
end