function result = presentInWindow(startIndex, endIndex, startIndexGround, endIndexGround)
% Updated on Feb 1, 2019
% I will update soon

result = false;

for iter = 1 : length(startIndexGround) 
    if startIndexGround(iter) <= startIndex && endIndexGround(iter) >= endIndex
        result = true;
    end
end

end