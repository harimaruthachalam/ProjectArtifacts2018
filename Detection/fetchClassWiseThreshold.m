function [threshold] = fetchClassWiseThreshold(trainData, trainLabel, thresholdClassWise, class)
% Updated on Feb 1, 2019
% I will update soon

if class == 'EYST'
    region = 'frontal';
elseif class == 'HNST'
    region = 'occipitaltemporal';
elseif class == 'HTST'
    region = 'occipitaltemporalRight';
elseif class == 'MOST'
    region = 'temporal';
end

channels = fetchComponentsForRegion(region);

threshold = [];
for iter = 1 : length(trainData)
    if trainLabel(iter, :) == class
        signal = mean(trainData{iter}(channels,:)) - mean(trainData{iter}(setdiff(1:128,channels),:));
    signalPower = movmean(abs( signal ),200);
%     threshold = mean(signalPower);
%     
%         signalPower = movmean(abs(mean(trainData{iter}(channels,:))),200);
        threshold = [threshold; mean(signalPower) + std(signalPower) * thresholdClassWise];
    end
end

threshold = mean(threshold);

end