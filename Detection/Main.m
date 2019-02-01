function Main(varargin)
% Updated on Feb 1, 2019
% I will update the help once the code is complete

close all;
clc;

%% Set the hyperparameters

trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Train/';
testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
seed = 123;

if nargin == 4
    feature = varargin{1}; % S or M or D of DM
    topC = varargin{2};
    thresholdClassWise = varargin{3};
    thresholdSTD = varargin{4};
elseif nargin == 0
    feature = 'S'; % S or M or D of DM
    topC = 3;
    thresholdClassWise = -0.5;
    thresholdSTD = -0;
else
    error('Invalid Args count');
    return;
end

%% Extract the train and test data

[trainData, trainLabel, testData, testLabel] = extractDataFiles(trainPath, testPath);
thresholdEYST = fetchClassWiseThreshold(trainData, trainLabel, thresholdClassWise, 'EYST');
thresholdMOST = fetchClassWiseThreshold(trainData, trainLabel, thresholdClassWise, 'MOST');
thresholdHNST = fetchClassWiseThreshold(trainData, trainLabel, thresholdClassWise, 'HNST');
thresholdHTST = fetchClassWiseThreshold(trainData, trainLabel, thresholdClassWise, 'HTST');

%% Detection

predictedEYST = 0;
correctEYST = 0;
predictedMOST = 0;
correctMOST = 0;
predictedNHST = 0;
correctNHST = 0;
predictedHTST = 0;
correctHTST = 0;

predictedEYSTd = 0;
correctEYSTd = 0;
predictedMOSTd = 0;
correctMOSTd = 0;
predictedNHSTd = 0;
correctNHSTd = 0;
predictedHTSTd = 0;
correctHTSTd = 0;

predictedEYSTl = 0;
correctEYSTl = 0;
predictedMOSTl = 0;
correctMOSTl = 0;
predictedNHSTl = 0;
correctNHSTl = 0;
predictedHTSTl = 0;
correctHTSTl = 0;

for iter = 1 : length(testData)
    
    disp(['Processing test file: ',num2str(iter),' of ',num2str(length(testData))]);
    flagArrayEYST = findThresholdExceed(testData{iter}, 'EYST', thresholdEYST);
    [flagArrayGroundEYST, startIndexGroundEYST, endIndexGroundEYST] = findArrayGroundTruth(testLabel{iter}, 'EYST', 'EYED');
    bothEYST = sum(flagArrayEYST .* flagArrayGroundEYST');
    
    [chuncks, startIndex, endIndex] = getChuncksFromArray(testData{iter}, flagArrayEYST);
    
    parfor iterChuncks = 1 : length(chuncks)
        disp(['Processing chunck: ',num2str(iterChuncks),' of ',num2str(length(chuncks)), 'in EYST']);
        
        predictedEYST = predictedEYST + 1;
        if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
            correctEYST = correctEYST + 1;
        end
        
        
        result = dtwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "EYST")
            predictedEYSTd = predictedEYSTd + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
                correctEYSTd = correctEYSTd + 1;
            end
        end
        
        result = ltwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC, thresholdSTD);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "EYST")
            predictedEYSTl = predictedEYSTl + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
                correctEYSTl = correctEYSTl + 1;
            end
        end
    end
    
    flagArrayMOST = findThresholdExceed(testData{iter}, 'MOST', thresholdMOST);
    [flagArrayGroundMOST, startIndexGroundMOST, endIndexGroundMOST] = findArrayGroundTruth(testLabel{iter}, 'MOST', 'MOED');
    bothMOST = sum(flagArrayMOST .* flagArrayGroundMOST');
    
    [chuncks, startIndex, endIndex] = getChuncksFromArray(testData{iter}, flagArrayMOST);
        
    parfor iterChuncks = 1 : length(chuncks)
        disp(['Processing chunck: ',num2str(iterChuncks),' of ',num2str(length(chuncks)), 'in MOST']);
        
        predictedMOST = predictedMOST + 1;
        if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
            correctMOST = correctMOST + 1;
        end
        
        
        result = dtwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "MOST")
            predictedMOSTd = predictedMOSTd + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
                correctMOSTd = correctMOSTd + 1;
            end
        end
        
        result = ltwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC, thresholdSTD);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "MOST")
            predictedMOSTl = predictedMOSTl + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
                correctMOSTl = correctMOSTl + 1;
            end
        end
    end
    
    flagArrayNHST = findThresholdExceed(testData{iter}, 'HNST', thresholdHNST);
    [flagArrayGroundNHST, startIndexGroundNHST, endIndexGroundNHST] = findArrayGroundTruth(testLabel{iter}, 'HNST', 'NHED');
    bothNHST = sum(flagArrayNHST .* flagArrayGroundNHST');
    
    [chuncks, startIndex, endIndex] = getChuncksFromArray(testData{iter}, flagArrayNHST);
    
    parfor iterChuncks = 1 : length(chuncks)
        disp(['Processing chunck: ',num2str(iterChuncks),' of ',num2str(length(chuncks)), 'in HNST']);
        
        predictedNHST = predictedNHST + 1;
        if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
            correctNHST = correctNHST + 1;
        end
        
        
        result = dtwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "HNST")
            predictedNHSTd = predictedNHSTd + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
                correctNHSTd = correctNHSTd + 1;
            end
        end
        
        result = ltwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC, thresholdSTD);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "HNST")
            predictedNHSTl = predictedNHSTl + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
                correctNHSTl = correctNHSTl + 1;
            end
        end
    end
    
    flagArrayHTST = findThresholdExceed(testData{iter}, 'HTST', thresholdHTST);
    [flagArrayGroundHTST, startIndexGroundHTST, endIndexGroundHTST] = findArrayGroundTruth(testLabel{iter}, 'HTST', 'HTED');
    bothHTST = sum(flagArrayHTST .* flagArrayGroundHTST');
    
    [chuncks, startIndex, endIndex] = getChuncksFromArray(testData{iter}, flagArrayHTST);
    
    parfor iterChuncks = 1 : length(chuncks)
        disp(['Processing chunck: ',num2str(iterChuncks),' of ',num2str(length(chuncks)), 'in HTST']);
        
        predictedHTST = predictedHTST + 1;
        if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
            correctHTST = correctHTST + 1;
        end
        
        
        result = dtwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "HTST")
            predictedHTSTd = predictedHTSTd + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
                correctHTSTd = correctHTSTd + 1;
            end
        end
        
        result = ltwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC, thresholdSTD);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "HTST")
            predictedHTSTl = predictedHTSTl + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), startIndexGroundEYST, endIndexGroundEYST)
                correctHTSTl = correctHTSTl + 1;
            end
        end
    end
end

logger(stcat('EYST Pred: ', string(predictedEYST)));
logger(stcat('EYST Corr: ', string(correctEYST)));
logger(stcat('MOST Pred: ', string(predictedMOST)));
logger(stcat('MOST Corr: ', string(correctMOST)));
logger(stcat('NHST Pred: ', string(predictedHNST)));
logger(stcat('NHST Corr: ', string(correctNHST)));
logger(stcat('NTST Pred: ', string(predictedHTST)));
logger(stcat('NTST Corr: ', string(correctHTST)));

logger(stcat('EYST DTW Pred: ', string(predictedEYSTd)));
logger(stcat('EYST DTW Corr: ', string(correctEYSTd)));
logger(stcat('MOST DTW Pred: ', string(predictedMOSTd)));
logger(stcat('MOST DTW Corr: ', string(correctMOSTd)));
logger(stcat('NHST DTW Pred: ', string(predictedNHSTd)));
logger(stcat('NHST DTW Corr: ', string(correctNHSTd)));
logger(stcat('NTST DTW Pred: ', string(predictedHTSTd)));
logger(stcat('NTST DTW Corr: ', string(correctHTSTd)));

logger(stcat('EYST LTW Pred: ', string(predictedEYSTl)));
logger(stcat('EYST LTW Corr: ', string(correctEYSTl)));
logger(stcat('MOST LTW Pred: ', string(predictedMOSTl)));
logger(stcat('MOST LTW Corr: ', string(correctMOSTl)));
logger(stcat('NHST LTW Pred: ', string(predictedNHSTl)));
logger(stcat('NHST LTW Corr: ', string(correctNHSTl)));
logger(stcat('NTST LTW Pred: ', string(predictedHTSTl)));
logger(stcat('NTST LTW Corr: ', string(correctHTSTl)));

end