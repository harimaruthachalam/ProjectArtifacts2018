function [trainData, trainLabel, testData, testLabelStruct] = extractDataFilesForPool(path, feature, trainPercent)
% Updated on Feb 8, 2019
% I will update the help once the code is complete

[testData, testLabelStruct] = extractAllDataFiles(path);

testCount = 100/trainPercent;

trainData = {};
trainLabel = [];

for iter = 1 : length(testLabelStruct)
    if feature == 'M'
        tempData = movmean(testData{iter}, 100);
    else
        tempData = testData{iter};
    end
    [~, startIndexEY, endIndexEY] = findArrayGroundTruth(testLabelStruct{iter}, 'EYST', 'EYED');
    [~, startIndexHN, endIndexHN] = findArrayGroundTruth(testLabelStruct{iter}, 'HNST', 'HNED');
    [~, startIndexHT, endIndexHT] = findArrayGroundTruth(testLabelStruct{iter}, 'HTST', 'HTED');
    [~, startIndexMO, endIndexMO] = findArrayGroundTruth(testLabelStruct{iter}, 'MOST', 'MOED');
    
    for iterIndex = 1 : ceil(size(startIndexEY,1)/testCount)
        temp = tempData(:, startIndexEY(iterIndex) : endIndexEY(iterIndex));
        temp = temp - mean(temp,2);
        trainData = [trainData; temp];
    end
    trainLabel = [trainLabel; repmat('EYST', ceil(size(startIndexEY,1)/testCount), 1)];
    
    for iterIndex = 1 : ceil(size(startIndexHN,1)/testCount)
        temp = tempData(:, startIndexHN(iterIndex) : endIndexHN(iterIndex));
        temp = temp - mean(temp,2);
        trainData = [trainData; temp];
    end
    trainLabel = [trainLabel; repmat('HNST', ceil(size(startIndexHN,1)/testCount), 1)];
    
    for iterIndex = 1 : ceil(size(startIndexHT,1)/testCount)
        temp = tempData(:, startIndexHT(iterIndex) : endIndexHT(iterIndex));
        temp = temp - mean(temp,2);
        trainData = [trainData; temp];
    end
    trainLabel = [trainLabel; repmat('HTST', ceil(size(startIndexHT,1)/testCount), 1)];
    
    for iterIndex = 1 : ceil(size(startIndexMO,1)/testCount)
        temp = tempData(:, startIndexMO(iterIndex) : endIndexMO(iterIndex));
        temp = temp - mean(temp,2);
        trainData = [trainData; temp];
    end
    trainLabel = [trainLabel; repmat('MOST', ceil(size(startIndexMO,1)/testCount), 1)];
    
    startIndices = [endIndexMO(ceil(size(startIndexMO,1)/testCount)) endIndexEY(ceil(size(startIndexEY,1)/testCount)) endIndexHN(ceil(size(startIndexHN,1)/testCount)) endIndexHT(ceil(size(startIndexHT,1)/testCount))];
    startIndex = max(startIndices);
    
    testData{iter} = testData{iter}(:, startIndex:end);
    
    for eventIter = 1 : size(testLabelStruct{iter},2)
        testLabelStruct{iter}(eventIter).latency = testLabelStruct{iter}(eventIter).latency - startIndex;
        if testLabelStruct{iter}(eventIter).latency == 0
            startEvent = eventIter;
        end
    end
    testLabelStruct{iter} = testLabelStruct{iter}(startEvent:end);
end
end
