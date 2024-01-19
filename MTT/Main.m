
% The folder containing the folder of results
mainfolder = 'C:\Users\Shahm\Imperial College London\MTT Group Project - ME - General\FEA Group Project\Centre distance investigation\Results';

% a keyword that is in every folder
keyword = 'rounded';

varname = 'Centre Distance';

loggedData = {'CPRESS';
              'MaxInPlanePrincipalAbs';
              'MISES'};

AutoProcessor(mainfolder, keyword, varname, loggedData);