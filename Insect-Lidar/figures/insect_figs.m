%% Insect example figures for IEEE RAPID 2020 paper

%%
RANGE_INCREMENT = 0.75;

%% load data and labels
box_dir = '../../../data/Data_2020_Insect_Lidar/2020-09-16/';
data_dir = [box_dir 'HyaliteCreek-210206'];
label_dir = [box_dir 'events'];

load([data_dir filesep 'adjusted_data_decembercal'])
load([label_dir filesep 'fftcheck'])

%%
close all

imagenum = fftcheck.insects(17).filenum;

% NOTE: the human label has the wrong range. To me, it looks like
% the insect starts one row above the label.
insect_range = (fftcheck.insects(17).range - 1);
insect_lb = fftcheck.insects(17).lb;
insect_ub = fftcheck.insects(17).ub;
range = [1:30];
pulse = [250:550];
time = adjusted_data_decembercal(imagenum).time(pulse) * 1e3; % [ms]


%%
insect_fig = figure();
tlayout = tiledlayout(insect_fig, 5, 1); 

nexttile([3, 1])

% lidar image
imagesc(time, range * RANGE_INCREMENT, adjusted_data_decembercal(imagenum).normalized_data(range, pulse));
ylabel('Range [m]')
set(gca, 'FontSize', 12)
colormap(brewermap([], 'Greys'))
xticks([])

% insect bounding box
insect_time_start = time(insect_lb - pulse(1));
insect_time_width = time(insect_ub - pulse(1)) - insect_time_start;
insect_range_start = insect_range(1) * RANGE_INCREMENT - 1;
insect_range_width = 2;
rectangle('Position', [insect_time_start, insect_range_start, insect_time_width, insect_range_width], ...
    'EdgeColor', '#b2df8a', 'LineWidth', 4, 'LineStyle', '-')

% "hard" target annotation
rectangle('Position', [time(1), 14, time(end) - time(1), 4], ...
    'EdgeColor', '#1f78b4', 'LineWidth', 4, 'LineStyle', '--')

title('(a)', 'FontSize', 12)
set(gca, 'TitleHorizontalAlignment', 'left')

%%
nexttile([2 1])

% "hard" object
plot(time, adjusted_data_decembercal(imagenum).normalized_data(22, pulse), ...
    'LineWidth', 1.25, 'Color', '#1f78b4')
hold on
% insect
plot(time, adjusted_data_decembercal(imagenum).normalized_data(insect_range, pulse), ...
    'LineWidth', 1.25, 'Color', '#b2df8a')
ylabel('Intensity')
set(gca, 'FontSize', 12)

legendobj = legend({'"hard" target', 'insect'})

% change legend opacity
set(legendobj.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1;1;1;.3]));
set(legendobj.BoxEdge, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[0.8;0.8;0.8;.5]));

title('(b)', 'FontSize', 12)
set(gca, 'TitleHorizontalAlignment', 'left')

tlayout.XLabel.String = "Time [ms]";

%%
exportgraphics(insect_fig, 'insect_example.pdf', 'ContentType', 'vector')
