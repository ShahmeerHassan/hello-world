function fnAnalytical(sims, varname)

% CPRESS vs. Roll Angle

a_def = 250;
E_def = 200;

% work out the parameter being swept
if contains(lower(varname), 'centre')
    defparam = a_def; % default centre distance
elseif contains(lower(varname), 'modulus')
    defparam = E_def; % default 
end

% find the sim with the default parameter value
fields = fieldnames(sims);
valfound = 0;
for i=1:numel(fields)
    fieldname = fields{i};
    
    if sims.(fieldname).val == defparam
        valfound = 1;
        defsim = fieldname;
    end
end
if valfound == 0
    error('Default parameter sim not found')
end

% Get analytical hertz pressure
[hertz_pressure, rollAnglePinion, angular_pitch_pinion] = fnEdCode(a_def, E_def);

rollAnglePinion = rollAnglePinion - angular_pitch_pinion;

tab = uitab('title', 'FEA vs Analytical', 'BackgroundColor', [1 1 1]);
axes(tab)
hold on
plot(rollAnglePinion, hertz_pressure, 'Color', 'red', 'LineWidth', 2, 'DisplayName', 'Hertz Theory')

% Get FEA hertz pressure
CPRESS_fea = max(sims.(defsim).CPRESS.pinion, [], 1);
rollangle_fea = sims.(defsim).rollangle.pinion;

plot(rollangle_fea, CPRESS_fea, 'marker', 'x', 'MarkerSize', 10, 'color', 'k', 'LineWidth', 2, 'DisplayName', 'FEA Results')


xl = xlabel('Roll Angle [deg]');
yl = ylabel('Max CPRESS [MPa]');
ttl = title('FEA vs Hertz Theory Comparison for max pinion CPRESS vs roll angle');
lgd = legend('Location', 'eastoutside');
xl.FontSize=16;
yl.FontSize=16;
ttl.FontSize=16;
lgd.FontSize=16;

end
