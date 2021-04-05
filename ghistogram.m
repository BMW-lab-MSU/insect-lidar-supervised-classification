function h = ghistogram(X, G)

groups = categories(G);

% h = figure;
hold on

for n = 1:numel(groups)
    histogram(X(G==groups(n)), ...
        'Normalization', 'probability', 'BinWidth', range(X) / 50);
end
hold off
% legend(groups);
end