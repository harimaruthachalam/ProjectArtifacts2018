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
    thresholdClassWise = -1;
    thresholdSTD = -0.8;
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
    
    for iterChuncks = 1 : length(chuncks)
        disp(['Processing chunck: ',num2str(iterChuncks),' of ',num2str(length(chuncks)), 'in EYST']);
        
        predictedEYST = predictedEYST + 1;
        if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundEYST)
            correctEYST = correctEYST + 1;
        end
        
        
        result = dtwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "EYST")
            predictedEYSTd = predictedEYSTd + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundEYST)
                correctEYSTd = correctEYSTd + 1;
            end
        end
        
        result = ltwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC, thresholdSTD);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "EYST")
            predictedEYSTl = predictedEYSTl + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundEYST)
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
        if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundMOST)
            correctMOST = correctMOST + 1;
        end
        
        
        result = dtwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "MOST")
            predictedMOSTd = predictedMOSTd + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundMOST)
                correctMOSTd = correctMOSTd + 1;
            end
        end
        
        result = ltwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC, thresholdSTD);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "MOST")
            predictedMOSTl = predictedMOSTl + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundMOST)
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
        if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundNHST)
            correctNHST = correctNHST + 1;
        end
        
        
        result = dtwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "HNST")
            predictedNHSTd = predictedNHSTd + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundNHST)
                correctNHSTd = correctNHSTd + 1;
            end
        end
        
        result = ltwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC, thresholdSTD);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "HNST")
            predictedNHSTl = predictedNHSTl + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundNHST)
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
        if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundHTST)
            correctHTST = correctHTST + 1;
        end
        
        
        result = dtwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "HTST")
            predictedHTSTd = predictedHTSTd + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundHTST)
                correctHTSTd = correctHTSTd + 1;
            end
        end
        
        result = ltwWrapper(trainData, trainLabel, chuncks{iterChuncks}, topC, thresholdSTD);
        [uniqueStrings, ~, stringMap] = unique(string(result(1 : topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, "HTST")
            predictedHTSTl = predictedHTSTl + 1;
            if presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGroundHTST)
                correctHTSTl = correctHTSTl + 1;
            end
        end
    end
end

logger(strcat('EYST Pred: ', string(predictedEYST)));
logger(strcat('EYST Corr: ', string(correctEYST)));
logger(strcat('MOST Pred: ', string(predictedMOST)));
logger(strcat('MOST Corr: ', string(correctMOST)));
logger(strcat('NHST Pred: ', string(predictedNHST)));
logger(strcat('NHST Corr: ', string(correctNHST)));
logger(strcat('NTST Pred: ', string(predictedHTST)));
logger(strcat('NTST Corr: ', string(correctHTST)));

logger(strcat('EYST DTW Pred: ', string(predictedEYSTd)));
logger(strcat('EYST DTW Corr: ', string(correctEYSTd)));
logger(strcat('MOST DTW Pred: ', string(predictedMOSTd)));
logger(strcat('MOST DTW Corr: ', string(correctMOSTd)));
logger(strcat('NHST DTW Pred: ', string(predictedNHSTd)));
logger(strcat('NHST DTW Corr: ', string(correctNHSTd)));
logger(strcat('NTST DTW Pred: ', string(predictedHTSTd)));
logger(strcat('NTST DTW Corr: ', string(correctHTSTd)));

logger(strcat('EYST LTW Pred: ', string(predictedEYSTl)));
logger(strcat('EYST LTW Corr: ', string(correctEYSTl)));
logger(strcat('MOST LTW Pred: ', string(predictedMOSTl)));
logger(strcat('MOST LTW Corr: ', string(correctMOSTl)));
logger(strcat('NHST LTW Pred: ', string(predictedNHSTl)));
logger(strcat('NHST LTW Corr: ', string(correctNHSTl)));
logger(strcat('NTST LTW Pred: ', string(predictedHTSTl)));
logger(strcat('NTST LTW Corr: ', string(correctHTSTl)));

end