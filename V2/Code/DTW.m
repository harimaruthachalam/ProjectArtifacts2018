function [R, k] = DTW(X, Y, isTimeSync, w)
% Updated on Feb 6, 2019
% I will update the help once the code is complete
% function [R, k] = DTW(X, Y, isTimeSync, w)
% X - Ref; Y - Test; isTimeSync - No vertical move; w - Beam width; 
% R - Distance matrix; k - Path length;

if nargin < 4
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
        if isTimeSync == true
            R(i+1,j+1) = D(i,j)+min( [R(i,j+1), R(i,j)] );
        else
            R(i+1,j+1) = D(i,j)+min( [R(i,j+1), R(i+1,j), R(i,j)] );
        end
    end
end

k=1;
while ((m+n)~=2)
    if (m-1)==0
        n=n-1;
    elseif (n-1)==0
        m=m-1;
    else
        if isTimeSync == true
            [~,number]=min([D(m-1,n),D(m,n-1),D(m-1,n-1)]);
            
            switch number
                case 1
                    m=m-1;
                case 2
                    n=n-1;
                case 3
                    m=m-1;
                    n=n-1;
            end
        else
            [~,number]=min([D(m,n-1),D(m-1,n-1)]);
            
            switch number
                case 1
                    n=n-1;
                case 2
                    m=m-1;
                    n=n-1;
            end
        end
        k=k+1;
    end
    
end