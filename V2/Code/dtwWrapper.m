function retLabel = dtwWrapper(dtw, refData, refLabel, testData, topC, muValueInThreshold)
% Updated on Feb 6, 2019
% I will update the help once the code is complete


% send the data to compare with all refdata and check the TopC lowest. return
% the highest occurance.


dtwDist = [];
for iter = 1 : length(refLabel)
    [lowerRef, upperRef] = findThresholdLimit(refData{iter}, muValueInThreshold);
    [lowerTest, upperTest] = findThresholdLimit(testData, muValueInThreshold);
    
    tRef =  refData{iter}(:,lowerRef:upperRef);
    tTest = testData(:,lowerTest:upperTest);
    if dtw == 'T'
        [R, ~] = DTW(tRef, tTest, true);
    elseif dtw == 'N'
        [R, k] = DTW(tRef, tTest, false);
        R = R ./ k;
    elseif dtw == 'B'
        [R, k] = DTW(tRef, tTest, true);
        R = R ./ k;
    else
        [R, ~] = DTW(tRef, tTest, false);
    end
    
end
dtwDist = [dtwDist; R(end:end)];


[~, index] = sort(dtwDist);

retLabel = refLabel(index(1 : topC),:);

end