function detectionAccuracy
% Updated on Feb 7, 2019
% I will update soon

close all;
clc;

testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Data/';

[~, ~, testData, testLabel] = extractDataFiles('', testPath);

muValue = -1 : 0.1 : 1.5;

for iterMu = 1 : length(muValue)
    
    correct = 0;
    predicted = 0;
    total = 0;
    
    for iter = 1 : length(testData)
        
        disp(['Processing test file: ',num2str(iter),' of ',num2str(length(testData))]);
        flagArray = findThresholdExceed(testData{iter}, muValue(iterMu));
        
        [chuncks, startIndex, endIndex] = getChuncksFromArray(testData{iter}, flagArray);
        predicted = predicted + length(chuncks);
        
        [flagArrayGround, ~, ~] = findArrayGroundTruth(testLabel{iter}, '', '');
        
        for i = 1 : length(chuncks)
            result = presentInWindow(startIndex(i), endIndex(i), flagArrayGround) && length(getLabelInTheWindow(startIndex(i), endIndex(i), testLabel{iter})) == 4;
            correct = correct + result;
        end
        [chuncks, ~, ~] = getChuncksFromArray(testData{iter}, flagArrayGround);
        total = total + length(chuncks);
    end
    tp = min(correct, total);
    fp = max(predicted - correct, 0);
    fn = max(total - predicted, 0);
    
    precision = tp / (tp + fp);
    recall = tp / (tp + fn);
    F1 = (2 * precision * recall) / (precision + recall);
    logger(['Mu Value: ',num2str(muValue(iterMu)),'; F1 : ',num2str(F1),' Total : ',num2str(total),'; Predicted : ',num2str(predicted),'; Correct : ',num2str(correct)]);
    
end
end