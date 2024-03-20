function fnFitCurve(xData, yData, power)
    
    % Fit the curve y = ax^0.5
    p = polyfit(xData.^power, yData, 1);

    % Generate points for the fitted curve
    xFit = linspace(min(xData), max(xData), 1000);
    yFit = p(1) * sqrt(xFit) + p(2);

    % Determine equation
    if p(2)>1
        eqnstring = [num2str(p(1)),'x^{0.5} + ', num2str(p(2))];
    else
        eqnstring = [num2str(p(1)),'x^{0.5} - ', num2str(abs(p(2)))];
    end

    % Plot the fitted curve
    plot(xFit, yFit, 'r-', 'LineWidth', 1.5, 'DisplayName', eqnstring);

end
