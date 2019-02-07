function runClassify

trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Train/';
testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
seed = 123;
classifier = 1; % 1 - DTW; 2 - LTW;
dtwType = 'S'; % S - Simple; T - Time Sync; N - Normalized; B - Both;
dataFromPool = 1;
feature = 'S'; % S or M
trainPercent = [50];
topC = [1 3 5 7 9 13];
muValueInThreshold = 0.6;

for iterTrainPercent = 1 : length(trainPercent)
    for iterFeature = 1 : length(feature)
        for iterThresholdSTD = 1 : length(muValueInThreshold)
            for iterTopC = 1 : length(topC)
                logger(strcat("classifier = ",string(classifier),"; dtw = ",string(dtwType),"; dataFromPool = ",string(dataFromPool),"; feature = ", string(feature(iterFeature)), "; topC = ", string(topC(iterTopC)), "; trainPercent = ", string(trainPercent(iterTrainPercent)), "; muValueInThreshold: ", string(muValueInThreshold(iterThresholdSTD))));
                Main(trainPath, testPath, seed, classifier, dtwType, dataFromPool, feature(iterFeature), topC(iterTopC), trainPercent(iterTrainPercent), muValueInThreshold(iterThresholdSTD));
            end
        end
    end
end


end