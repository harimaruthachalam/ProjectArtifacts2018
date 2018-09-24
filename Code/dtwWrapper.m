function retLabel = dtwWrapper(refData, refLabel, testData, topC)
% Updated on Sep 24, 2018
% I will update the help once the code is complete


% send the data to compare with all refdata and check the 10 lowest. return
% the highest occurance.

% commandStr = 'python sdtwDist.py';
% [status, commandOut] = system(commandStr);
% if status==0
% fprintf('squared result is %d\n',str2num(commandOut));
% end

dtwDist = [];
for iter = 1 : length(refLabel)
    X = refData{iter}';
    Y = testData';
    save('tempData.mat', 'X', 'Y');
    commandStr = 'python sdtwDist.py';
    [status, commandOut] = system(commandStr);
    if status==0
        dtwDist = [dtwDist; str2num(commandOut)];
    end
    %     dtwDist = [dtwDist; dtw(refData{iter}, testData, 2)];
end

[dtwDistSorted, index] = sort(dtwDist);

% retLabel = mode(refLabel(index(1:2),:));

retLabel = refLabel(index(1 : topC),:);

% disp('ff')
%
%
% n = 2;
% [arrayx, index] = sort(array);
% result      = array(sort(index(1:n)))

end