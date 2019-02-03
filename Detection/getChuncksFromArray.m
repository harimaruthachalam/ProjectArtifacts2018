function [chuncks, startIndex, endIndex] = getChuncksFromArray(data, flagArray)
% Updated on Feb 1, 2019
% I will update soon

chuncks = {};
startIndex = [];
endIndex = [];

index = 1;

while index <= length(flagArray)
    if flagArray(index) > 0.5
        start = index;
        startIndex = [startIndex; index];
        while length(flagArray) > index && flagArray(index) > 0.5
            index = index + 1;
        end
        endIndex = [endIndex; index];
        chuncks{size(chuncks,2) + 1} = data(:, start:index);
    end
    index = index + 1;
end

end