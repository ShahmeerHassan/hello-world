function data = fnPlottDiff(data)

    % t=d/v

reflap = 3;

data = addvars(data,cell(6,1),'After',"FWF", 'NewVariableNames','tDiff');

for i=1:6
    % time(now) - sLap(now)->sLap(ref)->time(ref)
    
    timenow = data.t{i};
    timeref = data.t{reflap};

    sLapnow = data.sLap{i};
    % sLapref = data.sLap{reflap};
    
    % initialise tDiff
    tDiff = zeros(length(timenow), 1);
    for j=1:min([length(timenow), length(timeref)])
        tDiff(j) = timenow(j) - interp1(data.sLap{reflap}, data.t{reflap}, sLapnow(j));
    end
    
    data.tDiff{i} = tDiff;

end
    
tab11 = uitab('title', 'tDiff');
axes(tab11)

colors = [0 0 1; 0 0.5 1; 0 1 1; 1 0 0; 0.5 0 0; 1 0.5 0];
% colors = [0 0 1; 0 0 1; 0 0 1; 1 0 0; 1 0 0; 1 0 0];
linestyles = {"-", "-", "-", "-", "-", "-"};

hold on

yyaxis left
for i=1:6
    plot(data.sLap{i}, data.vCar{i}, color=colors(i,:), Marker='none', LineStyle=linestyles{i}, DisplayName="Lap "+num2str(i)+" vCar")
end
ylabel('vCar (kph)')
ylim([-20 320])

yyaxis right
for i=1:6
    plot(data.sLap{i}, data.tDiff{i}, color=colors(i,:), Marker='none', LineStyle=linestyles{i}, DisplayName="Lap "+num2str(i)+" tDiff")
end
ylabel('Time Difference (s)')
ylim([-0.5 0.8])

legend()
xlim([min(cell2mat(data.sLap(1:6))) max(cell2mat(data.sLap(1:6)))])

xlabel('Time (s)')

end