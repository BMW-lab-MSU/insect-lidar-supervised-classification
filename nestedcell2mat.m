function mat = nestedcell2mat(cells)
tmp = vertcat(cells{:});
mat = vertcat(tmp{:});
end