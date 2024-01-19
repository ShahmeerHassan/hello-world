
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