

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

close all;
% y = movmean(mean(trainData{20}(channels,:))-mean(trainData{20}([1:128 - channels],:)),200)
y = movmean(abs(mean(trainData{183}(channels,:))),200)
th = mean(y) %- std(y) * 0.5
%yz = movmean(mean(trainData{170}([1:128 - channels],:)),200)
figure;plot(y)
hold on; plot(y .* (y> th))
% figure;dtw(x,y-mean(y));
figure;
for i = 1 : 8 : 128
subplot(16,1,ceil(i/8));
plot(trainData{183}(i,:));
% hold on;
% plot(trainData{250}(i,:) .* (y> th))
end
figure;
dtw(x,y-mean(y));

[d, xx, yy] = dtw(x,y-mean(y));
figure;plot(xx)
figure;plot(diff(xx))