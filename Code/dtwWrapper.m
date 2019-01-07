function retLabel = dtwWrapper(refData, refLabel, testData, DTWType, toTransform, savePath, topC)
% Updated on Jan 7, 2019
% I will update the help once the code is complete


% send the data to compare with all refdata and check the 10 lowest. return
% the highest occurance.


dtwDist = [];
for iter = 1 : length(refLabel)
    %     if DTWType == 'soft'
    %         R = SoftDTW(refData{iter}, testData, 1);
    %     else
    %         R = HardDTW(refData{iter}, testData);
    %     end
    if toTransform == true
        tempRef = filterTransform(refData{iter}, refLabel(iter,:));
        tempTest = filterTransform(testData, refLabel(iter,:));
        R = HardDTW(tempRef, tempTest);
    else
        R = HardDTW(refData{iter}, testData);
    end
    dtwDist = [dtwDist; R(end:end)];
end


[dtwDistSorted, index] = sort(dtwDist);


if ~isempty(savePath)
    % if DTWType == 'soft'
    %     R = SoftDTW(refData{index(1)}, testData, 1);
    % else
    %     R = HardDTW(refData{index(1)}, testData);
    % end
    if toTransform == true
        tempRef = filterTransform(refData{index(1)}, refLabel(index(1),:));
        tempTest = filterTransform(testData, refLabel(index(1),:));
        R = HardDTW(tempRef, tempTest);
    else
        R = HardDTW(refData{index(1)}, testData);
    end
    imagesc(R);
    mkdir(strcat(fullfile(savePath, DTWType), '/', refLabel(index(1),:)));
    milliSec = datestr(clock,'mm_dd_HH_MM_SS_FFF');
    
    savefig(strcat(fullfile(savePath, DTWType, refLabel(index(1),:)), '/', milliSec,'.fig'));
    saveas(gcf,strcat(fullfile(savePath, DTWType, refLabel(index(1),:)), '/', milliSec,'.png'));
    close;
end

retLabel = refLabel(index(1 : topC),:);

end