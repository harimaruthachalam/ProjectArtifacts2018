function retLabel = knnWrapper(refData, refLabel, testData, topC)
% Updated on Oct 17, 2018
% I will update the help once the code is complete


% send the data to compare with all refdata and check the 10 lowest. return
% the highest occurance.


euclDist = [];
for iter = 1 : length(refLabel)
    euclDist = [euclDist; norm(refData{iter}(:) - testData(:))];
end


[euclDistSorted, index] = sort(euclDist);


retLabel = refLabel(index(1 : topC),:);

end