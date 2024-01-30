function [hertz_pressure, rollAnglePinion, angular_pitch_pinion] = fnEdCode(a, E)
% Chat GPT converted Ed's code from Python to MATLAB

% a = centre distance in mm

%% Initial
cid = [0, 1, 7, 0, 2, 6, 4, 3];

% Pinion Basic Parameters
Mn = 4 + 0.5 * cid(8);
z1 = 25 + cid(5) + cid(6);
x1 = (cid(1) + cid(2)) / 10;

alpha_n = 20 * 2 * pi / 360;
dref1 = z1 * Mn;
da1 = dref1 + 2 * Mn * (x1 + 1);
df1 = dref1 + 2 * Mn * (x1 - 1.25);
db1 = dref1 * cos(alpha_n);
rb1 = db1 / 2;

fprintf('Pinion Parameters are given by\n');
fprintf('Mn is %.2f mm, z1 is %d, x1 is %.2f mm\n', Mn, z1, x1);
fprintf('dref1 is %.2f mm, da1 is %.2f mm, df1 is %.2f mm, and db1 is %.2f mm\n', dref1, da1, df1, db1);
fprintf('-\n');

angular_pitch_pinion = 360/z1;

%% Wheel Basic Parameters
z2 = 50 + cid(7) + cid(8);
x2 = (cid(3) + cid(4)) / 20;

dref2 = z2 * Mn;
da2 = dref2 + 2 * Mn * (x2 + 1);
df2 = dref2 + 2 * Mn * (x2 - 1.25);
db2 = dref2 * cos(alpha_n);
rb2 = db2 / 2;

fprintf('Wheel Parameters are given by\n');
fprintf('Mn is %.2f mm, z2 is %d, x2 is %.2f mm\n', Mn, z2, x2);
fprintf('dref2 is %.2f mm, da2 is %.2f mm, df2 is %.2f mm, and db2 is %.2f mm\n', dref2, da2, df2, db2);
fprintf('-\n');

%% Starting with Stuff for Pinion and Gear
fprintf('Properties related to centre distance, a, for both gears\n');

% Find possible range for a using tight mesh alpha_tw from Desmos.
% Max is addendum circles, minimum is tight mesh distance
a_max = (da1 + da2) / 2;
alpha_tw_tm = 0.3745;
a_tm = (Mn * cos(alpha_n) * 0.5 * (z1 + z2)) / (cos(alpha_tw_tm));
fprintf('a_Max and a_Min are %.2f mm and %.2f mm\n', a_max, a_tm);

% Decide on a value to use and calculate corresponding working pressure angle
% a = 250.5;
alpha_tw = acos((db1 + db2) / (2 * a));
fprintf('Chosen a and working pressure angle are %.2f mm and %.2f\n', a, alpha_tw);

% Calculate contact patch length
ga = (((da1 / 2) ^ 2) - ((db1 / 2) ^ 2)) ^ 0.5 + (((da2 / 2) ^ 2) - ((db2 / 2) ^ 2)) ^ 0.5 - ((db1 + db2) / 2) * tan(alpha_tw);
fprintf('Contact patch length ga (distance between A and B on diagram) is %.2f mm\n', ga);

% Calculate base pitch and contact ratio
pb = pi * Mn * cos(alpha_n);
epsilon = ga / pb;
fprintf('Base pitch is %.2f mm, contact ratio is %.2f (this should be between 1 and 2)\n', pb, epsilon);
fprintf('-\n');

%% PINION FOCUS
fprintf('Pinion Focus\n');

% Define x grid to discretize the contact patch
N = 100;
x = linspace(0, ga, N+1);

% Calculate lengths needed for polar expression
T1A = sqrt((da1/2)^2 - (db1/2)^2);
T1B = T1A - ga;
fprintf('T1A is %.6f mm and T1B is %.6f mm\n', T1A, T1B);

% Set up array of distances from T1 to any discretized x location
T1x = T1B + x;
fprintf('Discrete T1x grid is initialized with %d locations\n', N+1);

% Set up array of alpha values for each T1x
alpha = atan(T1x / rb1);
fprintf('Discrete alpha grid is initialized with %d locations\n', N+1);

% Set up array of r and phi values based on alpha
r = rb1 ./ cos(alpha);
phi = tan(alpha) - alpha;
fprintf('Discrete r and phi grids initialized with %d locations\n', N+1);

% Find tooth widths at ref and base circles
sref1 = Mn * (((pi)/2) + 2 * x1 * tan(alpha_n));
sb1 = db1 * ((sref1 / dref1) + tan(alpha_n) - alpha_n);
fprintf('Tooth width at dref is %.6f mm and at db is %.6f mm\n', sref1, sb1);

% Set up array of rotated phi
phi_rot = ((pi)/2) + (sb1/db1) - phi;

fprintf('Discrete phi rot grid initialized with %d locations\n', N+1);

% Convert to Cartesian coordinates
x_values = r .* cos(phi_rot);
y_values = r .* sin(phi_rot);

fprintf('Discrete x and y value grids initialized with %d locations\n', N+1);

% Generate Inverse Points
x_values_in = -x_values;

% Find max value and plot top of tooth
x_values_max = max(x_values);
y_values_max = max(y_values);
x_values_tip = x_values_max:-0.1:(-1 * x_values_max);
y_values_tip = zeros(1, length(x_values_tip)) + y_values_max;

%% Plot
% fprintf('X and Y Values Plotted For Visualization\n');
% figure;
% plot(x_values, y_values, 'color', 'blue');
% hold on;
% plot(x_values_in, y_values, 'color', 'blue');
% plot(x_values_tip, y_values_tip, 'color', 'blue');
% title('Pinion Tooth Profile');
% xlabel('x coordinate / mm');
% ylabel('y coordinate / mm');
% grid on;
% 
% % Plot
% fprintf('X and Y Values Plotted For Visualization\n');
% 
% figure;
% plot(x_values, y_values, 'color', 'blue');
% hold on;
% plot(x_values_in, y_values, 'color', 'blue');
% plot(x_values_tip, y_values_tip, 'color', 'blue');
% title('Pinion');
% xlabel('x coordinate / mm');
% ylabel('y coordinate / mm');
% xlim([-10, 10]);
% ylim([86, 98]);
% grid on;

%% WHEEL FOCUS
fprintf('Wheel Focus\n');
% Define x grid to discretize the contact patch for wheel
x_wheel = zeros(1, N+1);
for i = 1:N+1
    x_wheel(i) = (i * ga) / N;
end
fprintf('Discrete x grid is initialized with %d locations\n', N+1);

% Calculate lengths needed for polar expression
T2B = sqrt((da2/2)^2 - (db2/2)^2);
T2A = T2B - ga;
fprintf('T2B is %.2f mm and T2A is %.2f mm\n', T2B, T2A);

% Set up array of distances from T2 to any discretized x location
T2x = zeros(1, N+1);
for i = 1:N+1
    T2x(i) = T2A + x_wheel(i);
end
fprintf('Discrete T2x grid is initialized with %d locations\n', N+1);

% Set up array of alpha_wheel values for each T2x
alpha_wheel = zeros(1, N+1);
for i = 1:N+1
    alpha_wheel(i) = atan(T2x(i) / rb2);
end
fprintf('Discrete alpha_wheel grid is initialized with %d locations\n', N+1);

% Set up array of r_wheel and phi_wheel values based on alpha_wheel
r_wheel = zeros(1, N+1);
phi_wheel = zeros(1, N+1);
for i = 1:N+1
    r_wheel(i) = rb2 / cos(alpha_wheel(i));
    phi_wheel(i) = tan(alpha_wheel(i)) - alpha_wheel(i);
end
fprintf('Discrete r_wheel and phi_wheel grids initialized with %d locations\n', N+1);

% Find wheel tooth widths at ref and base circles
sref2 = Mn * (((pi) / 2) + 2 * x2 * tan(alpha_n));
sb2 = db2 * ((sref2 / dref2) + tan(alpha_n) - alpha_n);
fprintf('Wheel tooth width at dref is %.2f mm and at db is %.2f mm\n', sref2, sb2);

% Set up array of rotated phi for wheel
phi_wheel_rot = zeros(1, N+1);
for i = 1:N+1
    phi_wheel_rot(i) = ((pi) / 2) + (sb2 / db2) - phi_wheel(i);
end
fprintf('Discrete phi_wheel_rot grid initialized with %d locations\n', N+1);

% Convert to cartesian coordinates
x_values_wheel = zeros(1, N+1);
y_values_wheel = zeros(1, N+1);
for i = 1:N+1
    x_values_wheel(i) = r_wheel(i) * cos(phi_wheel_rot(i));
    y_values_wheel(i) = r_wheel(i) * sin(phi_wheel_rot(i));
end
fprintf('Discrete x and y value grids initialized with %d locations for Wheel\n', N+1);

% Generate Inverse Points for Wheel
x_values_wheel_in = zeros(1, N+1);
for i = 1:N+1
    x_values_wheel_in(i) = x_values_wheel(i) * (-1);
end

% Find max value and plot top of tooth for wheel
x_values_wheel_max = max(x_values_wheel);
y_values_wheel_max = max(y_values_wheel);
x_values_wheel_tip = x_values_wheel_max : -0.1 : (-1 * x_values_wheel_max);
y_values_wheel_tip = zeros(1, length(x_values_wheel_tip));
for i = 1:length(x_values_wheel_tip)
    y_values_wheel_tip(i) = y_values_wheel_max;
end

%% Plot
% fprintf('X and Y Values Plotted For Visualisation\n');
% 
% figure;
% title('Wheel');
% xlabel('x coordinate / mm');
% ylabel('y coordinate / mm');
% plot(x_values_wheel, y_values_wheel, 'color', 'red');
% hold on;
% plot(x_values_wheel_in, y_values_wheel, 'color', 'red');
% plot(x_values_wheel_tip, y_values_wheel_tip, 'color', 'red');
% xlim([-10, 10]);
% ylim([152, 166]);
% grid on;
% hold off;

%% ANALYTICAL LOADING AND STRESS CALCULATIONS:
fprintf('-\n');
fprintf('Analytical Loading and Stress Calculations\n');
fprintf('-\n');

% INPUT PARAMETERS ARE TORQUE, FACE WIDTH, ELASTIC MODULUS, AND POISSON'S RATIO
T = 2500; % Nm
b = 30; % mm
% E = 207; % GPa % added as input to function
v = 0.3;

% Tooth normal force per unit length for Pinion torque and base radius
Pn_max = T / ((b / 1000) * (rb1 / 1000));
fprintf('Max tooth normal force per unit length for pinion is %.4f N/m\n', Pn_max);

% Calculate Contact Modulus
E_star = (((1 - v^2) / E) + ((1 - v^2) / E)) ^ (-1);
fprintf('Assuming gears are SAME material, Contact Modulus E* is %.4f GPa\n', E_star);

% Set up piecewise array of Pn for each value of x along the contact line
Pn_x = zeros(1, N + 1);
for i = 1:N+1
    if (x(1, i) / ga) < (1 - (1 / epsilon))
        Pn_x(1, i) = Pn_max * (x(1, i) / ga) * (1 / (1 - (1 / epsilon)));
    else
        if (1 - (1 / epsilon)) < (x(1, i) / ga) && (x(1, i) / ga) < (1 / epsilon)
            Pn_x(1, i) = Pn_max;
        else
            Pn_x(1, i) = Pn_max * (1 - (((x(1, i) / ga) - (1 / epsilon)) / (1 - (1 / epsilon))));
        end
    end
end
fprintf('Piecewise definition of normal Pressure across contact line created in array\n');

% Define theta and relative radius of curvature arrays for pinion and wheel
theta1 = zeros(1, N+1);
for i = 1:N+1
    theta1(1, i) = T1x(1, i) / rb1;
end

theta1_degrees = theta1 * (360 / (2 * pi));

theta2 = zeros(1, N+1);
for i = 1:N+1
    theta2(1, i) = T2x(1, i) / rb2;
end

R = zeros(1, N+1);
for i = 1:N+1
    R(1, i) = ((1 / (rb1 * theta1(1, i))) + (1 / (rb2 * theta2(1, i))))^(-1);
end

fprintf('Roll angles and relative radius of curvature arrays defined\n');

% Define Hertz Pressure Array
P0 = zeros(1, N+1);
for i = 1:N+1
    P0(1, i) = ((Pn_x(1, i) * E_star) / (pi * R(1, i)))^0.5;
end

hertz_pressure = P0;
rollAnglePinion = theta1_degrees;

fprintf('Hertz pressure against pinion roll angle plotted\n');

% figure;
% plot(theta1_degrees, P0, 'color', 'black');
% title('Max Hertz Pressure');
% xlabel('Pinion Roll Angle / degrees');
% ylabel('Max Hertz Pressure / MPa');
% ylim([0, 1400]);
% grid on;

%% Predict maximum bending stress at tooth roots using Lewis Equation
Y = 3.4; % for spur gears
sigma_b_1 = (2 * T) / (dref1 * b * Mn) * Y;
sigma_b_2 = (2 * T) / (dref2 * b * Mn) * Y;
fprintf('Maximum bending stress at tooth roots for pinion is %.2f MPa\n', sigma_b_1 * 1000);
fprintf('Maximum bending stress at tooth roots for wheel is %.2f MPa\n', sigma_b_2 * 1000);

% Calculate delta 2 for gears to touch
G = z2 / z1;
delta2 = (1 + (1 / G)) * (alpha_tw + (tan(alpha_n) - alpha_n)) + (2 * (x1 + x2) * tan(alpha_n)) / z2 - (2 * a * sin(alpha_tw)) / (z2 * Mn * cos(alpha_n));
delta2deg = delta2 * 360 / (2 * pi);
fprintf('delta2: %.2f degrees\n', delta2deg);


end