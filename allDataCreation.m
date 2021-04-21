function all_data = allDataCreation(basefilepath,dayStart,dayEnd)
% Arguments:
%   basefilepath = file path to the user's data folder where all the days
%   are stored (string)
%   dayStart = starting index of the days that follow the expected file
%   structure (int)
%   dayEnd = ending index of the days that follow the expected file
%   struture (int)
%   Returns = a structure with the day, the folder, and the image names.
%   (MATLAB struct)

% Initialize the output structure
all_data = struct('dayID',[],'folderID',[],'imageID',[]);
% Load the days 
folders = {dir(basefilepath).name};
days = folders(dayStart:dayEnd);
% Variable to keep track how many times the nested for loops have run
x = 1;
% Iterate through all of the files. Throw out non-insect-image
% files/folders
for i = 1:length(days)
    temp_folders = {dir(string([basefilepath '\' days{i}])).name};
    temp_folders = temp_folders(3:end-2);
    for j = 1:length(temp_folders)
        temp_images = {dir(string([basefilepath '\' days{i} '\' temp_folders{j}])).name};
        temp_images = temp_images(3:end-1);
        for k = 1:length(temp_images)
            % Assign each day, folder, and image to the output structure
            all_data(x).dayID = days{i};
            all_data(x).folderID = temp_folders{j};
            all_data(x).imageID = temp_images{k};
            x = x + 1;
        end
    end
end

end