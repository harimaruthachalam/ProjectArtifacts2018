function retLabel = dtwWrapper(dtw, refData, refLabel, testData, DTWType, toTransform, savePath, topC, applyVAD, thresholdSTD)
% Updated on Feb 22, 2019
% I will update the help once the code is complete


% send the data to compare with all refdata and check the TopC lowest. return
% the highest occurance.


dtwDist = [];
for iter = 1 : length(refLabel)
    if applyVAD == 2
        [lowerRef, upperRef] = findThresholdLimit(refData{iter}, refLabel(iter,:), thresholdSTD);
        [lowerTest, upperTest] = findThresholdLimit(testData, refLabel(iter,:), thresholdSTD);
    else
        lowerRef = 1; upperRef = length(refData{iter});
        lowerTest = 1; upperTest = length(testData);
    end
    
    %     if DTWType == 'soft'
    %         R = SoftDTW(refData{iter}, testData, 1);
    %     else
    %         R = HardDTW(refData{iter}, testData);
    %     end
    
    if dtw == 2
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
    else
        tRef =  refData{iter}(:,lowerRef:upperRef);
        tTest = testData(:,lowerTest:upperTest);
    end
    if toTransform == true
        tempRef = filterTransform(tRef, refLabel(iter,:));
        tempTest = filterTransform(tTest, refLabel(iter,:));
        R = HardDTW(tempRef, tempTest);
    else
        R = HardDTW(tRef, tTest);
    end
    dtwDist = [dtwDist; R(end:end)];
end


[dtwDistSorted, index] = sort(dtwDist);

if ~isempty(savePath)
    if applyVAD == 2
        [lowerRef, upperRef] = findThresholdLimit(refData{index(1)}, refLabel(index(1),:), thresholdSTD);
        [lowerTest, upperTest] = findThresholdLimit(testData, refLabel(index(1),:), thresholdSTD);
    else
        lowerRef = 1; upperRef = length(refData{index(1)});
        lowerTest = 1; upperTest = length(testData);
    end
    % if DTWType == 'soft'
    %     R = SoftDTW(refData{index(1)}, testData, 1);
    % else
    %     R = HardDTW(refData{index(1)}, testData);
    % end
    if toTransform == true
        tempRef = filterTransform(refData{index(1)}(:,lowerRef:upperRef), refLabel(index(1),:));
        tempTest = filterTransform(testData(:,lowerTest:upperTest), refLabel(index(1),:));
        R = HardDTW(tempRef, tempTest);
    else
        R = HardDTW(refData{index(1)}(:,lowerRef:upperRef), testData(:,lowerTest:upperTest));
    end
    imagesc(R);
    colorbar;
    xlabel('Test Sequence (In samples)');
    ylabel('Reference Sequence (In samples)');
    mkdir(strcat(fullfile(savePath, DTWType), '/', refLabel(index(1),:)));
    milliSec = datestr(clock,'mm_dd_HH_MM_SS_FFF');
    
    %savefig(strcat(fullfile(savePath, DTWType, refLabel(index(1),:)), '/', milliSec,'.fig'));
    saveas(gcf,strcat(fullfile(savePath, DTWType, refLabel(index(1),:)), '/', milliSec,'.png'));
    close;
end

retLabel = refLabel(index(1 : topC),:);

end