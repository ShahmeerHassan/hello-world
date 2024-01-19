function fnPlotDeltas(math)

% intialise plot
tab30 = uitab('title', 'AeroCoefDeltas');
axes(tab30)
hold on

for ln=1:length(math.LapNames)
    for cn = 1:length(math.ConfigNames)
        
        % Select colour of data point
        if str2num(math.LapNames{ln}(end)) <=3
            pointcolor = [0 0 1];
        else
            pointcolor = [1 0 0 ];
        end

        % Identify yaw
        yaw = math.ConfigNames{cn}(end-1:end);
        if contains(yaw, 'n')
            yaw = strrep(yaw, 'n', '-');
        end
        if contains(yaw, '_')
            yaw = yaw(2:end);
        end
        yaw = str2num(yaw);

        try
            delta = math.(math.LapNames{ln}).(math.ConfigNames{cn}).AeroCoefDelta;
            scatter(yaw, delta, "x", 'MarkerEdgeColor', pointcolor, 'DisplayName', strcat(math.LapNames{ln},'_',math.ConfigNames{cn}))
        catch
        end
    end
end

title('Delta to WT vs Yaw Angle (Blue = OpA, Red = OpB)')
xlabel('Yaw Angle (deg)')
ylabel('Delta to WT')

end