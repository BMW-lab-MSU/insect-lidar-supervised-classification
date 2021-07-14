function h = ghistogram(X, G)

% SPDX-License-Identifier: BSD-3-Clause

groups = categories(G);

% h = figure;
hold on

for n = 1:numel(groups)
    histogram(X(G==groups(n)), ...
        'Normalization', 'probability', 'BinWidth', range(X)/65);
end
hold off
% legend(groups);
end