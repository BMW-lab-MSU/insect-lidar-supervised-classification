%%
load('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\testing3\testingData.mat')
%%
testingFeatures=nestedcell2mat(testingFeatures);
testingLabels=nestedcell2mat(testingLabels);
%% 
%load('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\notFinalButUseful\intermediateModels\RUS_w_optimal_imbal_params.mat')
%load('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\training3\finalModelRUS.mat')
load('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\notFinalButUseful\preIntermediateModels\postGridNet.mat')
%% make predictions
%mdl=userdata.model{1};
mdl=userdata.model{1};
ypred=predict(mdl,testingFeatures);
%% find confusion matrix elements
TP=and(ypred,testingLabels);
TN=and(not(ypred),not(testingLabels));
FP=and(ypred,not(testingLabels));
FN=and(not(ypred),testingLabels);
%% calculate performance metrics
confmat=[sum(TN),sum(FP);sum(FN),sum(TP)];
[accuracy, precision, recall, f2, f3, mcc] = analyzeConfusion(confmat)
performance=struct();
performance.accuracy=accuracy;
performance.precision=precision;
performance.recall=recall;
performance.f2=f2;
performance.f3=f3;
performance.mcc=mcc;
performance.confusion=confmat;
save('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\notFinalButUseful\preintermediatePerformance\postGridPerformNet.mat','performance')