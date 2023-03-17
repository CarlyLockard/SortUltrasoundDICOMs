% US image sort by time acquired
%% clean slate
clear 
close all
clc
%% open image series files
% get list of filenames
[junk_filename, folder_to_sort] = uigetfile('*.*', 'Select a file in the folder that you want to sort images from'); %user selects the first image
cd(folder_to_sort);
filenames_initial = ls('*.*'); %list all files 
m = 1;
for file_num = 1:size(filenames_initial,1)
    if ~contains(filenames_initial(file_num,:),' ') && ~strcmp(filenames_initial(file_num,1),'.')&&~strcmp(filenames_initial(file_num,:),'VERSION')
        filenames(m,:) = filenames_initial(file_num,:);
        m = m+1;
    elseif contains(filenames_initial(file_num,:),'VERSION')||strcmp(filenames_initial(file_num,:),'VERSION')
        delete(filenames_initial(file_num,:));
    end
end
%% open images and extract DICOM info to sort by time
for file_num = 1:size(filenames,1)
    loop_filename = filenames(file_num,:);
    header_info = dicominfo(loop_filename); %open the file header/get some image parameters
    image_time = header_info.ContentTime;
    sorting_array{file_num,1}=loop_filename;
    sorting_array{file_num,2}=image_time;
end

% saving_dir = strcat(folder_to_sort,'\sorted');
% mkdir(char(saving_dir));
% sort sorting array by time
sorting_array_sorted = sortrows(sorting_array,2);
for file_num = 1:size(sorting_array_sorted,1)
    file_num_char = num2str(file_num,'%04.f');
    loop_filename = char(sorting_array_sorted{file_num,1});
    loop_image_time = char(sorting_array_sorted{file_num,2});
    loop_new_filename = strcat('US_',file_num_char,'__',loop_image_time);
    movefile(loop_filename,loop_new_filename);
end

