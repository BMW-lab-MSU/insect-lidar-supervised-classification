basefilepath = 'C:\Users\kyler\Box\Data_2020_Insect_Lidar';
all_data = allDataCreation(basefilepath,7,10);
[train_idx,test_idx] = randomizeData(length(all_data),8000);
x = 1;
for i = 1:length(train_idx)
    train_data{x} = getData(basefilepath, all_data(train_idx(i)).dayID, all_data(train_idx(i)).folderID, all_data(train_idx(i)).imageID);
    x = x + 1;
end
