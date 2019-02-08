function Main(varargin)
% Updated on Feb 8, 2019
% I will update the help once the code is complete

close all;
clc;

%% Set the hyperparameters

if nargin == 10
    trainPath = varargin{1};
    testPath = varargin{2};
    classifier = varargin{3}; % 1 - DTW; 2 - LTW;
    dtwType = varargin{4}; % S - Simple; T - Time Sync; N - Normalized; B - Both;
    dataFromPool = varargin{5};
    feature = varargin{6}; % S or M
    topC = varargin{7};
    trainPercent = varargin{8};
    thresholdC = varargin{9};
    thresholdD = varargin{10};
elseif nargin == 0
    trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Train/';
    testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
    classifier = 1; % 1 - DTW; 2 - LTW;
    dtwType = 'S'; % S - Simple; T - Time Sync; N - Normalized; B - Both;
    dataFromPool = 1;
    feature = 'M'; % S or M
    topC = 1;
    trainPercent = 50;
    thresholdC = -0.8;
    thresholdD = -0.8;
else
    error('Invalid Args count');
    return;
end

%% Extract the train and test data

[trainData, trainLabel, testData, testLabel] = extractDataFiles(trainPath, testPath);

%% Detection

correct = 0;
predicted = 0;
total = 0;

count = 0;
classEYST = 0;
classHNST = 0;
classHTST = 0;
classMOST = 0;
classEYST_gt = 0;
classHNST_gt = 0;
classHTST_gt = 0;
classMOST_gt = 0;

for iter = 1 : length(testData)
    
    disp(['Processing test file: ',num2str(iter),' of ',num2str(length(testData))]);
    logger(['Processing test file: ',num2str(iter),' of ',num2str(length(testData))]);
    flagArray = findThresholdExceed(testData{iter}, thresholdD);
    
    [flagArrayGround, ~, ~] = findArrayGroundTruth(testLabel{iter}, '', '');
    
    [chuncks, startIndex, endIndex] = getChuncksFromArray(testData{iter}, flagArray);
    predicted = predicted + length(chuncks);
    
    chunkLabels = char(zeros(length(chuncks),4));
    
    parfor iterChuncks = 1 : length(chuncks)
        disp(['Processing chunck: ',num2str(iterChuncks),' of ',num2str(length(chuncks))]);
        result = presentInWindow(startIndex(iterChuncks), endIndex(iterChuncks), flagArrayGround) && length(getLabelInTheWindow(startIndex(iterChuncks), endIndex(iterChuncks), testLabel{iter})) == 4;
        
        if result == true
            chunkLabels(iterChuncks, :) = getLabelInTheWindow(startIndex(iterChuncks), endIndex(iterChuncks), testLabel{iter});
            correct = correct + result;
            if strcmp(chunkLabels(iterChuncks, :), "EYST")
                classEYST_gt = classEYST_gt + 1;
            elseif strcmp(chunkLabels(iterChuncks, :), "HNST")
                classHNST_gt = classHNST_gt + 1;
            elseif strcmp(chunkLabels(iterChuncks, :), "HTST")
                classHTST_gt = classHTST_gt + 1;
            elseif strcmp(chunkLabels(iterChuncks, :), "MOST")
                classMOST_gt = classMOST_gt + 1;
            end
            
            indexes = max(startIndex(iterChuncks) - 250, 1):min(endIndex(iterChuncks) + 250, length(flagArray));
            if classifier == 1
                resultLabel = dtwWrapper(dtwType, trainData, trainLabel, testData{iter}(:,indexes), topC, thresholdC);
            elseif classifier == 2
                resultLabel = ltwWrapper(trainData, trainLabel, testData{iter}(:,indexes), topC, thresholdC);
            end
            [uniqueStrings, ~, stringMap] = unique(string(resultLabel(1 : topC,:)));
            mostCommonString = uniqueStrings(mode(stringMap));
            if strcmp(mostCommonString, chunkLabels(iterChuncks, :))
                count = count + 1;
                if strcmp(mostCommonString, "EYST")
                    classEYST = classEYST + 1;
                elseif strcmp(mostCommonString, "HNST")
                    classHNST = classHNST + 1;
                elseif strcmp(mostCommonString, "HTST")
                    classHTST = classHTST + 1;
                elseif strcmp(mostCommonString, "MOST")
                    classMOST = classMOST + 1;
                end
            else
                % Will modify soon
                logger([char(chunkLabels(iterChuncks, :)) ' predicted as ' char(mostCommonString)]);
                disp([char(chunkLabels(iterChuncks, :)) ' predicted as ' char(mostCommonString)]);
            end
        end
    end
    [chuncks, ~, ~] = getChuncksFromArray(testData{iter}, flagArrayGround);
    total = total + length(chuncks);
end


disp('count')
count
logger(['Total Accuracy ' count/length(correct) * 100 ' ' [num2str(count),'/',num2str(correct)]]);
disp('total Accuracy')
disp(count/correct * 100)
disp([num2str(count),'/',num2str(length(correct))])
logger(['Eye TP Rate ' classEYST/(classEYST_gt) * 100 ' ' [num2str(classEYST),'/',num2str(classEYST_gt)]]);
disp('Eye TP Rate')
disp(classEYST/(classEYST_gt) * 100)
disp([num2str(classEYST),'/',num2str(classEYST_gt)])
logger(['HN TP Rate ' classHNST/(classHNST_gt) * 100 ' ' [num2str(classHNST),'/',num2str(classHNST_gt)]]);
disp('HN Accuracy')
disp(classHNST/(classHNST_gt) * 100)
disp([num2str(classHNST),'/',num2str(classHNST_gt)])
logger(['HT TP Rate ' classHTST/(classHTST_gt) * 100 ' ' [num2str(classHTST),'/',num2str(classHTST_gt)]]);
disp('HT Accuracy')
disp(classHTST/(classHTST_gt) * 100)
disp([num2str(classHTST),'/',num2str(classHTST_gt)])
logger(['MO TP Rate ' classMOST/(classMOST_gt) * 100 ' ' [num2str(classMOST),'/',num2str(classMOST_gt)]]);
disp('MOST')
disp(classMOST/(classMOST_gt) * 100)
disp([num2str(classMOST),'/',num2str(classMOST_gt)])

end