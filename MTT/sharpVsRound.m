% Plot CPRESS vs rollangle for sharp and rounded

mainfolder = 'C:\Users\Shahm\Imperial College London\MTT Group Project - ME - General\FEA Group Project\Centre distance investigation\Results';

% a keyword that is in every folder
keyword_sharp = 'sharp';
keyword_round = 'round';

varname = 'Centre Distance';
loggedData = {'CPRESS'};

facewidth = 30;

% Get the subfolders containing the desired results
[folderpaths, foldernames] = fnGetSubfolders(mainfolder, keyword_sharp);
% Determine what values have been used based on folder names
[qvalssharp, ~, folderpaths] = fnGetValues(foldernames, folderpaths);
% Read in the data
simssharp = fnReadData(folderpaths, qvalssharp, loggedData, facewidth);

% Get the subfolders containing the desired results
[folderpaths, foldernames] = fnGetSubfolders(mainfolder, keyword_round);
% Determine what values have been used based on folder names
[qvalsround, ~, folderpaths] = fnGetValues(foldernames, folderpaths);
% Read in the data
simsround = fnReadData(folderpaths, qvalsround, loggedData, facewidth);

% Plot all the data
% fnPlotData(sims, loggedData, varname, qvals);

%%
% Define
lw = 2; % line width

% Create tab in figure
tabtitle = ['RollAngleVsCPRESS'];
tab = uitab('title', tabtitle, 'BackgroundColor', [1 1 1]);
axes(tab)
hold on

for ii=1:2
    if ii==1
        simnames = fieldnames(simssharp);
        numColours = length(simnames);
        colours = sky(numColours);
        colours = num2cell(colours, 2);
        sim = struct();
        sims = simssharp;
        cc = 'k';
    else
        simnames = fieldnames(simsround);
        numColours = length(simnames);
        colours = gray(numColours);
        colours = num2cell(colours, 2);
        sim = struct();
        sims = simsround;
        cc = 'red';
    end


    for q = 1:length(loggedData)
    
        for s = 1:length(simnames)
            % Get sim name
            nsim = simnames{s};
    
            % Get roll angle
            rollangle = sims.(nsim).rollangle.pinion;
    
            % Get data
            data = sims.(nsim).(loggedData{q}).pinion;
            
            % Get max at each roll angle
            maxes = max(data, [], 1);
            
            dname = [varname,' = ', num2str(round(sims.(nsim).val, 2), '%.2f')];
    
            plot(rollangle, maxes, 'color', cc, 'LineWidth', lw, 'DisplayName', dname);
    
        end
    end
end
xl = xlabel('Roll Angle [deg]');
yl = ylabel('Max CPRESS [MPa]');
ttl = title('Effect of rounding teeth tips on max pinion CPRESS vs roll angle for varying centre distance');
% lgd = legend('Location', 'eastoutside');
xl.FontSize=16;
yl.FontSize=16;
ttl.FontSize=16;
% lgd.FontSize=16;

xlim([7 13.5])
ylim([500 1500])

