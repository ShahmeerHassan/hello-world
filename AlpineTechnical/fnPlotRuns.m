function fnPlotRuns(data, x, y)
% This function automates plotting laps

OptionA = 1:3;
OptionB = 4:6;

colors = [0 0 1; 0 0.5 1; 0 1 1; 1 0 0; 0.5 0 0; 1 0.5 0];
% colors = [0 0 1; 0 0 1; 0 0 1; 1 0 0; 1 0 0; 1 0 0];
linestyles = {"-", "-", "-", "-", "-", "-"};

hold on

for i=OptionA
    plot(data.(x){i}, data.(y){i}, color=colors(i,:), LineStyle=linestyles{i}, DisplayName="Lap "+num2str(i))
end

for i=OptionB
    plot(data.(x){i}, data.(y){i}, color=colors(i,:), LineStyle=linestyles{i}, DisplayName="Lap "+num2str(i))
end

legend()
xlim([min(cell2mat(data.(x)(1:6))) max(cell2mat(data.(x)(1:6)))])

end