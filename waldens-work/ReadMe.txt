--------------------------------------------------------------------------------------
Work completed by Walden Marshall under Dr. Bradley Whitaker over summer 2022 for the
ECE REU program at Montana State University.
--------------------------------------------------------------------------------------
In order to train and test models with this code, you will have to first perform a 
train test split using code by Trevor Vannoy 
https://github.com/BMW-lab-MSU/insect-lidar-supervised-classification
In my work I used three-fold cross validation and 80/20 train/test ratio.
--------------------------------------------------------------------------------------
The general structure of the training pipeline is:

cost-aug grid search ---> particle swarm optimization ---> bayesian optimization

The three models trained are neural network (Net), AdaBoost (ADA) and RUSBoost (RUS).
In most places, corresponding files are named the same other than their suffix being
the model abbreviation, so I will refer to files as exampleFile<mdl>.mat
--------------------------------------------------------------------------------------
To run the training pipeline, first perform the grid search using tuneAugCost<mdl>.m
This will produce a file augCostTuning<mdl>.mat in the training directory.

To decide on bounds for the next step, particle swarm optimization, you must examine
the results of the grid search. Run visualizeGridSearch<mdl>.mlx to produce
visualizations. Manually choose regions of interest for high performance and use them
for bounds in the next step.

To perform particle swarm optimization, run particleSwarmWrapper.m. You will have to
enter the lower and upper bounds for augmentation number and cost in lines 3 and 4. 
You will also have to change line 11 to call the right model by using 
@particleSwarmTarget<mdl> as an argument in the particleswarm() function. Likewise on
line 16 change the name of the file saved to PSO<mdl>augcost.mat.

To perform Bayesian hyperparameter optimization, run tuneHyper<mdl>.m. This will
create a file hyperparameterTuning<mdl>.mat in the training directory. 

Finally, we train a model using the optimal set of hyperparameters. Run
train<mdl>OptimalHyper.m, which will save a file finalModel<mdl>.mat which contains
information about the training and the final models.
--------------------------------------------------------------------------------------
To test the models run testClassifiers.m. This script tests all three final models and
saves the performance metrics to files finalPerformance<mdl>.mat
