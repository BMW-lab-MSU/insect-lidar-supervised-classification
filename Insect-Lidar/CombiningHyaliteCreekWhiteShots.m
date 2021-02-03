%%  Combining Normalized HyaliteCreek White Light data from 2020-09-17 into a single image
clear all; close all; clc;

fp = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-17";
folders = dir(fp);
file = "/adjusted_data_decembercal.mat";

l = 1024;
h = 178;

for i = 1:24
     names(i) = (fp+'/'+folders(i+2).name+file);
     f = load(names(i));
     image = zeros([h,l*length(f.adjusted_data_decembercal)]);
     m = 1;

     for key = 1:length(f.adjusted_data_decembercal)
         image(:,m:m+l-1) = f.adjusted_data_decembercal(key).normalized_data;
         m = m + l;         
     end
     
     if i < 2
        HCwhite = image;
     else
         HCwhite = [HCwhite,image];
     end
end


imagesc(HCwhite);
title('HyaliteCreek White Light Images: Normalized Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%% Make the manual into a vector

manual = load(fp+'/'+folders(47).name+'/manual.mat');

key = zeros([1,length(HCwhite)]); %vector of insect hits
key(1,l*40+1:l*41) = 1;
key(1,l*60+1:l*61) = 1;
key(1,l*75+1:l*76) = 1;
key(1,l*79+1:l*80) = 1;
key(1,l*91+1:l*92) = 1;
key(1,l*152+1:l*153) = 1;
key(1,l*166+1:l*167) = 1;
key(1,l*176+1:l*178) = 1;
key(1,l*179+1:l*183) = 1;
key(1,l*188+1:l*189) = 1;
key(1,l*229+1:l*231) = 1;
key(1,l*246+1:l*247) = 1;
key(1,l*249+1:l*250) = 1;
key(1,l*257+1:l*259) = 1;
key(1,l*275+1:l*276) = 1;
key(1,l*291+1:l*292) = 1;
key(1,l*297+1:l*298) = 1;
key(1,l*347+1:l*348) = 1;
key(1,l*508+1:l*509) = 1;
key(1,l*561+1:l*562) = 1;
key(1,l*563+1:l*564) = 1;
key(1,l*578+1:l*579) = 1;
key(1,l*581+1:l*582) = 1;
key(1,l*583+1:l*584) = 1;
key(1,l*589+1:l*590) = 1;
key(1,l*597+1:l*598) = 1;
key(1,l*651+1:l*652) = 1;
key(1,l*701+1:l*703) = 1;
key(1,l*791+1:l*792) = 1;
key(1,l*799+1:l*800) = 1;
key(1,l*875+1:l*876) = 1;
key(1,l*1009+1:l*1010) = 1;
key(1,l*1073+1:l*1074) = 1;
key(1,l*1109+1:l*1110) = 1;
key(1,l*1258+1:l*1259) = 1;
key(1,l*1382+1:l*1383) = 1;
key(1,l*1419+1:l*1420) = 1;
key(1,l*1421+1:l*1422) = 1;
key(1,l*1432+1:l*1433) = 1;
key(1,l*1440+1:l*1441) = 1;
key(1,l*1457+1:l*1458) = 1;
key(1,l*1498+1:l*1499) = 1;
key(1,l*1544+1:l*1545) = 1;
key(1,l*1562+1:l*1563) = 1;
key(1,l*1611+1:l*1612) = 1;
key(1,l*1784+1:l*1785) = 1;
key(1,l*1791+1:l*1792) = 1;
key(1,l*2051+1:l*2052) = 1;
key(1,l*2103+1:l*2104) = 1;
key(1,l*2137+1:l*2138) = 1;
key(1,l*2206+1:l*2207) = 1;
key(1,l*2295+1:l*2296) = 1;
key(1,l*2489+1:l*2490) = 1;
key(1,l*2491+1:l*2492) = 1;


HCwhite = [key;HCwhite];

imagesc(HCwhite);
title('HyaliteCreek White Light Images: Normalized Data, Insect Labels Across Top');
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%%
savepath = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-17/2020-09-17-HyaliteCreekWhiteLight.mat";
save(savepath, 'HCwhite', '-v7.3');
