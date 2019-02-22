function runClassifyOnUnseenSubjects


path = '/home/hari/Documents/Projects/ProjectArtifacts2018/Data/';
trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Train/';
testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
seed = 123;
classifier = 1; % 1 - DTW; 2 - LTW;
dtwType = 'N'; % S - Simple; T - Time Sync; N - Normalized; B - Both;
dataFromPool = 0;
feature = 'M'; % S or M
trainPercent = [50];
topC = [13];
muValueInThreshold = 0.6;

testPercent = 100 - trainPercent(1);

splitFiles(seed, path, trainPath, testPath, testPercent);

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