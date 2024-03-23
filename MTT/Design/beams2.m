clear all

engine = 1;

% 0 = layshaft (no load)
% 1 = layshaft engine 1.1L
% 2 = layshaft engine 1.3L
% 3 = layshaft engine 1.8L

% 10 - driveshaft (no load)
% 11 = driveshaft engine 1.1L
% 12 = driveshaft engine 1.3L
% 13 = driveshaft engine 1.8L

%% engine 1
if engine==1
    distances = [0.080
    0.206
    0.285
    0.340
    0.436
    0.503
    0.599
    ]; % Positions of the loads in meters
    
    
    dref = [183.60
    51.96
    78.52
    88.33
    98.15
    107.96
    41.57
    ];
    
    b = [110.158
    31.177
    47.112
    53.001
    58.890
    64.779
    12.068
    ];
elseif engine == 2
    distances = [0.101
    0.203
    0.228
    0.336
    0.430
    0.500
    0.592
    ]; % Positions of the loads in meters
    
    
    dref = [115.47
    60.62
    68.70
    73.90
    78.52
    98.15
    46.19
    ];
    
    b = [69.282
    36.373
    41.223
    44.341
    47.112
    58.890
    21.115
    ];
elseif engine == 3
    distances = [0.100
    0.203
    0.288
    0.337
    0.433
    0.502
    0.615
    ]; % Positions of the loads in meters
    
    
    dref = [117.78
    60.62
    68.70
    78.52
    88.33
    103.92
    46.19
    ];
    
    b = [70.668
    36.373
    41.223
    47.112
    53.001
    62.354
    19.278
    ];
elseif engine == 0 || engine == 10
    loads = [];
    distances = [];
elseif engine == 11
    distances = [0.050
    0.129
    0.184
    0.280
    0.347
    0.440
    ];

    dref = [176.67
    147.80
    129.90
    121.24
    107.96
    143.18
    ];

    b = [31.177
    47.112
    53.001
    58.890
    64.779
    41.569
    ];

elseif engine == 12
    distances = [0.047
    0.132
    0.179
    0.274
    0.344
    0.436
    ];

    dref = [133.37
    125.29
    115.47
    103.92
    80.83
    96.99
    ];

    b = [36.373
    41.223
    44.341
    46.765
    58.890
    44.341
    ];

elseif engine == 13
    distances = [0.047
    0.132
    0.183
    0.277
    0.346
    0.441
    ];

    dref = [141.45
    125.29
    119.51
    103.92
    86.60
    106.23
    ];

    b = [84.870
    75.171
    71.707
    62.354
    51.962
    44.341
    ];

end

%%

rho_shaft = 7850;
if engine < 5
    L = 0.71; % Length of the beam in meters
    davg = 44.82857143/1000;
    W = 80.81614601;
    xCOM = 0.346;
elseif engine < 15
    L = 0.52009;
    davg = 29.76052222/1000;
    W = (364238.00/1000000000)  *  rho_shaft  *  9.81; % rho * V * g
    xCOM = 0.25498;
end

E = 212e+09;

I = 0.25*pi*(davg/2)^4;

rho_gear = 8000;

% volume
try
    V = pi.*(dref./2).^2.*b / 1000000000;
catch
    V = [];
end
loads = [-1 .* rho_gear * V * 9.81; -W];
distances = [distances; xCOM];
% Calculate the sum of the loads
sum_loads = sum(loads);

% Calculate the moment about the left end of the beam
moment = sum(loads .* distances);

% Construct matrix A and vector B
A = [1, 1; 0, -L];
B = [-sum_loads; sum(loads.*distances)];

% Calculate reaction forces
X =A\B;
Ra = X(1);
Rb = X(2);

% mesh
x = linspace(0,L,100);

% Calculate the sum of all the terms
tempval = 0;
for i = 1:length(loads)
    tempval = tempval + (loads(i)/6) * max(0, x - distances(i)).^3;
end

% Adjust the boundary condition calculation for C
% Calculate deflection using boundary condition that deflection at x = L is 0
v_at_L = (Ra/6)*L^3 + sum(loads/6 .* (L - distances).^3); % Deflection due to Ra and loads at x = L
C = -v_at_L / L; % Adjusted C calculation

% Calculate deflection
v = (   (Ra/6)*x.^3 + tempval + C*x   )/(E*I);
vmm = v * 1000;

if max(vmm) > abs(min(vmm))
    % Find maximum deflection and its position
    [max_deflection_mm, max_index] = max(vmm);
    max_location_m = x(max_index);
else
    [max_deflection_mm, max_index] = min(vmm);
    max_location_m = x(max_index);
end
vmax = v(max_index);

nc = 29.9*sqrt(1/abs(vmax));

% Plot the deflection curve
close all
figure('Color', [1 1 1])
plot(x, vmm, 'LineWidth', 1, 'Color', [0 0 0]); % Plot deflection with a thicker line
if engine == 1
    title('Layshaft Deflection (1.1L Engine)');
elseif engine == 2
    title('Layshaft Deflection (1.3L Engine)');
elseif engine == 3
    title('Layshaft Deflection (1.8L Engine)');
elseif engine == 0
    title('Layshaft Deflection under weight')
elseif engine == 10
    title('Driveshaft Deflection under weight')
elseif engine == 11
    title('Driveshaft Deflection (1.1L Engine)');
elseif engine == 12
    title('Driveshaft Deflection (1.3L Engine)');
elseif engine == 13
    title('Driveshaft Deflection (1.8L Engine)');
end
xlabel('Position along shaft (m)');
ylabel('Deflection [mm]');
hold on; % Keep the plot for adding scatter points

% Loop through loads to add scatter points at the load positions
for i = 1:length(loads)
    % Coordinates for the scatter point
    x_scatter = distances(i);
    y_scatter = interp1(x, vmm, x_scatter); % Interpolate to find the deflection at the load position
    
    % Add scatter point
    scatter(x_scatter, y_scatter, 'Marker', 'x', 'SizeData', 200, 'Color', [1 0 0], 'LineWidth', 1.5);
end

% Get current axis limits
x_limits = xlim;
y_limits = ylim;

% Position for the text in the bottom right corner
x_pos = x_limits(2) * 0.98; % Slightly inside the right limit
y_pos = y_limits(1) + diff(y_limits) * 0.02; % Slightly above the bottom limit

% Annotate the maximum deflection on the plot and include Critical Shaft Speed
max_deflection_text = sprintf('Max deflection: %.3f mm at %.3f m\nCritical Shaft Speed: %.0f rpm', max_deflection_mm, max_location_m, nc);
text(x_pos, y_pos, max_deflection_text, 'FontSize', 20, 'HorizontalAlignment', 'right', 'VerticalAlignment', 'bottom', 'BackgroundColor', 'w', 'EdgeColor', 'k', 'Margin', 5, 'EdgeColor', 'none');

hold off; % Release the plot hold

grid on
grid minor
ax = gca;
ax.FontSize = 24;

fprintf('Max deflection: %.15f \n', v(max_index))
fprintf('n_critical: %.0f \n', nc)

%% whirl frequencies
W = loads(1:end-1);
negdist = L-distances(1:end-1);
deltas = W.*negdist.*(3.*L.^2 - 4.*negdist.^2)./(48*E*I);
deltas = abs(deltas);
g = 9.81;

if engine<5
    omega = sqrt(  g*  ( sum(W.*deltas) / sum( W .* deltas.^2 ) )  );
else
    omega = sqrt(  g*  ( (W.*deltas) ./ (W .* deltas.^2) )  );
    [omega, idx] = min(omega);
    idx
end
omegarpm = (omega / (2 * pi)) * 60