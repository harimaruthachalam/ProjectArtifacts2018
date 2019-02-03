function [channels] = fetchComponentsForRegion(regionToContribution)
% Updated on Feb 3, 2019
% I will update the help once the code is complete

%% Loading
fid = fopen('channelsRegionwise.txt','rt');
inconfig = textscan(fid, '%s %*[=] %s', 'CommentStyle', '%');
fclose(fid);

channels = [];

regionToContribution = lower(regionToContribution);
if contains(regionToContribution, lower("frontal"))
    frontalChannels = fetchConfig(inconfig, 'frontalChannels', '', 'string');
    frontalChannels = strsplit(frontalChannels,'~');
    channels = [channels str2double(frontalChannels)];
end
if contains(regionToContribution, lower("central"))
    centralChannels = fetchConfig(inconfig, 'centralChannels', '', 'string');
    centralChannels = strsplit(centralChannels,'~');
    channels = [channels str2double(centralChannels)];
end
if contains(regionToContribution, lower("parietal"))
    parietalChannels = fetchConfig(inconfig, 'parietalChannels', '', 'string');
    parietalChannels = strsplit(parietalChannels,'~');
    channels = [channels str2double(parietalChannels)];
end
if contains(regionToContribution, lower("occipital"))
    occipitalChannels = fetchConfig(inconfig, 'occipitalChannels', '', 'string');
    occipitalChannels = strsplit(occipitalChannels,'~');
    channels = [channels str2double(occipitalChannels)];
end
if contains(regionToContribution, lower("temporalLeft"))
    temporalLeftChannels = fetchConfig(inconfig, 'temporalLeftChannels', '', 'string');
    temporalLeftChannels = strsplit(temporalLeftChannels,'~');
    channels = [channels str2double(temporalLeftChannels)];
end
if contains(regionToContribution, lower("temporalRight"))
    temporalRightChannels = fetchConfig(inconfig, 'temporalRightChannels', '', 'string');
    temporalRightChannels = strsplit(temporalRightChannels,'~');
    channels = [channels str2double(temporalRightChannels)];
end
if contains(regionToContribution, lower("temporal"))
    temporalRightChannels = fetchConfig(inconfig, 'temporalRightChannels', '', 'string');
    temporalRightChannels = strsplit(temporalRightChannels,'~');
    temporalLeftChannels = fetchConfig(inconfig, 'temporalLeftChannels', '', 'string');
    temporalLeftChannels = strsplit(temporalLeftChannels,'~');
    channels = [channels union(str2double(temporalRightChannels),str2double(temporalLeftChannels))];
end


end