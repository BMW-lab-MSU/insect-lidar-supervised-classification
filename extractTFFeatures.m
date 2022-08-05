function features = extractTFFeatures(X)
arguments
    X (:,:) {mustBeNumeric}
end
[rows,columns] = size(X);
cwavelet = cell(rows,1);

for i = 1:rows
    if(sum(X(i,:),2) ~= 0)
    cwavelet{i} = abs(cwt(X(i,:)).^2);
    else
        cwavelet{i} = zeros(1,1024);
    end
end
features = extractTFStats(cwavelet);
end