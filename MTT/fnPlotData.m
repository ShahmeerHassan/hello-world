function fnPlotData(sims, loggedData, varname, qvals)
close all

% Initialise figure
fig = figure(1);
clf
% Plot Roll Angle vs Quantity
Plotting.QvsRollAngle(sims, loggedData, varname)

% % Initialise figure
% fig = figure(2);
% clf
% % Plot x vs quantity
% Plotting.QvsX(sims, loggedData, varname)

% Initialise figure
fig = figure(3);
clf
% Plot peak roll angle quantity vs
Plotting.MaxQvsParam_rollangle(sims, loggedData, qvals, varname, [7.6 12.8])

end