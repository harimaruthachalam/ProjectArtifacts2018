function [files] = extractFileNames(path)
% Updated on July 30, 2018
% I will update the help once the code is complete

path = fullfile(path);
filesInDir = dir(path);
files = [];
for iter = 1 : size(filesInDir,1)
    if ~strcmp(filesInDir(iter).name,'.') && ~strcmp(filesInDir(iter).name,'..')
        files = [files; filesInDir(iter).name];
    end
end
end