%%  Combining Normalized Hyalite Creek WhiteLight V2 data from 2020-09-20 into a single image
clear all; close all; clc;

fp = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-20";
folders = dir(fp);
file = "/adjusted_data_decembercal.mat";

l = 1024;
h = 178;

for i = 1:25
     names(i) = (fp+'/'+folders(i+2).name+file);
     f = load(names(i));
     image = zeros([h,l*length(f.adjusted_data_decembercal)]);
     m = 1;

     for k = 1:length(f.adjusted_data_decembercal)
         image(:,m:m+l-1) = f.adjusted_data_decembercal(k).normalized_data;
         m = m + l;         
     end
     
     if i < 2
        hcwhitelight2 = image;
     else
         hcwhitelight2 = [hcwhitelight2,image];
     end
end

imagesc(hcwhitelight2);
title('Hyalite Creek WhiteLight V2 Images: Normalized Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18


%% Make the manual into a vector

manual = load(fp+'/'+folders(29).name+'/manual.mat');
% Double check folders match....
% enter a zero vector for now

key = zeros([1,length(hcwhitelight2)]);


hcwhitelight2 = [key;hcwhitelight2];

imagesc(hcwhitelight2);
title('Hyalite Creek WhiteLight V2 Images: Normalized Data, Insect Labels Across Top'); 
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%%
savepath = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-20/2020-09-20-HyaliteCreekWhiteLight.mat";
save(savepath, 'hcwhitelight2', '-v7.3');