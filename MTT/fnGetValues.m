function qvals = fnGetValues(foldernames)

posteq = extractAfter(foldernames, '=');

posteq = strrep(posteq, '-', '.');

% Initialize a cell array to store the numerical parts of the filename
numericalParts = cell(size(posteq));

% Iterate through each string and extract the numerical parts
for i = 1:numel(posteq)
    
    % \d will find digits
    % + will find more of whatever precedes (digits(
    % () group
    % \. looks for decimal point
    % \d* looks for digits but if they exist
    % ? indicates the group is optional
    match = regexp(posteq{i}, '\d+(\.\d*)?', 'match');
    
    if ~isempty(match)
        numericalParts{i} = match{1};
    else
        numericalParts{i} = NaN;
    end
end

% Convert to array
qvals = str2double(numericalParts);

end