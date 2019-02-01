function runClassify

trainPercent = [40 30 25 20 10];
feature = ['S' 'M' 'D' 'DM'];
topC = [1 2 3 4 5 6];
thresholdSTD = -1:0.1:1;

for iterTrainPercent = 1 : length(trainPercent)
    for iterFeature = 1 : length(feature)
        for iterTopC = 1 : length(topC)
            for iterThresholdSTD = 1 : length(thresholdSTD)
                logger(strcat("knn = 0; dtw = 1; interpolate = ", string(interpolate(iterInterpolate)), "; applyVAD = 0; VADWindow = 50; VADOverlap = 40; dataFromPool = 1; feature = ", string(feature(iterFeature)), "; standandize = ", string(standandize(iterStandandize)), "; topC = ", string(topC(iterTopC)), "; transorm = ", string(transorm(iterTransorm)), ";", string(trainPercent(iterTrainPercent)), "; ThresholdSTD: ", string(thresholdSTD(iterThresholdSTD))));
                Main(0,1,interpolate(iterInterpolate),0,50,40,1,feature(iterFeature),standandize(iterStandandize),topC(iterTopC), transorm(iterTransorm),trainPercent(iterTrainPercent),thresholdSTD(iterThresholdSTD));
            end
        end
    end
end
end