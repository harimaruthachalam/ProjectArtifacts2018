function runClassify

seed = 1234;

path = '/home/hari/Documents/Projects/ProjectArtifacts2018/Data/';
trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Train/';
testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
classifier = 2; % 1 - DTW; 2 - LTW;
dtwType = 'S'; % S - Simple; T - Time Sync; N - Normalized; B - Both;
dataFromPool = 0;
feature = 'S'; % S or M
topC = [13];
trainPercent = [50];
thresholdC = -1;
thresholdD = 0.9;

testPercent = 100 - trainPercent(1);

splitFiles(seed, path, trainPath, testPath, testPercent);

for iterTrainPercent = 1 : length(trainPercent)
    for iterFeature = 1 : length(feature)
        for iterThresholdD = 1 : length(thresholdD)
            for iterThresholdC = 1 : length(thresholdC)
                for iterTopC = 1 : length(topC)
                    logger(strcat("classifier = ",string(classifier),"; dtw = ",string(dtwType),"; dataFromPool = ",string(dataFromPool),"; feature = ", string(feature(iterFeature)), "; topC = ", string(topC(iterTopC)), "; trainPercent = ", string(trainPercent(iterTrainPercent)), "; thresholdD: ", string(thresholdD(iterThresholdD)), "; thresholdC: ", string(thresholdC(iterThresholdC))));
                    Main(path, trainPath, testPath, classifier, dtwType, dataFromPool, feature(iterFeature), topC(iterTopC), trainPercent(iterTrainPercent), thresholdC(iterThresholdC), thresholdD(iterThresholdD));
                end
            end
        end
    end
end


end