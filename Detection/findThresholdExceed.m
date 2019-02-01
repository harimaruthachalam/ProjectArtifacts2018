function [startIndex] = findThresholdExceed(testData, class, classThreshold)
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


% for index = 1 : 250 : size(testData,2) - 750
%     data = testData(:,index : min(size(testData,2), index + 749));
% %     data = data - mean(data,2);
% %     data = data/std(data(:));
% signal = mean(data(channels,:)) - mean(data(setdiff(1:128,channels),:));
%     signalPower = movmean(abs( signal ),200);
%     threshold = mean(signalPower);
%     if threshold > classThreshold
%         startIndex = [startIndex; index];
%     end
%     
% end

data = testData;
signal = mean(data(channels,:)) - mean(data(setdiff(1:128,channels),:));
    signalPower = movmean(abs( signal ),200);
    startIndex = signalPower > classThreshold;

% signalPower = movmean(abs(mean(testData(channels,:))),200);
% flagArray = signalPower > classThreshold;
%
% startIndex = [];
% endIndex = [];
% for iter = 1 : length(flagArray) - 1
%     if flagArray(iter) == 0 && flagArray(iter + 1) == 1
%         startIndex = [startIndex; iter];
%         while iter < length(flagArray) && flagArray(iter + 1) == 1
%             iter = iter + 1;
%         end
%         endIndex = [endIndex; iter];
%     end
% end

end