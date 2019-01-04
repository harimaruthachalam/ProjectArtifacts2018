function runClassify

interpolate = [0 1];
feature = ['S' 'M' 'D' 'DM'];
standandize = [0 1];
topC = [1 2 3 4 5 6];

for iterInterpolate = 1 : length(interpolate)
    for iterFeature = 1 : length(feature)
        for iterStandandize = 1 : length(standandize)
            for iterTopC = 1 : length(topC)
                logger(strcat("knn = 0; dtw = 1; interpolate = ", string(interpolate(iterInterpolate)), "; applyVAD = 0; VADWindow = 50; VADOverlap = 40; dataFromPool = 1; feature = ", string(feature(iterFeature)), "; standandize = ", string(standandize(iterStandandize)), "; topC = ",string(topC(iterTopC))));
                Main(0,1,interpolate(iterInterpolate),0,50,40,1,feature(iterFeature),standandize(iterStandandize),topC(iterTopC));
            end
            
        end
    end
end
end