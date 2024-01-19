function QvsX(sims, loggedData, varname)

% Define
lw = 2; % line width

simnames = fieldnames(sims);

% Get colours for plotting
numColours = length(simnames);
% Get RGB values from the parula colormap
rainbowColors = hsv(numColours);
% Convert RGB values to cell array of double arrays
colours = num2cell(rainbowColors, 2);

gear = {'pinion', 'wheel'};
regions = {'flank', 'root'};
for g = 1:2
    
    for q = 1:length(loggedData)
        if ~strcmp(loggedData{q}, 'MaxInPlanePrincipalAbs')
            % Determine whether x is flank or root
            if strcmp(loggedData{q}, 'CPRESS')
                xvar = 'xflank';
            elseif strcmp(loggedData{q}, 'MISES')
                xvar = 'xroot';
            end

            % Create tab in figure
            tabtitle = [loggedData{q}, 'Vs', xvar '_', gear{g}];
            tab = uitab('title', tabtitle, 'BackgroundColor', [1 1 1]);
            axes(tab)
            hold on
    
            for s = 1:length(simnames)
                % Get sim name
                nsim = simnames{s};
    
                % Get x coordinate (flank or root)
                xvals = sims.(nsim).(xvar).(gear{g});
    
                % Get data
                data = sims.(nsim).(loggedData{q}).(gear{g});
                
                % Get max at each x coordinate (flank or root)
                maxes = max(data, [], 2);
                
                dname = [varname,' = ', num2str(round(sims.(nsim).val, 2), '%.2f')];
    
                plot(xvals, maxes, 'color', colours{s}, 'LineWidth', lw, 'DisplayName', dname);
    
            end
            
            xl = xlabel(xvar);
            yl = ylabel(['Max ',loggedData{q}]);
            ttl = title(['Max ', gear{g}, ' ', loggedData{q}, ' vs ', xvar, ' for varying ', varname]);
            lgd = legend('Location', 'eastoutside');
            xl.FontSize=16;
            yl.FontSize=16;
            ttl.FontSize=16;
            lgd.FontSize=16;
        else
            for r = 1:length(regions)
                acronym = upper(loggedData{q}(isstrprop(loggedData{q}, 'upper')));

                % Create tab in figure
                tabtitle = [acronym, 'Vs_x', regions{r} '_', gear{g}];
                tab = uitab('title', tabtitle, 'BackgroundColor', [1 1 1]);
                axes(tab)
                hold on
        
                for s = 1:length(simnames)
                    % Get sim name
                    nsim = simnames{s};
        
                    % Get roll angle
                    xvals = sims.(nsim).(['x',regions{r}]).(gear{g});
        
                    % Get data
                    data = sims.(nsim).(loggedData{q}).(regions{r}).(gear{g});
                    
                    % Get max at each roll angle
                    maxes = max(data, [], 2);
                    
                    dname = [varname,' = ', num2str(round(sims.(nsim).val, 2), '%.2f')];
        
                    plot(xvals, maxes, 'color', colours{s}, 'LineWidth', lw, 'DisplayName', dname);
        
                end
                
                xl = xlabel(regions{r});
                yl = ylabel(['Max ',loggedData{q}]);
                ttl = title(['Max ', gear{g}, ' ', loggedData{q}, ' vs ', regions{r}, ' for varying ', varname]);
                lgd = legend('Location', 'eastoutside');
                xl.FontSize=16;
                yl.FontSize=16;
                ttl.FontSize=16;
                lgd.FontSize=16;
            end

    end

end




end