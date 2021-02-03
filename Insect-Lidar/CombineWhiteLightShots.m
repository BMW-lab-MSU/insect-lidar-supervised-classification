%%  Combining Normalized WhiteLight from 2020-08-14 data into a single image
clear all; close all; clc;

fp = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-08-14/";
folders = dir(fp);
file = "/adjusted_data_decembercal.mat";

for i = 1:59
     names(i) = (fp+folders(i+2).name+file);
     f = load(names(i));
     image = zeros([178,1024*length(f.adjusted_data_decembercal)]);
     m = 1;

     for k = 1:length(f.adjusted_data_decembercal)
         image(:,m:m+1024-1) = f.adjusted_data_decembercal(k).normalized_data;
         m = m + 1024;         
     end
     
     if i < 2
        whitelight = image;
     else
         whitelight = [whitelight,image];
     end
end

imagesc(whitelight);
title('WhiteLight Images: Normalized Data');    % Add title
xlabel('Pulse Number (or Time)');               % Add x axis label
ylabel('Range (or Distance)');                  % Add y axis label
colorbar;                                       % Add the color scale for the data
set(gca,'FontSize',18);                         % Use font size 18

%% Make the manual into a vector
% No labels provided so enter zero vector to be filled at a later time

key = zeros([1,length(whitelight)]);
whitelight = [key;whitelight];

%%
savepath = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-08-14/2020-08-14-WhiteLight.mat";
save(savepath, 'whitelight', '-v7.3');