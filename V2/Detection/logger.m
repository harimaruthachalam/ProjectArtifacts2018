function logger(message)
% Updated on Aug 1, 2018
% I will update the help once the code is complete
fid = fopen('log.txt', 'at');
fprintf(fid, '%s\n', strcat(string(datetime), " ", string(message)));
fclose(fid);
end
