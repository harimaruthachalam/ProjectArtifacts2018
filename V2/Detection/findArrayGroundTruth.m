function [flagArray, startIndex, endIndex] = findArrayGroundTruth(testLabel, classStartEvent, classEndEvent)
% Updated on Feb 1, 2019
% I will update soon

startIndex = [];
endIndex = [];

if isempty(classStartEvent) && isempty(classEndEvent)
    for iter = 1 : size(testLabel, 2)
        if contains(testLabel(iter).type,'ST')
            startIndex = [startIndex; testLabel(iter).latency];
            if contains(testLabel(iter + 1).type, 'ED')
                endIndex = [endIndex; testLabel(iter + 1).latency];
            else
                endIndex = [endIndex; testLabel(iter + 2).latency];
            end
        end
    end
else
    
    for iter = 1 : size(testLabel, 2)
        if strcmp(testLabel(iter).type, classStartEvent)
            startIndex = [startIndex; testLabel(iter).latency];
            if strcmp(testLabel(iter + 1).type, classEndEvent)
                endIndex = [endIndex; testLabel(iter + 1).latency];
            else
                endIndex = [endIndex; testLabel(iter + 2).latency];
            end
        end
    end
end

flagArray = zeros(testLabel(size(testLabel, 2)-1).latency + 1, 1);

for iter = 1 : length(startIndex)
    flagArray(startIndex(iter) : endIndex(iter)) = 1;
end

end