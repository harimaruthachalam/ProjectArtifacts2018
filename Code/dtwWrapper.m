function retLabel = dtwWrapper(refData, refLabel, testData, DTWType, topC)
% Updated on Oct 12, 2018
% I will update the help once the code is complete


% send the data to compare with all refdata and check the 10 lowest. return
% the highest occurance.

% commandStr = 'python sdtwDist.py';
% [status, commandOut] = system(commandStr);
% if status==0
% fprintf('squared result is %d\n',str2num(commandOut));
% end

dtwDist = [];
for iter = 1 : length(refLabel)
    if DTWType == 'soft'
        dtwDist = [dtwDist; SoftDTW(refData{iter}, testData, 1)];
    else
        dtwDist = [dtwDist; HardDTW(refData{iter}, testData)];
    end
end

[dtwDistSorted, index] = sort(dtwDist);

retLabel = refLabel(index(1 : topC),:);

end