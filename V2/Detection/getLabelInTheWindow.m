function [label] = getLabelInTheWindow(startIndex, endIndex, testLabel)
% Updated in Feb 8, 2019
% I will update soon

label = '';

for iter = 1 : size(testLabel, 2)
    if contains(testLabel(iter).type,'ST')
        sIndex = testLabel(iter).latency;
        if contains(testLabel(iter + 1).type, 'ED')
            eIndex = testLabel(iter + 1).latency;
        else
            eIndex = testLabel(iter + 2).latency;
        end
        flagArrayIter = zeros(1, max(eIndex, endIndex));
        flagArrayIter(sIndex : eIndex) = 1;
        if presentInWindow(startIndex, endIndex, flagArrayIter) == true
            label = testLabel(iter).type;
            return ;
        end
    end
end
end