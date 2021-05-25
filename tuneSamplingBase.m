function result = tune_sampling_roi_base(fitcfun, data, labels, scanLabel, crossvalPartition, opts)
arguments
    fitcfun (1,1) function_handle
    data (:,1) cell
    labels (:,1) cell
    scanLabel (:,1) logical
    crossvalPartition (1,1) cvpartition
    opts.Progress (1,1) logical = false
    opts.UseParallel (1,1) logical = false
    opts.NumThreads (1,1) int8 = 1
end

name = functions(fitcfun).function;

% Create the grid
undersampling = 0:0.05:0.95;

GRID_SIZE = numel(undersampling);

% Preallocate data structures for grid search results
objective = zeros(1, GRID_SIZE);
userdata = cell(1, GRID_SIZE);

if opts.Progress
    if opts.UseParallel
        progressbar = ProgressBar(GRID_SIZE, ...
            'IsParallel', true, 'WorkerDirectory', pwd(), ...
            'Title', 'Grid search');
    else
        progressbar = ProgressBar(GRID_SIZE, 'Title', 'Grid search');
    end
end

% Training
disp([name, ': undersampling grid search'])

if opts.Progress
    progressbar.setup([],[],[]);
end

if opts.UseParallel
    parfor i = 1:GRID_SIZE
        maxNumCompThreads(opts.NumThreads);

        [objective(i), ~, userdata{i}] = cvobjfun(fitcfun, [], ...
            undersampling(i), crossvalPartition, data, labels, scanLabel);
        
        if opts.Progress
            updateParallel([], pwd);
        end
    end
else
    for i = 1:GRID_SIZE
        [objective(i), ~, userdata{i}] = cvobjfun(fitcfun, [], ...
            undersampling(i), crossvalPartition, data, labels, ...
            scanLabel, 'Progress', opts.Progress);

        if opts.Progress
            progressbar([], [], []);
        end
    end
end

if opts.Progress
    progressbar.release();
end

% Find the undersampling ratio that resulted in the maximum f2 score
result.objective = objective;
result.userdata = userdata;
[minf2, minf2idx] = min(result.objective);
result.undersamplingRatio = undersampling(minf2idx);