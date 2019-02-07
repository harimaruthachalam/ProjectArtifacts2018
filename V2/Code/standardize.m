function [signal] = standardize(data)
% Updated on Feb 7, 2019
% I will update the help once the code is complete

signal = data;
signal = signal - mean(signal,2);
signal = signal/std(signal(:));

end