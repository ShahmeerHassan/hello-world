close all

x = [-0.5
0.5
0.75
1
-0.3
-0.1
0
0.1
0.3];

y = [249.7274073
249.8939102
250.1702122
250.4991638
249.6201726
249.5909951
249.6007177
249.6299049
249.7371755];

% Sort x in ascending order and get the indices
[x, idx] = sort(x);

% Sort y accordingly based on the sorted indices
y = y(idx);

% Create a figure with a white background
fig = figure();
set(fig, 'Color', 'white');
plot(x, y, "x-", 'MarkerSize', 10, 'Color', 'k', 'LineWidth', 2)
grid on
grid minor

xl = xlabel('x1');
yl = ylabel('Tight Mesh Centre Distance [mm]');
ttl = title('Tight Mesh Centre Distance vs x1');
xl.FontSize=16;
yl.FontSize=16;
ttl.FontSize=16;

% Create a y-axis at x=0
xline(0, 'k-', 'LineWidth', 1);
yline(250, 'k--', 'LineWidth', 1);