
Ryan Ficken
8/5/22

This folder contains the row reduction code and wavelet features that I have worked on this summer, these files have been edited to
work with the other code on the repository, it should be able to run as given. When testing this code, it is much faster to do it without
augmentation and undersampling likely will have some issues with the new results as well.

Rowcollector- Removes the non unique rows from an image, smooths the data and then thresholds the max minus the mean. Input is an image
and output is that image with non unique rows zeroed.
extractFeatures- modified to work with Rowcollector, and time frequency features.

extracTFFeatures- Preforms the wavelet transform to the data

extractTFStats- extracts the features from the wavelet data