datadir = '../data/insect-lidar/MLSP-2021/testing';

load([datadir filesep 'testingData.mat'], 'testingRawData');

images = nestedcell2mat(testingRawData);

  save([datadir filesep 'streamingSimData.mat'], 'images', '-v7.3');
