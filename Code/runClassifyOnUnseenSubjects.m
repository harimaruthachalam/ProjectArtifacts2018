function runClassifyOnUnseenSubjects

rng(123);

path = '/home/hari/Documents/Projects/ProjectArtifacts2018/Data/';
testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Train/';
if( exist(testPath, 'dir') )
    rmdir( testPath, 's' );
end
if( exist(trainPath, 'dir') )
    rmdir( trainPath, 's' );
end
mkdir(testPath);
mkdir(trainPath);

files = extractFileNames(path);

perm = randperm(size(files, 1));
files = files(perm,:);

for i = 1 : ceil(size(files, 1)/2)
    mkdir(testPath,files(i,:));
    copyfile([path files(i,:)], [testPath files(i,:)]);
end

for i = ceil(size(files, 1)/2) + 1 : size(files, 1)
    mkdir(trainPath,files(i,:));
    copyfile([path files(i,:)], [trainPath files(i,:)]);
end



interpolate = [1];
feature = ['S'];
standandize = [1];
transorm = [0];
topC = [1 3 5 7];
thresholdSTD = -1.3;
trainPercent = 50;

for iterTrainPercent = 1 : length(trainPercent)
    for iterInterpolate = 1 : length(interpolate)
        for iterFeature = 1 : length(feature)
            for iterStandandize = 1 : length(standandize)
                for iterTopC = 1 : length(topC)
                    for iterTransorm = 1 : length(transorm)
                        for iterThresholdSTD = 1 : length(thresholdSTD)
                            logger(strcat("knn = 0; dtw = 1; interpolate = ", string(interpolate(iterInterpolate)), "; applyVAD = 2; VADWindow = 50; VADOverlap = 40; dataFromPool = 0; feature = ", string(feature(iterFeature)), "; standandize = ", string(standandize(iterStandandize)), "; topC = ", string(topC(iterTopC)), "; transorm = ", string(transorm(iterTransorm)), ";", string(trainPercent(iterTrainPercent)), "; ThresholdSTD: ", string(thresholdSTD(iterThresholdSTD))));
                            Main(0,1,interpolate(iterInterpolate),2,50,40,0,feature(iterFeature),standandize(iterStandandize),topC(iterTopC), transorm(iterTransorm),trainPercent(iterTrainPercent),thresholdSTD(iterThresholdSTD));
                        end
                    end
                end
            end
        end
    end
end
for iterTrainPercent = 1 : length(trainPercent)
    for iterInterpolate = 1 : length(interpolate)
        for iterFeature = 1 : length(feature)
            for iterStandandize = 1 : length(standandize)
                for iterTopC = 1 : length(topC)
                    for iterTransorm = 1 : length(transorm)
                        for iterThresholdSTD = 1 : length(thresholdSTD)
                            logger(strcat("knn = 0; dtw = 2; interpolate = ", string(interpolate(iterInterpolate)), "; applyVAD = 2; VADWindow = 50; VADOverlap = 40; dataFromPool = 0; feature = ", string(feature(iterFeature)), "; standandize = ", string(standandize(iterStandandize)), "; topC = ", string(topC(iterTopC)), "; transorm = ", string(transorm(iterTransorm)), ";", string(trainPercent(iterTrainPercent)), "; ThresholdSTD: ", string(thresholdSTD(iterThresholdSTD))));
                            Main(0,2,interpolate(iterInterpolate),2,50,40,0,feature(iterFeature),standandize(iterStandandize),topC(iterTopC), transorm(iterTransorm),trainPercent(iterTrainPercent),thresholdSTD(iterThresholdSTD));
                        end
                    end
                end
            end
        end
    end
end

% for iterTrainPercent = 1 : length(trainPercent)
%     for iterInterpolate = 1 : length(interpolate)
%         for iterFeature = 1 : length(feature)
%             for iterStandandize = 1 : length(standandize)
%                 for iterTopC = 1 : length(topC)
%                     for iterTransorm = 1 : length(transorm)
%                         logger(strcat("knn = 1; dtw = 0; interpolate = ", string(interpolate(iterInterpolate)), "; applyVAD = 0; VADWindow = 50; VADOverlap = 40; dataFromPool = 1; feature = ", string(feature(iterFeature)), "; standandize = ", string(standandize(iterStandandize)), "; topC = ",string(topC(iterTopC)), "; transorm = ", string(transorm(iterTransorm)), ";", string(trainPercent(iterTrainPercent))));
%                         Main(1,0,interpolate(iterInterpolate),0,50,40,1,feature(iterFeature),standandize(iterStandandize),topC(iterTopC), transorm(iterTransorm),trainPercent(iterTrainPercent));
%                     end
% 
%                 end
%             end
%         end
%     end
% end
end