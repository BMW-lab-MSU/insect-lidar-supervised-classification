%% Investigate Insect LIDAR files
% Joseph Aist

clc;clear all; close all; 

%% Data from 2020-07-21

fp = "/Users/joeyaist/Box/Data_2020_Insect_Lidar/";
data = "2020-07-21/";
folder = "/GroundMatrice-112157/";

%load(fp + data + folder + '00002_P-421T-670.mat/');

load('00002_P-421T-670.mat');

figure()
imagesc(full_data.data);    % Plot the first example
title('Ground Matrice 2020-07-21 Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%---------------------------------------------------------------------------
load('00003_P0000T-801.mat');

figure()
imagesc(full_data.data);    % Plot the first example
title('Ground Phantom 100334 2020-07-21 Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%---------------------------------------------------------------------------
load('00001_P0000T-901.mat');
figure()
subplot(311);
imagesc(full_data.data);    % Plot the first example
title('Ground Phantom 100508 2020-07-21  Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);  

load('00003_P0048T-851.mat');
subplot(312);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('00004_P-002T-850.mat');
subplot(313);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%---------------------------------------------------------------------------
load('00001_P0000T-851.mat');
figure()
subplot(411);
imagesc(full_data.data);    % Plot the first example
title('Ground Phantom 105220 2020-07-21  Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);  

load('00003_P0046T-801.mat');
subplot(412);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('00005_P0002T-750.mat');
subplot(413);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('00006_P0054T-750.mat');
subplot(414);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%---------------------------------------------------------------------------
load('00001_P0000T-851.mat');
figure()
subplot(411);
imagesc(full_data.data);    % Plot the first example
title('Ground Phantom 105336 2020-07-21  Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);  

load('00003_P0051T-801.mat');
subplot(412);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('00004_P0003T-801.mat');
subplot(413);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('00005_P-048T-800.mat');
subplot(414);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%---------------------------------------------------------------------------
load('00001_P0001T-851.mat');
figure()
subplot(411);
imagesc(full_data.data);    % Plot the first example
title('Ground Phantom 105547 2020-07-21  Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);  

load('00003_P0046T-801.mat');
subplot(412);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('00005_P0003T-751.mat');
subplot(413);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('00006_P0055T-751.mat');
subplot(414);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%---------------------------------------------------------------------------
load('00001_P0001T-850.mat');
figure()
subplot(311);
imagesc(full_data.data);    % Plot the first example
title('Ground Phantom 110754 2020-07-21  Data');        % Add title
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);  

load('00003_P0015T-830.mat');
subplot(312);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('00004_P-007T-830.mat');
subplot(313);
imagesc(full_data.data);    % Plot the first example
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%---------------------------------------------------------------------------
% There doesn't appear to be any insects in this date's data
%---------------------------------------------------------------------------

%% 2020-08-13

load('/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-07-31/GroundPhantom-101207/adjusted_data_decembercal.mat');

figure()
subplot(411);
title('Normalized GroundPhantom-101207');
imagesc(adjusted_data_decembercal(1).normalized_data(1));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
subplot(412);
imagesc(adjusted_data_decembercal(2).normalized_data(2));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
subplot(413);
imagesc(adjusted_data_decembercal(3).normalized_data(3));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
subplot(414);
imagesc(adjusted_data_decembercal(4).normalized_data(4));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('00001_P0000T-981.mat');
figure()
title('GroundPhantom-101207');
imagesc(adjusted_data_decembercal(1).normalized_data(1));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
% Doesn't appear to be anything in this set
%---------------------------------------------------------------------------

load('/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-07-31/GroundPhantom-101446/adjusted_data_decembercal.mat')
figure()
subplot(411);
title('Normalized GroundPhantom-101446');
imagesc(adjusted_data_decembercal(1).normalized_data(1));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
subplot(412);
imagesc(adjusted_data_decembercal(2).normalized_data(2));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
subplot(413);
imagesc(adjusted_data_decembercal(3).normalized_data(3));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
subplot(414);
imagesc(adjusted_data_decembercal(4).normalized_data(4));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
%---------------------------------------------------------------------------

load('/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-07-31/GroundPhantom-101531/adjusted_data_decembercal.mat')
figure()
subplot(311);
title('Normalized GroundPhantom-101531');
imagesc(adjusted_data_decembercal(1).normalized_data(1));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
subplot(312);
imagesc(adjusted_data_decembercal(2).normalized_data(2));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18
subplot(313);
imagesc(adjusted_data_decembercal(3).normalized_data(3));
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

%---------------------------------------------------------------------------
load('/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-07-31/HoverPhantom-105340/00001_P-094T0700.mat')
figure()
title('HoverPhantom-105340 1');
imagesc(full_data.data);
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-07-31/HoverPhantom-105340/00002_P-070T0700.mat')
figure()
title('HoverPhantom-105340 2');
imagesc(full_data.data);
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

load('/Users/joeyaist/Box/Data_2020_Insect_Lidar/2020-07-31/HoverPhantom-105340/00003_P-043T0700.mat')
figure()
title('HoverPhantom-105340 3');
imagesc(full_data.data);
xlabel('Pulse Number (or Time)');           % Add x axis label
ylabel('Range (or Distance)');              % Add y axis label
colorbar;                                   % Add the color scale for the data
set(gca,'FontSize',18);                     % Use font size 18

% The does not appear to be insects, data is much more noisy
%---------------------------------------------------------------------------
%% 