[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5504409.svg)](https://doi.org/10.5281/zenodo.5504409)

# Insect Lidar Supervised Classification
Code for detecting insects in lidar data.

This repository contains the code used to create the results and figures in our paper [*Detection of Insects in Class-imbalanced Lidar Field Measurements*](https://doi.org/10.1109/MLSP52302.2021.9596143), which was published in and presented at the 2021 IEEE Machine Learning for Signal Processing (MLSP) conference. 

The dataset used in this paper is archived at [Zenodo](https://zenodo.org/record/5504411) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.5504411.svg)](https://doi.org/10.5281/zenodo.5504411)

## How to run the experiments

### Create training and testing data
1. Combine the individual data and label files into a more usable format: `combineScans.m`
2. Split the data into training and test sets: `trainTestSplit.m`

### Train and test the classifiers
1. Tune the under- and oversampling ratios: `tuneSampling{AdaBoost, RUSBoost, Net}.m`
2. The the model hyperparameters: `tuneHyperparams{AdaBoost, RUSBoost, Net}.m`
3. Train the final models: `train{AdaBoost, RUSBoost, Net}.m`
4. Test the classifiers: `testClassifiers.m`

### Results
The testing results are saved in `<data directory>/testing/results.mat`. 

To analyze the cross validation results, collect them by running `collectCrossValResults.m`. The results will be in `<data directory>/training/cvResults.m`. 

`figures/resultsFigures.m` creates the confusion matrix figures; it also creates tables for the cross validation and testing set performance metrics.

The feature ranking plot is created by `figures/featureRankingFig.m`
