% INPUTS
csvfile = 'Dataset.csv';
OptionALaps = 1:3;
OptionBLaps = 4:6;


%% Main
close all

% Read in data
data = readtable(csvfile);

% filter ride heights
data = fnFilterRH(data);

% filter yaw
data = fnFilterYaw(data);

% Filter aerocoeff
data = fnFilterAeroCoef(data);

% Sort data by lap and channel
data=fnOrganiseData(data);

% Plot the laps and channels
fnPlotLaps(data);

% Plot vCar and Headwind for Laps 1-3
fnPlotvCarHeadwind(data, 1:3)

% Plot vCar and Headwind for Laps 4-6
fnPlotvCarHeadwind(data, 4:6)

% Plot vCar and Yaw
fnPlotvCarYaw(data, 1:6)

% Create and plot tDiff
data = fnPlottDiff(data);

% Check AeroCoeff
math = struct();
math.ConfigNames = {};
[data, math] = fnCheckAero(data, math, 1:6, [20 120 0], [-2.102 -2.1132]);
[data, math] = fnCheckAero(data, math, 1:6, [20 120 -2], [-2.0588 -2.1278]);
[data, math] = fnCheckAero(data, math, 1:6, [20 120 -4], [-1.8891 -2.0121]);
[data, math] = fnCheckAero(data, math, 1:6, [20 120 -6], [-1.8236 -1.9558]);
[data, math] = fnCheckAero(data, math, 1:6, [20 120 2], [-1.9561 -2.0131]);
[data, math] = fnCheckAero(data, math, 1:6, [20 120 4], [-1.9298 -2.0528]);
[data, math] = fnCheckAero(data, math, 1:6, [20 120 6], [-1.7512 -1.886]);
[data, math] = fnCheckAero(data, math, 1:6, [10 80 0], [-2.0858 -2.0968]);
[data, math] = fnCheckAero(data, math, 1:6, [-5 40 0], [-1.9564 -1.9694]);
math.ConfigNames = unique(math.ConfigNames);

% Plot deltas
fnPlotDeltas(math);

% Write data
fnWriteData(math);