function [lower, upper] = findThresholdLimit(signal, class)
% Updated on Jan 18, 2019
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
signalPower = movmean(abs(mean(signal(channels,:))),200);
threshold = mean(signalPower) - std(signalPower) * 0.5;

lower = min(find(threshold < signalPower));
upper = max(find(threshold < signalPower));

end