function fnPlotData(sims, loggedData, varname)

% Initialise figure
fig = figure(1);
clf
% Plot Roll Angle vs Quantity
Plotting.QvsRollAngle(sims, loggedData, varname)

% Initialise figure
fig = figure(2);
clf
% Plot x vs quantity
Plotting.QvsX(sims, loggedData, varname)


end