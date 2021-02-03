%%  Combining Normalized HyaliteCreek from 2020-09-16 data into a single image
clear all; close all; clc;

fp = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-16/";
folders = dir(fp);
file = "/adjusted_data_decembercal.mat";

l = 1024;
h = 178;
for i = 1:23
     names(i) = (fp+'/'+folders(i+6).name+file);
     f = load(names(i));
     image = zeros([h,l*length(f.adjusted_data_decembercal)]);
     m = 1;

     for key = 1:length(f.adjusted_data_decembercal)
         image(:,m:m+l-1) = f.adjusted_data_decembercal(key).normalized_data;
         m = m + l;         
     end
     
     if i < 2
        hyalitecreek = image;
     else
         hyalitecreek = [hyalitecreek,image];
     end
end


figure()
imagesc(hyalitecreek);
title('Hyalite Creek Images: Normalized Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

% not totally sure if we want this yet. Pretty much impossible to see any
% signals with the eye but there should be some

%% Make the manual into a vector

manual = load(fp+'/'+folders(31).name+'/manual.mat');

key = zeros([1,length(hyalitecreek)]); %vector of insect hits
key(1,l*39+1:l*40) = 1;
key(1,l*46+1:l*47) = 1;
key(1,l*60+1:l*61) = 1;
key(1,l*81+1:l*82) = 1;
key(1,l*88+1:l*89) = 1;
key(1,l*95+1:l*96) = 1;
key(1,l*98+1:l*99) = 1;
key(1,l*131+1:l*132) = 1;
key(1,l*133+1:l*134) = 1;
key(1,l*191+1:l*192) = 1;
key(1,l*237+1:l*239) = 1;
key(1,l*273+1:l*274) = 1;
key(1,l*281+1:l*282) = 1;
key(1,l*288+1:l*289) = 1;
key(1,l*305+1:l*306) = 1;
key(1,l*488+1:l*489) = 1;
key(1,l*556+1:l*557) = 1;
key(1,l*574+1:l*575) = 1;
key(1,l*1438+1:l*1439) = 1;
key(1,l*1771+1:l*1772) = 1;
key(1,l*1920+1:l*1921) = 1;
key(1,l*2272+1:l*2273) = 1;


hyalitecreek = [key;hyalitecreek];

imagesc(hyalitecreek);
title('Hyalite Creek Images: Normalized Data, Insect Labels Across Top');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%%
savepath = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-09-16/2020-09-16-HyaliteCreekLight.mat";
save(savepath, 'hyalitecreek', '-v7.3');










