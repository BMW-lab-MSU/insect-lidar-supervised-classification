function empty_labels = create_empty_labels(folder_path)
folders = string(ls(folder_path));
empty_labels = struct("folder_names", [], "labels", []);
for i = 3: length(folders) - 1
    num_files = length(ls(folder_path + "/" + folders(i))) - 3;
    label_matrix = zeros([178 1024 * num_files]);
    empty_labels(i-2).labels = label_matrix;
    empty_labels(i-2).folder_names = folders(i);
end
end

    

