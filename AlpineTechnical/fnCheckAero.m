function [data, math] = fnCheckAero(data, math, laps, FRY, delta)

% laps = [2 3 5 6];
Frh = FRY(1);
Rrh = FRY(2);
Yaw = FRY(3);

% ride height tolerance
tolrh = 2;
% yaw tolerance
tolyaw = 0.5;

% data = addvars(data,cell(6,1),'After',"YawFilt", 'NewVariableNames','A_20_120_0');

sz = [length(laps), 4];
T = cell(sz);

math.LapNames = {};

for i=1:length(laps)
    aa = data.FrhFilt{laps(i)} >= Frh-tolrh;
    ab = data.FrhFilt{laps(i)} <= Frh+tolrh;
    a = aa & ab;

    ba = data.RrhFilt{laps(i)} >= Rrh-tolrh;
    bb = data.RrhFilt{laps(i)} <= Rrh+tolrh;
    b = ba & bb;

    ca = data.YawFilt{laps(i)} >= Yaw-tolyaw;
    cb = data.YawFilt{laps(i)} <= Yaw+tolyaw;
    c = ca & cb;
    
    x = a & b & c;

    % data.A_20_120_0{i} = NaN(length(data.t), 0);
    % Get Lap Name
    LapName = strcat('L',num2str(laps(i)));

    if laps(i)<=3
        configName = strcat('A_',num2str(Frh),'_',num2str(Rrh),'_',num2str(Yaw));
    else
        configName = strcat('B_',num2str(Frh),'_',num2str(Rrh),'_',num2str(Yaw));
    end

    if contains(configName, '-')
        configName = strrep(configName, '-', 'n');
    end

    math.LapNames{end+1} = LapName;
    math.ConfigNames{end+1} = configName;

    % Save valid data points 
    math.(LapName).(configName).AeroCoefData = data.AeroCoefFilt{laps(i)}(x==1);
    
    % Compute Average
    math.(LapName).(configName).AeroCoef = mean(math.(LapName).(configName).AeroCoefData);

    % Compute delta to WT
    if laps(i)<=3
        deltaref = delta(1);
    else
        deltaref = delta(2);
    end
    math.(LapName).(configName).AeroCoefDelta = deltaref - math.(LapName).(configName).AeroCoef;

    % xyz=[data.FrhFilt{i}, data.RrhFilt{i}, data.YawFilt{i}];  %x, y, z, data
    % w=data.AeroCoef{i};        % truth of data
    % % F=vecnorm(xyz.*w,2,2); %fake dependent data
    % x0 = [20 120 0 -2.102];
    % wfit=lsqcurvefit(@modelFcn,x0, xyz,w);

    T{laps(i),1} = laps(i);
    T{laps(i),2} = length(math.(LapName).(configName).AeroCoefData);
    T{laps(i),3} = math.(LapName).(configName).AeroCoef;
    T{laps(i),4} = math.(LapName).(configName).AeroCoefDelta;
end

T = cell2table(T, 'VariableNames',{'Lap', 'nSamples', 'mean', 'DeltaToWT'});
filename = strcat(configName,'.csv');
writetable(T, filename);

end