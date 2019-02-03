function result = presentInWindow(startIndex, endIndex, flagArrayGround)
% Updated on Feb 1, 2019
% I will update soon

result = sum(flagArrayGround(startIndex : endIndex)) ~= 0;

% for iter = 1 : length(startIndexGround) 
%     if startIndexGround(iter) <= startIndex && endIndexGround(iter) >= endIndex
%         result = true;
%     end
% end

end