%%  Combining Normalized Redlight data from 2020-08-13 into a single image
% This code just combines all of the LIDAR shot files from a single day
% into one matrix and adds a vector across the top which contains a 1 for
% potential Insect locations.

clear all; close all; clc;

fp = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-08-13";
folders = dir(fp);
file = "/adjusted_data_decembercal.mat";
l = 1024;
h = 178;
for i = 1:59
     names(i) = (fp+'/'+folders(i+2).name+file);
     f = load(names(i));
     image = zeros([h,l*length(f.adjusted_data_decembercal)]);
     m = 1;

     for k = 1:length(f.adjusted_data_decembercal)
         image(:,m:m+l-1) = f.adjusted_data_decembercal(k).normalized_data;
         m = m + l;         
     end
     
     if i < 2
        redlight = image;
     else
         redlight = [redlight,image];
     end
end

imagesc(redlight);
title('RedLight Images: Normalized Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

% not totally sure if we want this yet. Pretty much impossible to see any
% signals with the eye but there should be some


%% Make the manual into a vector

manual = load(fp+'/'+folders(62).name+'/manual.mat');
% Double check folders match....

key = zeros([1,length(redlight)]);
key(1,l*13+1:l*15) = 1;
key(1,l*30+1:l*31) = 1;
key(1,l*51+1:l*52) = 1;
key(1,l*55+1:l*56) = 1;
key(1,l*71+1:l*73) = 1;
key(1,l*92+1:l*93) = 1;
key(1,l*97+1:l*98) = 1;
key(1,l*113+1:l*114) = 1;
key(1,l*118+1:l*119) = 1;
key(1,l*139+1:l*140) = 1;
key(1,l*155+1:l*156) = 1;
key(1,l*160+1:l*161) = 1;
key(1,l*172+1:l*173) = 1;
key(1,l*177+1:l*178) = 1;
key(1,l*182+1:l*183) = 1;
key(1,l*199+1:l*200) = 1;
key(1,l*204+1:l*205) = 1;
key(1,l*220+1:l*221) = 1;
key(1,l*247+1:l*248) = 1;
key(1,l*253+1:l*254) = 1;
key(1,l*291+1:l*292) = 1;

redlight = [key;redlight];

imagesc(redlight);
title('RedLight Images: Normalized Data, Insect Labels Across Top');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%%
% savepath = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-08-13/2020-08-13-RedLight.mat";
% save(savepath, 'redlight', '-v7.3');