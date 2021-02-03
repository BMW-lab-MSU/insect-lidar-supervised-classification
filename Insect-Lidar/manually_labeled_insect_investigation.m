close all;
%%
filepath = "C:\Users\kyler\Box\Data_2020_Insect_Lidar\2020-09-20";
labeled_data = create_label_vector(filepath);
%%
figure();
subplot(211);
imagesc(adjusted_data_decembercal(36).normalized_data);
title("Raw LiDAR Data - 192904 File Num 36");
subplot(212);
imagesc(labeled_data(2).labels(:,1024*36+1:1024*37));
title("Labeled Matrix");
%%
figure();
subplot(211);
imagesc(adjusted_data_decembercal(90).normalized_data);
title("Raw LiDAR Data - 192904 File Num 90");
subplot(212);
imagesc(labeled_data(2).labels(:,1024*90+1:1024*91));
title("Labeled Matrix");
%%
figure();
subplot(211);
imagesc(adjusted_data_decembercal(66).normalized_data);
title("Raw LiDAR Data");
subplot(212);
imagesc(labeled_data(16).labels(:,1024*66+1:1024*67));
title("Labeled Matrix");
%%
figure();
subplot(211);
imagesc(adjusted_data_decembercal(81).normalized_data);
title("Raw LiDAR Data");
subplot(212);
imagesc(labeled_data(11).labels(:,1024*81+1:1024*82));
title("Labeled Matrix");

