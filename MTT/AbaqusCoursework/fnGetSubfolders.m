function [folderpaths, foldernames] = fnGetSubfolders(mainfolder, keyword)

% Get all subfolders in main folder
allfolders = dir(mainfolder);

% Get all subfolders with the keyword in their name
struct_folders = allfolders(contains({allfolders.name}, keyword));

foldernames = {struct_folders.name};

% Create cell array of all folder filepaths
folderpaths = fullfile({struct_folders.folder},foldernames);

% Transpose for ease of use
foldernames = foldernames';
folderpaths = folderpaths';
end