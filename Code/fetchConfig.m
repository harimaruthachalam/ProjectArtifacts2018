function [value] = fetchConfig(inconfig, variableName, defaultValue, datatype)
% Updated on Aug 4, 2018
% I will update the help once the code is complete

value = defaultValue;
for i = 1 : size(inconfig{1},1)
    if strcmpi(string(cell2mat(inconfig{1}(i))), variableName)
        value = string(cell2mat(inconfig{2}(i)));
    end
end
switch lower(datatype)
    case 'int'
        value = str2double(value);
    case 'double'
        value = str2double(value);
    case 'char'
        value = char(value);
end
end