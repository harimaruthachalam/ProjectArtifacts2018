function [R] = HardDTW(X, Y, w)
% Updated on Oct 12, 2018
% I will update the help once the code is complete

if nargin < 3
    w = Inf;
elseif w == 0
    w = Inf;
end

D = pdist2(X', Y', 'squaredeuclidean');

m = size(X, 2);
n = size(Y, 2);

if size(X,1)~=size(Y,1)
    error('Error in dtw(): the dimensions of the two input signals do not match.');
end

R = zeros(m+1, n+1) + Inf;

R(:, 1) = Inf;
R(1, :) = Inf;

R(1,1) = 0;

for i=1:m
    for j=max(i-w,1):min(i+w,n)
        R(i+1,j+1) = D(i,j)+min( [R(i,j+1), R(i+1,j), R(i,j)] );
        
    end
end

R = R(end:end);

end