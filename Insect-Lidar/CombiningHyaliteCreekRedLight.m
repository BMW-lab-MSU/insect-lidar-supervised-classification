%%  Combining Normalized Hyalite Creek Redlight data from 2020-09-18 into a single image
% This code just combines all of the LIDAR shot files from a single day
% into one matrix and adds a vector across the top which contains a 1 for
% potential Insect locations.
clear all; close all; clc;

fp = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-18";
folders = dir(fp);
file = "/adjusted_data_decembercal.mat";

l = 1024;
h = 178;
for i = 1:26
     names(i) = (fp+'/'+folders(i+2).name+file);
     f = load(names(i));
     image = zeros([h,l*length(f.adjusted_data_decembercal)]);
     m = 1;

     for k = 1:length(f.adjusted_data_decembercal)
         image(:,m:m+l-1) = f.adjusted_data_decembercal(k).normalized_data;
         m = m + l;         
     end
     
     if i < 2
        hcredlight = image;
     else
         hcredlight = [hcredlight,image];
     end
end

imagesc(hcredlight);
title('Hyalite Creek RedLight Images: Normalized Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18


%% Make the manual into a vector

manual = load(fp+'/'+folders(29).name+'/manual.mat');
% Double check folders match....

key = zeros([1,length(hcredlight)]);
key(1,l*33+1:l*34) = 1;
key(1,l*43+1:l*44) = 1;
key(1,l*48+1:l*49) = 1;
key(1,l*60+1:l*61) = 1;
key(1,l*64+1:l*67) = 1;
key(1,l*70+1:l*71) = 1;
key(1,l*79+1:l*80) = 1;
key(1,l*85+1:l*86) = 1;
key(1,l*88+1:l*89) = 1;
key(1,l*100+1:l*101) = 1;
key(1,l*127+1:l*128) = 1;
key(1,l*135+1:l*136) = 1;
key(1,l*138+1:l*139) = 1;
key(1,l*140+1:l*141) = 1;
key(1,l*165+1:l*166) = 1;
key(1,l*212+1:l*213) = 1;
key(1,l*213+1:l*214) = 1;
key(1,l*219+1:l*220) = 1;
key(1,l*235+1:l*236) = 1;
key(1,l*294+1:l*296) = 1;
key(1,l*303+1:l*304) = 1;
key(1,l*317+1:l*318) = 1;
key(1,l*338+1:l*339) = 1;
key(1,l*357+1:l*358) = 1;
key(1,l*391+1:l*392) = 1;
key(1,l*400+1:l*401) = 1;
key(1,l*493+1:l*494) = 1;
key(1,l*508+1:l*509) = 1;
key(1,l*561+1:l*562) = 1;
key(1,l*585+1:l*586) = 1;
key(1,l*603+1:l*604) = 1;
key(1,l*745+1:l*746) = 1;
key(1,l*770+1:l*771) = 1;
key(1,l*782+1:l*783) = 1;
key(1,l*818+1:l*819) = 1;
key(1,l*832+1:l*833) = 1;
key(1,l*960+1:l*961) = 1;
key(1,l*965+1:l*966) = 1;
key(1,l*1018+1:l*1019) = 1;
key(1,l*1092+1:l*1093) = 1;
key(1,l*1110+1:l*1111) = 1;
key(1,l*1136+1:l*1137) = 1;
key(1,l*1213+1:l*1214) = 1;
key(1,l*1257+1:l*1258) = 1;
key(1,l*1321+1:l*1322) = 1;
key(1,l*1354+1:l*1355) = 1;
key(1,l*1358+1:l*1359) = 1;
key(1,l*1366+1:l*1367) = 1;
key(1,l*1432+1:l*1433) = 1;
key(1,l*1550+1:l*1551) = 1;
key(1,l*1552+1:l*1553) = 1;
key(1,l*1592+1:l*1593) = 1;
key(1,l*1671+1:l*1672) = 1;
key(1,l*1749+1:l*1750) = 1;
key(1,l*1900+1:l*1901) = 1;
key(1,l*1989+1:l*1990) = 1;
key(1,l*2024+1:l*2025) = 1;
key(1,l*2131+1:l*2132) = 1;
key(1,l*2154+1:l*2155) = 1;
key(1,l*2250+1:l*2251) = 1;
key(1,l*2302+1:l*2303) = 1;
key(1,l*2417+1:l*2418) = 1;
key(1,l*2484+1:l*2485) = 1;
key(1,l*2534+1:l*2535) = 1;

hcredlight = [key;hcredlight];

imagesc(hcredlight);
title('Hyalite Creek RedLight Images: Normalized Data, Insect Labels Across Top'); 
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%%
savepath = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-18/2020-09-18-HyaliteCreekRedLight.mat";
save(savepath, 'hcredlight', '-v7.3');