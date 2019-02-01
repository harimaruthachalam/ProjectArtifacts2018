function retLabel = ltwWrapper(refData, refLabel, testData, topC, thresholdSTD)
% Updated on Feb 1, 2019
% I will update the help once the code is complete


% send the data to compare with all refdata and check the TopC lowest. return
% the highest occurance.


dtwDist = [];
for iter = 1 : length(refLabel)
        [lowerRef, upperRef] = findThresholdLimit(refData{iter}, refLabel(iter,:), thresholdSTD);
        maxLength =  max((upperRef - lowerRef + 1), size(testData,2));
        tRef = zeros(128, maxLength);
        tTest = zeros(128, maxLength);
        for i = 1 : 128
            refLin = 1 : (upperRef - lowerRef + 1);
            refInterpLin = linspace(1, numel(refLin), maxLength);
            tesLin = 1 : size(testData,2);
            tesInterpLin = linspace(1, numel(tesLin), maxLength);
            tRef(i, :) = interp1(refLin, refData{iter}(i,lowerRef:upperRef), refInterpLin, 'spline');
            tTest(i, :) = interp1(tesLin, testData(i,:), tesInterpLin, 'spline');
        end
    dtwDist = [dtwDist; norm(tRef - tTest)];
end


[dtwDistSorted, index] = sort(dtwDist);

retLabel = refLabel(index(1 : topC),:);

end