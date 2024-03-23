clear all

%% input shaft
% Fr = [326.1 815.5 988.3]; % force in N
% T = [71.2 112 138.5]; % Nm
% b = [31.2 27.7 35.3] ./ 1000; % converting into m
% dref = [51.96 46.19 58.89] ./ 1000; % converting into m
% bearing_width = 0.03; % m

%% idler shaft
alpha = deg2rad(20);
beta = deg2rad(30);
T = [642.08 983.97 933.94];
dref = [73.9 73.9 69.28] ./ 1000;
b = [41.6 44.3 44.3] ./ 1000;

Ft = 2*T ./ dref;
Fn = Ft / (cos(alpha) * cos(beta));
Fr = Fn .* sin(alpha);
bearing_width = 0.03; % m

%%
% ASME parameters
Cm = 1.5;
Ct = 1.0;
taud = 1.79e08;
bearing_width = 0.03;

% Westinghouse parameters
n = 1.5;
Sy = 5.95e08;
Se = 3.67e09;

Lmom = bearing_width + max(b) - b./2;
L = bearing_width + max(b);
M = Lmom .* Fr;

dASME = ( (5.1/taud)*( (Cm*M).^2 + (Ct*T).^2 ).^0.5 ).^(1/3);
dWest = ( (32*n/pi) * ( (T/Sy).^2 + (M/Se).^2 ).^0.5  ).^(1/3);

dmin = max([dASME; dWest], [], 1);

% dmin = [13.5 17 17] ./1000;
dmin = [29 34 34];
%% overhang
rho_gear = 8000; % kg/m3
mass = rho_gear .* (pi*(dref./2).^2 .*b);

J = pi*dmin.^4 /32;
G = 8.25e10;
kt = G*J/L;

Ip = 0.5 .* mass .* (dref/2).^2;

omegan = sqrt(kt./Ip);

omegan_rpm = (omegan / (2 * pi)) * 60;
omegan_rpm

%% static defl

E = 212e+09;
I = 0.25.*pi.*(dmin./2).^4;

delta = Fr .* Lmom.^3 ./ (3*E*I);
nc = 29.9*sqrt(1./abs(delta))