function Main(varargin)
% Updated on Jan 7, 2019
% I will update the help once the code is complete

close all;
clc;

trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Data/';
savePath = '';
testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
seed = 123;

% knn = 0;
% dtw = 1;
% interpolate = 1;
% applyVAD = 0;
% VADWindow = 50;
% VADOverlap = 40;
% dataFromPool = 1;
% feature = 'S'; % S or M or D of DM
% standandize = 1;
% topC = 1;
% toTransform = 0;

if nargin == 11
    knn = varargin{1};
    dtw = varargin{2};
    interpolate = varargin{3};
    applyVAD = varargin{4};
    VADWindow = varargin{5};
    VADOverlap = varargin{6};
    dataFromPool = varargin{7};
    feature = varargin{8}; % S or M or D of DM
    standandize = varargin{9};
    topC = varargin{10};
    toTransform = varargin{11};
elseif nargin == 0
    knn = 0;
    dtw = 1;
    interpolate = 1;
    applyVAD = 0;
    VADWindow = 50;
    VADOverlap = 40;
    dataFromPool = 1;
    feature = 'S'; % S or M or D of DM
    standandize = 1;
    topC = 1;
    toTransform = 1;
else
    error('Invalid Args count');
    return;
end


[trainData, trainLabel, testData, testLabel] = extractDataFiles(seed, trainPath, testPath, dataFromPool, applyVAD, VADWindow, VADOverlap, feature, standandize, interpolate);

count = 0;
class1 = 0;
class2 = 0;
class3 = 0;
class4 = 0;
class1_gt = 0;
class2_gt = 0;
class3_gt = 0;
class4_gt = 0;
result = cell(length(testData), 1);

if dtw == 1
    
    parfor iter = 1 : length(testData)
        disp(['Processing test file: ',num2str(iter),' of ',num2str(length(testData))]);
        if strcmp(testLabel(iter,:), "EYST")
            class1_gt = class1_gt + 1;
        elseif strcmp(testLabel(iter,:), "HNST")
            class2_gt = class2_gt + 1;
        elseif strcmp(testLabel(iter,:), "HTST")
            class3_gt = class3_gt + 1;
        elseif strcmp(testLabel(iter,:), "MOST")
            class4_gt = class4_gt + 1;
        end
        result{iter} = dtwWrapper(trainData, trainLabel, testData{iter}, 'hard', toTransform, savePath, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result{iter}(topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, testLabel(iter,:))
            count = count + 1;
            if strcmp(mostCommonString, "EYST")
                class1 = class1 + 1;
            elseif strcmp(mostCommonString, "HNST")
                class2 = class2 + 1;
            elseif strcmp(mostCommonString, "HTST")
                class3 = class3 + 1;
            elseif strcmp(mostCommonString, "MOST")
                class4 = class4 + 1;
            end
        else
            % Will modify soon
            logger([testLabel(iter,:) ' predicted as ' mostCommonString]);
            disp([testLabel(iter,:) ' predicted as ' mostCommonString]);
        end
    end
    disp('count')
    count
    logger(['Total Accuracy ' count/length(testData) * 100 ' ' [num2str(count),'/',num2str(length(testData))]]);
    disp('total Accuracy')
    disp(count/length(testData) * 100)
    disp([num2str(count),'/',num2str(length(testData))])
    logger(['Eye TP Rate ' class1/(class1_gt) * 100 ' ' [num2str(class1),'/',num2str(class1_gt)]]);
    disp('Eye TP Rate')
    disp(class1/(class1_gt) * 100)
    disp([num2str(class1),'/',num2str(class1_gt)])
    logger(['HN TP Rate ' class2/(class2_gt) * 100 ' ' [num2str(class2),'/',num2str(class2_gt)]]);
    disp('HN Accuracy')
    disp(class2/(class2_gt) * 100)
    disp([num2str(class2),'/',num2str(class2_gt)])
    logger(['HT TP Rate ' class3/(class3_gt) * 100 ' ' [num2str(class3),'/',num2str(class3_gt)]]);
    disp('HT Accuracy')
    disp(class3/(class3_gt) * 100)
    disp([num2str(class3),'/',num2str(class3_gt)])
    logger(['MO TP Rate ' class4/(class4_gt) * 100 ' ' [num2str(class4),'/',num2str(class4_gt)]]);
    disp('MOST')
    disp(class4/(class4_gt) * 100)
    disp([num2str(class4),'/',num2str(class4_gt)])
    
elseif knn == 1
    
    
    parfor iter = 1 : length(testData)
        disp(['Processing test file: ',num2str(iter),' of ',num2str(length(testData))]);
        if strcmp(testLabel(iter,:), "EYST")
            class1_gt = class1_gt + 1;
        elseif strcmp(testLabel(iter,:), "HNST")
            class2_gt = class2_gt + 1;
        elseif strcmp(testLabel(iter,:), "HTST")
            class3_gt = class3_gt + 1;
        elseif strcmp(testLabel(iter,:), "MOST")
            class4_gt = class4_gt + 1;
        end
        result{iter} = knnWrapper(trainData, trainLabel, testData{iter}, topC);
        [uniqueStrings, ~, stringMap] = unique(string(result{iter}(topC,:)));
        mostCommonString = uniqueStrings(mode(stringMap));
        if strcmp(mostCommonString, testLabel(iter,:))
            count = count + 1;
            if strcmp(mostCommonString, "EYST")
                class1 = class1 + 1;
            elseif strcmp(mostCommonString, "HNST")
                class2 = class2 + 1;
            elseif strcmp(mostCommonString, "HTST")
                class3 = class3 + 1;
            elseif strcmp(mostCommonString, "MOST")
                class4 = class4 + 1;
            end
        else
            % Will modify soon
            logger([testLabel(iter,:) ' predicted as ' mostCommonString]);
            disp([testLabel(iter,:) ' predicted as ' mostCommonString]);
        end
    end
    disp('count')
    count
    logger(['Total Accuracy ' count/length(testData) * 100 ' ' [num2str(count),'/',num2str(length(testData))]]);
    disp('total Accuracy')
    disp(count/length(testData) * 100)
    disp([num2str(count),'/',num2str(length(testData))])
    logger(['Eye TP Rate ' class1/(class1_gt) * 100 ' ' [num2str(class1),'/',num2str(class1_gt)]]);
    disp('Eye TP Rate')
    disp(class1/(class1_gt) * 100)
    disp([num2str(class1),'/',num2str(class1_gt)])
    logger(['HN TP Rate ' class2/(class2_gt) * 100 ' ' [num2str(class2),'/',num2str(class2_gt)]]);
    disp('HN Accuracy')
    disp(class2/(class2_gt) * 100)
    disp([num2str(class2),'/',num2str(class2_gt)])
    logger(['HT TP Rate ' class3/(class3_gt) * 100 ' ' [num2str(class3),'/',num2str(class3_gt)]]);
    disp('HT Accuracy')
    disp(class3/(class3_gt) * 100)
    disp([num2str(class3),'/',num2str(class3_gt)])
    logger(['MO TP Rate ' class4/(class4_gt) * 100 ' ' [num2str(class4),'/',num2str(class4_gt)]]);
    disp('MOST')
    disp(class4/(class4_gt) * 100)
    disp([num2str(class4),'/',num2str(class4_gt)])
end
end