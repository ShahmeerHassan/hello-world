% Beam properties
Length = 1.0; % Length of the beam
E = 2.1e11; % Modulus of elasticity (Pa) - for steel
I = 1e-4; % Moment of inertia (m^4) - arbitrary value, adjust accordingly

% Loads and their positions
loads = [-5000];
distances = [0.5];

% Number of points where deflection is calculated
nPoints = 1000;
x = linspace(0, Length, nPoints);
deflection = zeros(1, nPoints);

% Calculate deflection due to each load
for i = 1:length(loads)
    for j = 1:nPoints
        % Distance from the point of interest to the load
        a = distances(i);
        b = Length - a;
        xj = x(j);
        
        % Calculation for segments on either side of the load
        if xj <= a
            deflection(j) = deflection(j) + (loads(i) * b * xj^2 * (Length - xj)) / (6 * E * I * Length);
        else
            deflection(j) = deflection(j) + (loads(i) * a * (Length - xj)^2 * xj) / (6 * E * I * Length);
        end
    end
end

% Plotting the deflection curve
figure;
plot(x, deflection, 'LineWidth', 2);
xlabel('Position along beam (m)');
ylabel('Deflection (m)');
title('Beam Deflection');
grid on;
