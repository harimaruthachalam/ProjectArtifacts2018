function Main
% Updated on Oct 12, 2018
% I will update the help once the code is complete

close all;
clear;
clc;

trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Data/';
testPath = trainPath;


[trainData, trainLabel, testData, testLabel] = extractDataFiles(trainPath, testPath, 1);

count = 0;
resEYST = cell(length(testData), 1);
parfor iter = 1 : length(testData)
    resEYST{iter} = dtwWrapper(trainData, trainLabel, testData{iter}, 'soft', 10);
    if strcmp(resEYST{iter}(1,:),testLabel(iter,:))
        count = count + 1;
    end
end
disp('count')
count
disp('tot')
length(testData)
end