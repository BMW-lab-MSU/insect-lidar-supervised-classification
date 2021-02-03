function label_manual(fp)
% This function will create a label for each of the files within a date
% and time section. It uses manual because most folder have the manual
% labels
% fp is the folderpath of the date that is to be labeled
% example fp = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-17";
% Joseph Aist

file = "/adjusted_data_decembercal.mat";

pre_labels = "/events/manual.mat";

load(fp + pre_labels); % Load the manual labels

folders = dir(fp);
folders = rmfield(folders, 'folder'); %Removes unnecessary info from the structure
folders = rmfield(folders,'date');
folders = rmfield(folders,'bytes');
folders = rmfield(folders,'isdir');
folders = rmfield(folders,'datenum');
folders = struct2cell(folders)';

l = 1024; % length of each file
h = 179; % hieght of each file plus one for the manual label vector

for p = 1:length(folders)-3
     
    if (strcmp('Manual Labels', folders(p+2)) == 0)
     m = 1;
     load(fp + '/' + folders(p+2) + file); % load adjusted_data_decembercal
     label_data = zeros([h,l*length(adjusted_data_decembercal)]);
     disp("---- Loading and labeling files in " + folders(p+2) + " ----");     
    
     save_as = string(fp + '/Manual Labels' +'/' + folders(p+2) + "-manual_labels" + ".mat");
     
        for k = 1:length(adjusted_data_decembercal)
            label_data(1:178,m:m+l-1) = adjusted_data_decembercal(k).normalized_data; % fill in image
            m = m + l;         
        end     
    
        for i = 1:length(manual.insects)
          
            j = manual.insects(i).filenum; % Get file number within folder
     
            if (strcmp(folders(p+2), manual.insects(i).name) == 1) 
                if j == 1
                    label_data(179,1:l) = 1; % fill first file label
                else
                    label_data(179,l*(j-1):l*j) = 1; % fill in label 
                end
            else
            end
        end
        save(save_as, 'label_data', '-v7.3'); % save labeled image as a .mat file
    else
    end
end

end

     