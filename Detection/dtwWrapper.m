function retLabel = dtwWrapper(refData, refLabel, testData, topC)
% Updated on Feb 1, 2019
% I will update the help once the code is complete


% send the data to compare with all refdata and check the TopC lowest. return
% the highest occurance.


dtwDist = [];
for iter = 1 : length(refLabel)
    tRef =  refData{iter};
    tTest = testData;
    R = HardDTW(tRef, tTest);
    dtwDist = [dtwDist; R(end:end)];
end


[dtwDistSorted, index] = sort(dtwDist);
retLabel = refLabel(index(1 : topC),:);

end