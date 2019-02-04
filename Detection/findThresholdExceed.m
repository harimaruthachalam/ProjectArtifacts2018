function [signal] = findThresholdExceed(testData)
% Updated on Feb 1, 2019
% I will update soon

channels = fetchComponentsForRegion('frontal');

data = testData;
signal = mean(data(channels,:)) - mean(data(setdiff(1:128,channels),:));

signal = movmean(signal, 100);
signal = movmean(abs(signal),200);
signal = signal ./ movmean(signal,1000);
signal = movmean(signal, 100);
signal = signal - mean(signal);
signal = movmean(signal, 100);
signal = movmean(signal, 1000);
signal = (signal > 0);

end