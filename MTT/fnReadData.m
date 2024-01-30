function sims = fnReadData(folderpaths, qvals,loggedData, facewidth)
fprintf('Reading data...')
tic

sims = struct();

Nsims = length(folderpaths);

% Assign names to sims
simNames = cell(Nsims, 1);
for i = 1:Nsims
    try

    % Assign name to sim
    simNames{i} = strcat('sim', num2str(i));

    % Independent variable value
    sims.(simNames{i}).val = qvals(i);

    for j = 1:length(loggedData)
        if strcmp(loggedData{j}, 'MaxInPlanePrincipalAbs')
            % Get all files in folder
            allfiles = dir(folderpaths{i});
            
            % Get files which only contain 'MaxInPlanePrincipalAbs'
            pinwh = allfiles(and(contains({allfiles.name}, loggedData{j}), contains({allfiles.name}, '.csv')));

            % Get files which only contain 'Flank' or 'Root'
            flankcsv = pinwh(contains({pinwh.name}, 'Flank'));
            rootcsv  = pinwh(contains({pinwh.name}, 'Root'));

            % Sort Pinion and Wheel for flank data
            flankpinioncsv = flankcsv(contains({flankcsv.name}, 'Pinion'));
            flankwheelcsv  = flankcsv(contains({flankcsv.name}, 'Wheel'));

            % Sort Pinion and Wheel for root data
            rootpinioncsv  = rootcsv(contains({rootcsv.name}, 'Pinion'));
            rootwheelcsv   = rootcsv(contains({rootcsv.name}, 'Wheel'));

            % Read flank data 
            sims.(simNames{i}).rawdata.(loggedData{j}).flank.pinion = table2array(readtable(fullfile(flankpinioncsv.folder, flankpinioncsv.name)));
            sims.(simNames{i}).rawdata.(loggedData{j}).flank.wheel  = table2array(readtable(fullfile(flankwheelcsv.folder, flankwheelcsv.name)));

            % Read root data 
            sims.(simNames{i}).rawdata.(loggedData{j}).root.pinion  = table2array(readtable(fullfile(rootpinioncsv.folder, rootpinioncsv.name)));
            sims.(simNames{i}).rawdata.(loggedData{j}).root.wheel   = table2array(readtable(fullfile(rootwheelcsv.folder, rootwheelcsv.name)));

            % Extract quantity from raw data table
            sims.(simNames{i}).(loggedData{j}).flank.pinion = sims.(simNames{i}).rawdata.(loggedData{j}).flank.pinion(3:end, 2:end) ./ facewidth;
            sims.(simNames{i}).(loggedData{j}).flank.wheel  = sims.(simNames{i}).rawdata.(loggedData{j}).flank.wheel(3:end, 2:end)  ./ facewidth;
            sims.(simNames{i}).(loggedData{j}).root.pinion  = sims.(simNames{i}).rawdata.(loggedData{j}).root.pinion(3:end, 2:end)  ./ facewidth;
            sims.(simNames{i}).(loggedData{j}).root.wheel   = sims.(simNames{i}).rawdata.(loggedData{j}).root.wheel(3:end, 2:end)   ./ facewidth;

            % Save the xroot data
            sims.(simNames{i}).xroot.pinion = sims.(simNames{i}).rawdata.(loggedData{j}).root.pinion(3:end,1);
            sims.(simNames{i}).xroot.wheel  = sims.(simNames{i}).rawdata.(loggedData{j}).root.wheel(3:end,1);
        else
            % Get all files in folder
            allfiles = dir(folderpaths{i});
            
            % Get files which only contain the parameter name e.g. CPRESS
            pinwh = allfiles(and(contains({allfiles.name}, loggedData{j}), contains({allfiles.name}, '.csv')));

            % Sort Pinion and Wheel (there should now only be one of each)
            pinioncsv = pinwh(contains({pinwh.name}, 'Pinion'));
            wheelcsv  = pinwh(contains({pinwh.name}, 'Wheel'));

            % Save raw data into struct
            sims.(simNames{i}).rawdata.(loggedData{j}).pinion = table2array(readtable(fullfile(pinioncsv.folder, pinioncsv.name)));
            sims.(simNames{i}).rawdata.(loggedData{j}).wheel  = table2array(readtable(fullfile(wheelcsv.folder,  wheelcsv.name)));

            % Save array of the quantity (e.g. CPRESS)
            sims.(simNames{i}).(loggedData{j}).pinion = sims.(simNames{i}).rawdata.(loggedData{j}).pinion(3:end, 2:end) ./ facewidth;
            sims.(simNames{i}).(loggedData{j}).wheel  = sims.(simNames{i}).rawdata.(loggedData{j}).wheel(3:end, 2:end)  ./ facewidth;

            % Record roll angle and x coordinate (flank or root)
            if j==1
                sims.(simNames{i}).rollangle.pinion = sims.(simNames{i}).rawdata.(loggedData{j}).pinion(1,2:end);
                sims.(simNames{i}).rollangle.wheel  = sims.(simNames{i}).rawdata.(loggedData{j}).wheel(1,2:end);
                
                sims.(simNames{i}).xflank.pinion    = sims.(simNames{i}).rawdata.(loggedData{j}).pinion(3:end,1);
                sims.(simNames{i}).xflank.wheel     = sims.(simNames{i}).rawdata.(loggedData{j}).wheel(3:end,1);
            end

        end
    end
    catch
        warning('Something failed')
        disp(folderpaths{i})
    end
end

time = toc;
fprintf('Done in %.1f seconds.\n', time)
end