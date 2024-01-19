function dataout = fnOrganiseData(data)
% take data and organise into table of laps
%  channel channel channel
%1
%2
%3

% find local minima of time to find lap starts
Laps = sort(unique(data.NLap));
NLaps = length(Laps);

% get channel names
channels = data.Properties.VariableNames;

% Initialise dataout table
sz = [NLaps, length(channels)];
dataout = cell(sz);

% Populate dataout table
for i=1:NLaps
    for j = 1:length(channels)
        dataout{i,j} = table2array(data(data.NLap==Laps(i),j));
    end
end
dataout = cell2table(dataout, 'VariableNames',channels);

% Laps = sort(unique(data.NLap));
% for i=1:length(Laps)
%     dataout.NLap{i} = Laps(i);
% end

end