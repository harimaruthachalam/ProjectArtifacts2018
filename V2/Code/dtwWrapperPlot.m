function retLabel = dtwWrapperPlot(dtw, refData, refLabel, testData, topC, muValueInThreshold)
% Updated on Feb 13, 2019
% I will update the help once the code is complete


% send the data to compare with all refdata and check the TopC lowest. return
% the highest occurance.


dtwDist = [];
for iter = 1 : length(refLabel)
    [lowerRef, upperRef] = findThresholdExceedLimits(refData{iter}, muValueInThreshold);
    [lowerTest, upperTest] = findThresholdExceedLimits(testData, muValueInThreshold);
    
    tRef = standardize(refData{iter});
    tTest = standardize(testData);
    
    tRef =  tRef(:,lowerRef:upperRef);
    tTest = tTest(:,lowerTest:upperTest);
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
   
dtwDist = [dtwDist; R(end:end)]; 
end

[~, index] = sort(dtwDist);

retLabel = refLabel(index(1 : topC),:);

savePath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Plot';

if ~isempty(savePath)
    
    [lowerRef, upperRef] = findThresholdExceedLimits(refData{index(1)}, muValueInThreshold);
    [lowerTest, upperTest] = findThresholdExceedLimits(testData, muValueInThreshold);
    
    tRef =  refData{index(1)}(:,lowerRef:upperRef);
    tTest = testData(:,lowerTest:upperTest);
    [R, ~] = DTW(tRef, tTest, false);
    imagesc(R);
    mkdir(strcat(fullfile(savePath), '/', refLabel(index(1),:)));
    milliSec = datestr(clock,'mm_dd_HH_MM_SS_FFF');
    
    savefig(strcat(fullfile(savePath, refLabel(index(1),:)), '/', milliSec,'.fig'));
    saveas(gcf,strcat(fullfile(savePath, refLabel(index(1),:)), '/', milliSec,'.png'));
    close;
end

end