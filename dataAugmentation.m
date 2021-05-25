function [newFeatures] = dataAugmentation(data, labels, nAugmented)

arguments
    data (:,:) {mustBeNumeric}
    labels (:, 1) logical
    nAugmented (1,1) {mustBeNumeric, mustBeNonnegative}
end

insectIdx = find(labels == 1);

synthData = createSyntheticData(data(insectIdx, :), nVariations);

newFeatures = extracFeatures(synthData);
end


function synthData = createSyntheticData(data, nAugmented)
N_VARIATIONS = 6;
nInsects = height(data);

synthData = zeros(nInsects * nAugmented, width(data), 'like', data);

for i = 1:nInsects

    insect = data(i,:);

    for j = 1:nAugemented 
        variations = zeros(N_VARIATIONS, width(data), 'like', data);

        variations(1) = circshift(insect, randi(width(data), 1);
        variations(2) = fliplr(insect);
        variations(3) = interpolate(variations(1));
        variations(4) = decimate_(variations(1));
        variations(5) = interpolate(variations(2));
        variations(6) = decimate_(variations(2));

        % add noise to the variations
        variations = variations + randn(N_VARIATIONS, width(data)) * max(variations, 'all')/2;

        % the original lidar data is normalized between 0 and 1, so we do the
        % same to the new data;
        variations = normalize(variations, 2, 'range');

        % put the variations into the correct location in synthData
        start = i * (j - 1) * N_VARIATIONS + 1;
        stop = start + N_VARIATIONS - 1;
        synthData(start:stop, :) = variations;
    end
end
end


function y = interpolate(x)
    % interpolate by a factor of 3
    y = interp(x, 3);

    % remove random values until y is the same size as x
    y(randperm(width(y), width(y) - width(x))) = [];
end

function y = decimate_(x)
    % decimate by 2
    y = decimate(x, 2);

    % pad y with it's mean until it is the same size as x
    y = [y, repelem(mean(y), width(x) - width(y))];
end