function fnPlotvCarHeadwind(data, laps)

tab10 = uitab('title', 'vCar and Headwind');
axes(tab10)

colors = [0 0 1; 0 0.5 1; 0 1 1; 1 0 0; 0.5 0 0; 1 0.5 0];


linestyles = {"-", "-", "-", "-", "-", "-"};

hold on

yyaxis left
for i=laps
    plot(data.t{i}, data.vCar{i}, color=colors(i,:), LineStyle=linestyles{i}, DisplayName="Lap "+num2str(i)+" vCar")
end
ylabel('vCar (kph)')
ylim([-20 320])

yyaxis right
for i=laps
    plot(data.t{i}, data.HeadWind{i}, color=colors(i,:), LineStyle=linestyles{i}, DisplayName="Lap "+num2str(i)+" Headwind")
end
ylabel('Windspeed at Pitot (kph)')
ylim([-20 40])

legend()
xlim([min(cell2mat(data.t(1:6))) max(cell2mat(data.t(1:6)))])

xlabel('Time (s)')


end