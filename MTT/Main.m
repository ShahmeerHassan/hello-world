
% The folder containing the folder of results
mainfolder = 'C:\Users\Shahm\Imperial College London\MTT Group Project - ME - General\FEA Group Project\Elastic Modulus Investigation';
% mainfolder = 'C:\Users\Shahm\Imperial College London\MTT Group Project - ME - General\FEA Group Project\x1 investigation\Results';
mainfolder = 'C:\Users\Shahm\Imperial College London\MTT Group Project - ME - General\FEA Group Project\Centre distance investigation\Results';


% a keyword that is in every folder
keyword = 'round';

varname = 'Centre Distance';

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
% Plots peak quantity from fig1 vs swept parameter
% Quantity = CPRESS, MIPPA, MISES
% swept parameter = centre distance, E, specified above
% Produces separate plots for wheel and pinion
% Produces separate plots for flank or root (MIPPA)
