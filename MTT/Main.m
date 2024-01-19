
% The folder containing the folder of results
mainfolder = 'C:\Users\Shahm\Imperial College London\MTT Group Project - ME - General\FEA Group Project\Elastic Modulus Investigation';

% a keyword that is in every folder
keyword = 'E=';

varname = 'Young''s Modulus';

loggedData = {'CPRESS';
              'MaxInPlanePrincipalAbs';
              'MISES'};

facewidth = 30;

AutoProcessor(mainfolder, keyword, varname, loggedData, facewidth);

%% INFO
% Figure 1
% Plots Quantity vs. Roll Angle 
% Quantity = CPRESS, MIPPA, MISES
% Produces separate plots for wheel and pinion
% Produces separate plots for flank or root (MIPPA)

% Figure 2
% Plots Quantity vs. xflank or xroot 
% Quantity = CPRESS, MIPPA, MISES
% Produces separate plots for wheel and pinion
% Produces separate plots for flank or root (MIPPA)

% Figure 3
% Plots peak quantity vs swept parameter
% Quantity = CPRESS, MIPPA, MISES
% swept parameter = centre distance, E, specified above
% Produces separate plots for wheel and pinion
% Produces separate plots for flank or root (MIPPA)
