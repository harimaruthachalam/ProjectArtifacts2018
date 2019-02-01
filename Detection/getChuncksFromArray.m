function [chuncks, startIndex, endIndex] = getChuncksFromArray(data, flagArray)
% Updated on Feb 1, 2019
% I will update soon

chuncks = {};
startIndex = [];
endIndex = [];

for index = 1 : length(flagArray) 
    if flagArray(index) == 1
        start = index;
        startIndex = [startIndex; index];
        while length(flagArray) > index && flagArray(index) == 1
            index = index + 1;
        end
        endIndex = [endIndex; index];
        chuncks{size(chuncks,2) + 1} = data(:, start:index);
    end
end

end