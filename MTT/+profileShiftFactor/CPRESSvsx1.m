% Plot CPRESS vs x1
close all
x1 = [-0.5
-0.3
-0.1
0
0.1
0.3
0.5];

cpress = [1278.38
1245.24
1214.75
1204.68
1192.34
1175.99
1160.63];

% Create a figure with a white background
fig = figure();
set(fig, 'Color', 'white');
plot(x1, cpress, "x-", 'MarkerSize', 10, 'Color', 'k', 'LineWidth', 2)
grid on
grid minor

xl = xlabel('x1');
yl = ylabel('Max CPRESS [MPa]');
ttl = title('Maximum pinion contact pressure vs x1');
xl.FontSize=16;
yl.FontSize=16;
ttl.FontSize=16;

% Create a y-axis at x=0
xline(0, 'k-', 'LineWidth', 1);
