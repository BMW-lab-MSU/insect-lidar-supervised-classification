function empty_labels = create_label_vector(filepath)
% Inputs: 
% Filepath to the folder a day of data
load(filepath + "\events\fftcheck.mat");
empty_labels = create_empty_labels(filepath);
for i = 1 : length(fftcheck.insects)
    idx = fftcheck.insects(i).foldernum;
    ub = fftcheck.insects(i).ub + 1024*fftcheck.insects(i).filenum;
    lb = fftcheck.insects(i).lb + 1024*fftcheck.insects(i).filenum;
    range = fftcheck.insects(i).range;
    empty_labels(idx).labels(range,lb:ub) = 1;
end














