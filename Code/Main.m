function Main
% Updated on Oct 17, 2018
% I will update the help once the code is complete

close all;
clear;
clc;

trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Data/';
savePath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Plots/';
testPath = trainPath;
knn = 0;
svm = 0;
dtw = 1;
applyVAD = 1;
dataFromPool = 1;

[trainData, trainLabel, testData, testLabel] = extractDataFiles(trainPath, testPath, dataFromPool, applyVAD);

if dtw == 1
    
    count = 0;
    result = cell(length(testData), 1);
    parfor iter = 1 : length(testData)
        result{iter} = dtwWrapper(trainData, trainLabel, testData{iter}, 'soft', savePath, 10);
        if strcmp(result{iter}(1,:),testLabel(iter,:))
            count = count + 1;
        end
    end
    disp('count')
    count
    disp('total')
    length(testData)
    
elseif knn == 1
    
    count = 0;
    result = cell(length(testData), 1);
    parfor iter = 1 : length(testData)
        result{iter} = knnWrapper(trainData, trainLabel, testData{iter}, 10);
        if strcmp(result{iter}(1,:),testLabel(iter,:))
            count = count + 1;
        end
    end
    disp('count')
    count
    disp('total')
    length(testData)
end
end