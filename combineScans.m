tic

N_ROWS = 178;
N_COLS = 1024;

basefilepath = "../data/Data_2020_Insect_Lidar";

days = ["2020-09-16", "2020-09-17", "2020-09-18", "2020-09-20"];

scansIds = cell(numel(days), 1);

% Get all the folders that contain a scan
for i = 1:numel(days)
    % Grab the directories under the "day" folder
    tmp = string({dir(basefilepath + filesep + days(i)).name});

    % Find the directories that contain scans (which contain a timestamp),
    % e.g. "RedLight-225413"
    match = regexp(tmp, '\w+-\d{6}');
    scanIdx = cellfun(@(c) ~isempty(c), match);
    scanIds{i} = tmp(scanIdx);
end

nScans = numel([scanIds{:}]);

scans = struct('Day', string(), 'Id', string(), 'Data', cell(nScans, 1), ...
    'Labels', cell(nScans, 1), 'ImageLabels', cell(nScans, 1), ...
    'ScanLabel', false, 'Pan', cell(nScans, 1), ...
    'Tilt', cell(nScans, 1), 'Range', cell(nScans, 1), 'Time', cell(nScans, 1));

if exist('ProgressBar')
    progbar1 = ProgressBar(nScans, 'UpdateRate', 1);
end

scanNum = 1;
for i = 1:numel(days)
    for j = 1:numel(scanIds{i})
        scanId = scanIds{i}(j);

        % Load data
        load(basefilepath + filesep + days(i) + filesep + scanId ...
            + filesep + "adjusted_data_decembercal");
        
        % Load events/labels
        load(basefilepath + filesep + days(i) + filesep + "events" + filesep ...
            + "fftcheck");


        scans(scanNum).Day = days(i);
        scans(scanNum).Id = scanIds{i}(j);

        scans(scanNum).Data = cellfun(@(c) single(c), ...
            {adjusted_data_decembercal.normalized_data}', ...
            'UniformOutput', false);

        % Create label vectors
        labels = extractLabels(fftcheck.insects, adjusted_data_decembercal);
        scans(scanNum).Labels = labels;
        scans(scanNum).ImageLabels = cellfun(@(c) any(c), labels);
        scans(scanNum).ScanLabel = any(scans(scanNum).ImageLabels);

        % Grab metadata
        scans(scanNum).Tilt = [adjusted_data_decembercal.tilt]';
        scans(scanNum).Pan = [adjusted_data_decembercal.pan]';
        scans(scanNum).Time = {adjusted_data_decembercal.time}';
        scans(scanNum).Range = {adjusted_data_decembercal.range}';

        scanNum = scanNum + 1;

        if exist('ProgressBar')
            progbar1([],[],[])
        end
    end
end

save('scansMRMR', 'scans', '-v7.3');
toc