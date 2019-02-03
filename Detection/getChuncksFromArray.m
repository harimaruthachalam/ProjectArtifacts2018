function [chuncks, startIndex, endIndex] = getChuncksFromArray(data, flagArray)
% Updated on Feb 4, 2019
% I will update soon

chuncks = {};
startIndex = [];
endIndex = [];

index = 1;

while index <= length(flagArray)
    if flagArray(index) > 0.5
        start = index;
        while length(flagArray) > index && flagArray(index) > 0.5
            index = index + 1;
        end
        if (index - start) > 100
            startIndex = [startIndex; max(start - 50, 1)];
            endIndex = [endIndex; min(index + 50, length(flagArray))];
            chuncks{size(chuncks,2) + 1} = data(:, max(start - 50, 1) : min(index + 50, length(flagArray)));
        end
    end
    index = index + 1;
end

end