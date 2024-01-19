function fnPlotvCarYaw(data, laps)

tab20 = uitab('title', 'vCar and Yaw');
axes(tab20)

colors = [0 0 1; 0 0.5 1; 0 1 1; 1 0 0; 0.5 0 0; 1 0.5 0];


linestyles = {"-", "-", "-", "-", "-", "-"};

hold on

yyaxis left
for i=1:length(laps)
    plot(data.t{laps(i)}, data.vCar{laps(i)}, color=colors(laps(i),:), Marker='none', LineStyle=linestyles{laps(i)}, DisplayName="Lap "+num2str(laps(i))+" vCar")
end
ylabel('vCar (kph)')
ylim([-20 320])

yyaxis right
for i=1:length(laps)
    plot(data.t{laps(i)}, data.YawFilt{laps(i)}, color=colors(laps(i),:), Marker='none', LineStyle=linestyles{laps(i)}, DisplayName="Lap "+num2str(laps(i))+" Yaw")
end
ylabel('Yaw Angle Filtered (deg)')
ylim([-8 10])

legend()
xlim([min(cell2mat(data.t(1:6))) max(cell2mat(data.t(1:6)))])

xlabel('Time (s)')

end