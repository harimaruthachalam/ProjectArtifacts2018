function retLabel = ltwWrapper(refData, refLabel, testData, topC, muValueInThreshold)
% Updated on Feb 6, 2019
% I will update the help once the code is complete


% send the data to compare with all refdata and check the TopC lowest. return
% the highest occurance.


dtwDist = [];
for iter = 1 : length(refLabel)
    [lowerRef, upperRef] = findThresholdExceedLimits(refData{iter}, muValueInThreshold);
    [lowerTest, upperTest] = findThresholdExceedLimits(testData, muValueInThreshold);
    maxLength =  max((upperRef - lowerRef + 1), (upperTest - lowerTest + 1));
    tRef = zeros(128, maxLength);
    tTest = zeros(128, maxLength);
    for i = 1 : 128
        refLin = 1 : (upperRef - lowerRef + 1);
        refInterpLin = linspace(1, numel(refLin), maxLength);
        tesLin = 1 : (upperTest - lowerTest + 1);
        tesInterpLin = linspace(1, numel(tesLin), maxLength);
        tRef(i, :) = interp1(refLin, refData{iter}(i,lowerRef:upperRef), refInterpLin, 'spline');
        tTest(i, :) = interp1(tesLin, testData(i,lowerTest:upperTest), tesInterpLin, 'spline');
    end
    dtwDist = [dtwDist; norm(tRef - tTest)];
end


[~, index] = sort(dtwDist);

retLabel = refLabel(index(1 : topC),:);

end