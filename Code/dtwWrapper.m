function retLabel = dtwWrapper(refData, refLabel, testData, DTWType, savePath, topC)
% Updated on Oct 17, 2018
% I will update the help once the code is complete


% send the data to compare with all refdata and check the 10 lowest. return
% the highest occurance.


dtwDist = [];
for iter = 1 : length(refLabel)
    if DTWType == 'soft'
        R = SoftDTW(refData{iter}, testData, 1);
    else
        R = HardDTW(refData{iter}, testData);
    end
    dtwDist = [dtwDist; R(end:end)];
end


[dtwDistSorted, index] = sort(dtwDist);


if DTWType == 'soft'
    R = SoftDTW(refData{index(1)}, testData, 1);
else
    R = HardDTW(refData{index(1)}, testData);
end
imagesc(R);

savefig(strcat(fullfile(savePath,DTWType),datestr(clock,'YYYY/mm/dd HH:MM:SS:FFF'),'.fig'));
saveas(gcf,strcat(fullfile(savePath,DTWType),datestr(clock,'YYYY/mm/dd HH:MM:SS:FFF'),'.png'));
close;

retLabel = refLabel(index(1 : topC),:);

end