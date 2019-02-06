function [lower, upper]= findThresholdExceedLimits(testData, muValueInThreshold)
% Updated on Feb 6, 2019
% I will update soon

data = testData;
data = (data).^2;
data = mean(data);
data  = movmean(data, 250);
%data = data ./std(data);

% One stop
data = data - (mean(data) + muValueInThreshold *  std(data));
data = (data > 0);

lower = min(find(threshold < data));
upper = max(find(threshold < data));

end