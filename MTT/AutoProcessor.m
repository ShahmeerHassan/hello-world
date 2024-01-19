function AutoProcessor(mainfolder, keyword, varname, loggedData, facewidth)

% Get the subfolders containing the desired results
[folderpaths, foldernames] = fnGetSubfolders(mainfolder, keyword);

% Determine what values have been used based on folder names
qvals = fnGetValues(foldernames);

% Read in the data
sims = fnReadData(folderpaths, qvals, loggedData, facewidth);

% Plot all the data
fnPlotData(sims, loggedData, varname, qvals);

end
