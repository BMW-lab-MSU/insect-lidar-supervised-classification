
function [appended, label, mirror] = FFTCheck_Labels(image, folder_path)
% This function loads in an image of concatinated WingBeat Modulated LIDAR
% shots and the path of the folder that it came from. It then read the
% labels in fftcheck and appends them on the bottom of the image.
% image: the LIDAR data/image
% folder_path: file path to the folder containing data
% Joseph Aist

fft = load(folder_path + '/events/fftcheck.mat');
label = zeros([1,length(image)]); % shows the time of an insect hit.
mirror = zeros(size(image)); % shows the location of the insect with distance and time.
folder = dir(folder_path);

for i = 1:length(fft.fftcheck.insects)
    k = fft.fftcheck.insects(i).foldernum; % Get folder number
    j = fft.fftcheck.insects(i).filenum; % Get file number within folder
    
    range = fft.fftcheck.insects(i).range; % Get the range of the insect hit
    
    skip = 0;
    if k == 1
        if j == 1
            label(fft.fftcheck.insects(i).lb:fft.fftcheck.insects(i).ub) = 1;
            mirror(fft.fftcheck.insects(i).range,fft.fftcheck.insects(i).lb:fft.fftcheck.insects(i).ub) = 1;
        else 
            label((j-1)*1024+fft.fftcheck.insects(i).lb:(j-1)*1024+fft.fftcheck.insects(i).ub) = 1;
            mirror(fft.fftcheck.insects(i).range,(j-1)*1024+fft.fftcheck.insects(i).lb:(j-1)*1024+fft.fftcheck.insects(i).ub) = 1;
        end
            
    else
        for l = 1:k-1
            files = dir(folder_path + '/' + folder(l+3).name); %Lists folder contents. The +3 skips the ".",".." and image file
            files = rmfield(files, 'folder'); %Removes unnecessary info from the structure
            files = rmfield(files,'date');
            files = rmfield(files,'bytes');
            files = rmfield(files,'isdir');
            files = rmfield(files,'datenum');
            files = struct2cell(files)';
        
            skip = skip + length(files); % number of files in previous folders
        end      
        label(skip*1024+(j-1)*1024+fft.fftcheck.insects(i).lb:skip*1024+(j-1)*1024+fft.fftcheck.insects(i).ub) = 1;
        mirror(fft.fftcheck.insects(i).range,skip*1024+(j-1)*1024+fft.fftcheck.insects(i).lb:skip*1024+(j-1)*1024+fft.fftcheck.insects(i).ub) = 1;
    end 
end

appended = [image;label];

end
