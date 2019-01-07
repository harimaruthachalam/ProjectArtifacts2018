function [signal] = filterTransform(signal, class)
% Updated on Jan 7, 2019
% I will update the help once the code is complete

filterVector = zeros(128,1);

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
filterVector(channels) = 1;

signal = signal .* filterVector;

end