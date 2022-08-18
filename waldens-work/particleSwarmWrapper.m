rng(0, 'twister');

costBounds = [1E3,1E5];
augBounds = [4E1,4E2];
usBounds=[0,0.6];

lb=[costBounds(1),augBounds(1),usBounds(1)];
ub=[costBounds(2),augBounds(2),usBounds(2)];

options=optimoptions('particleswarm','MaxIterations',14,'SwarmSize',8);
[sol,fval,exitflag,output]=particleswarm(@particleSwarmTargetRUS,3,lb,ub,options);
result=struct();
result.costRatio=sol(1);
result.nAugment=sol(2);
result.US=sol(3);
save('C:\Users\v59g786\Desktop\REU_project\code_by_walden\revisedPipeline\data\training3\PSORUSaugcost.mat',"result")