%% Insect example figures for IEEE RAPID 2020 paper

%%
RANGE_INCREMENT = 0.75;

%% load data and labels
box_dir = '/mnt/data/trevor/research/AFRL/insect-lidar/Data_2020_Insect_Lidar/2020-09-16/';
data_dir = [box_dir 'HyaliteCreek-210206'];
label_dir = [box_dir 'events'];

load([data_dir filesep 'adjusted_data_decembercal'])
load([label_dir filesep 'fftcheck'])

%%
close all

imagenum = fftcheck.insects(17).filenum;

% NOTE: the human label has the wrong range. To me, it looks like
% the insect starts one row above the label.
insect_range = (fftcheck.insects(17).range - 1) * RANGE_INCREMENT;

insect_lb = fftcheck.insects(17).lb;
insect_ub = fftcheck.insects(17).ub;

range = [1:30];
pulse = [250:550];

time = adjusted_data_decembercal(imagenum).time(pulse) * 1e3;

insect_image = figure('Units', 'inches', 'Position', [2 2 4 3.5]);
imagesc(time, range * RANGE_INCREMENT, adjusted_data_decembercal(imagenum).normalized_data(range, pulse));
ylabel('Range [m]')
xlabel('Time [ms]')
set(gca, 'FontSize', 12)
colormap(brewermap([], 'Greys'))


% insect bounding box
insect_time_start = time(insect_lb - pulse(1));
insect_time_width = time(insect_ub - pulse(1)) - insect_time_start;
insect_range_start = insect_range(1) - 0.5;
insect_range_width = 1;
rectangle('Position', [insect_time_start, insect_range_start, insect_time_width, 1], ...
    'EdgeColor', '#D95319', 'LineWidth', 3, 'LineStyle', ':')

% "hard" object annotation
annotation('arrow',[0.25, 0.4], [0.6, 0.47], 'Color', '#0072BD', 'LineWidth', 3)

exportgraphics(insect_image, 'insect_example.pdf', 'ContentType', 'vector')
