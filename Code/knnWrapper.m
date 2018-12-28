function retLabel = knnWrapper(refData, refLabel, testData, topC)
% Updated on Dec 28, 2018
% I will update the help once the code is complete


% send the data to compare with all refdata and check the 10 lowest. return
% the highest occurance.


euclDist = ones(length(refLabel),1) * Inf;
for iter = 1 : length(refLabel)
    euclDist(iter) = norm(refData{iter}(:) - testData(:));
end


[euclDistSorted, index] = sort(euclDist);


retLabel = refLabel(index(1 : topC),:);

end