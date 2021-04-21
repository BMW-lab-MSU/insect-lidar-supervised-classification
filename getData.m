function data = getData(basefilepath,day,folder,image)
    load([basefilepath filesep day filesep folder filesep 'adjusted_data_decembercal.mat']);
    for i = 1:length(adjusted_data_decembercal)
%         disp([folder '/' image]); disp(adjusted_data_decembercal(i).filename);
        if strcmp(string([folder '/' image]),string(adjusted_data_decembercal(i).filename)) == true
            data = adjusted_data_decembercal(i).normalized_data;
            break;
        end
    end
end