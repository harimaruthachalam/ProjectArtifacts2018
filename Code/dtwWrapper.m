function retLabel = dtwWrapper(refData, refLabel, testData)
% Updated on Sep 12, 2018
% I will update the help once the code is complete


% send the data to compare with all refdata and check the 10 lowest. return
% the highest occurance.

dtwDist = [];
for iter = 1 : length(refLabel)
    dtwDist = [dtwDist; dtw(refData{iter}, testData, 2)];
end

[dtwDistSorted, index] = sort(dtwDist);

% retLabel = mode(refLabel(index(1:2),:));

retLabel = refLabel(index(1),:);

% disp('ff')
% 
% 
% n = 2;
% [arrayx, index] = sort(array);
% result      = array(sort(index(1:n)))

end