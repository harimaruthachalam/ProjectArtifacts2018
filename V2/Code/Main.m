function Main(varargin)
% Updated on Feb 6, 2019
% I will update the help once the code is complete

close all;
clc;

if nargin == 10
    trainPath = varargin{1};
    testPath = varargin{2};
    seed = varargin{3};
    classifier = varargin{4}; % 1 - DTW; 2 - LTW;
    dtwType = varargin{5}; % S - Simple; T - Time Sync; N - Normalized; B - Both;
    dataFromPool = varargin{6};
    feature = varargin{7}; % S or M
    topC = varargin{8};
    trainPercent = varargin{9};
    muValueInThreshold = varargin{10};
elseif nargin == 0
    trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Train/';
    testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
    seed = 123;
    classifier = 2; % 1 - DTW; 2 - LTW;
    dtwType = 'B'; % S - Simple; T - Time Sync; N - Normalized; B - Both;
    dataFromPool = 1;
    feature = 'M'; % S or M
    topC = 1;
    trainPercent = 50;
    muValueInThreshold = 0.6;
else
    error('Invalid Args count');
    return;
end

[trainData, trainLabel, testData, testLabel] = extractDataFiles(seed, trainPath, testPath, dataFromPool, feature, trainPercent);

count = 0;
classEYST = 0;
classHNST = 0;
classHTST = 0;
classMOST = 0;
classEYST_gt = 0;
classHNST_gt = 0;
classHTST_gt = 0;
classMOST_gt = 0;
result = cell(length(testData), 1);


parfor iter = 1 : length(testData)
    disp(['Processing test file: ',num2str(iter),' of ',num2str(length(testData))]);
    if strcmp(testLabel(iter,:), "EYST")
        classEYST_gt = classEYST_gt + 1;
    elseif strcmp(testLabel(iter,:), "HNST")
        classHNST_gt = classHNST_gt + 1;
    elseif strcmp(testLabel(iter,:), "HTST")
        classHTST_gt = classHTST_gt + 1;
    elseif strcmp(testLabel(iter,:), "MOST")
        classMOST_gt = classMOST_gt + 1;
    end
    if classifier == 1
        result{iter} = dtwWrapper(dtwType, trainData, trainLabel, testData{iter}, topC, muValueInThreshold);
    elseif classifier == 2
        result{iter} = ltwWrapper(trainData, trainLabel, testData{iter}, topC, muValueInThreshold);
    end
    [uniqueStrings, ~, stringMap] = unique(string(result{iter}(1 : topC,:)));
    mostCommonString = uniqueStrings(mode(stringMap));
    if strcmp(mostCommonString, testLabel(iter,:))
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
        logger([char(testLabel(iter,:)) ' predicted as ' char(mostCommonString)]);
        disp([char(testLabel(iter,:)) ' predicted as ' char(mostCommonString)]);
    end
end

disp('count')
count
logger(['Total Accuracy ' count/length(testData) * 100 ' ' [num2str(count),'/',num2str(length(testData))]]);
disp('total Accuracy')
disp(count/length(testData) * 100)
disp([num2str(count),'/',num2str(length(testData))])
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


% save(string(datetime));
end