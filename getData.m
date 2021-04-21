function data = getData(basefilepath,day,folder,image)
    adjusted_data_decembercal = load([basefilepath day '\' folder '\' 'adjusted_data_decembercal.mat']);
    for i = 1:length(adjusted_data_decembercal)
        if [folder '\' image '.mat'] == adjusted_data_decembercal{i}.filename
            data = adjusted_data_decembercal(i).normalized_data
        end
    end
end