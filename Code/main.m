function main
% Updated on Sep 12, 2018
% I will update the help once the code is complete

close all;
clear;
clc;

% electrode = 30;

path = '/home/hari/Documents/Projects/ProjectArtifacts2018/Data/';
files = extractFiles(path);
cellEYST = {};
cellMOST = {};
cellHTST = {};
cellHNST = {};

for iteratorFile = 1 : size(files,1)
    currentFilename = strcat(files(iteratorFile,:), '_band_0_60_notch50_fil.raw');
    currentPath = strcat(path,files(iteratorFile,:),'/');
    %     mkdir(fullfile(path,toSavePath));
    
    rawFilename = erase(currentFilename,'_band_0_60_notch50_fil.raw');
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_readegi(strcat(currentPath,currentFilename), [],[],'auto');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Init'),'gui','on');
    
    
    fid = fopen(strcat(currentPath,files(iteratorFile,:), '_band_0_60_notch50_fil_IMP.txt'),'rt');
    
    inconfig = textscan(fid, '%s %*[:] %s', 'CommentStyle', '%','HeaderLines',5);
    fclose(fid);
    
    
    % EEG = pop_interp(EEG, find(str2double(inconfig{1,2}(1:128)) > 49)', 'spherical');
    % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Interpolated'),'gui','off');
    
    EEG = eeg_checkset( EEG );
%     EEG.data = movmean(EEG.data,100);
%     EEG.data = diff(EEG.data,1,2);
    
    EEG = pop_epoch( EEG, { 'EYST' }, [0 3], 'newname', strcat(rawFilename, ' Eye Open and Close'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    EEG = eeg_checkset( EEG );
    
    for iterEpoch = 1 : EEG.trials
        cellEYST{size(cellEYST,2) + 1} = EEG.data(:,:,iterEpoch);
    end
    
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0);
    EEG = eeg_checkset( EEG );
    
    EEG = pop_epoch( EEG, {  'MOST'  }, [0  3], 'newname', strcat(rawFilename, ' Mouth Open and Close'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    EEG = eeg_checkset( EEG );
    
    for iterEpoch = 1 : EEG.trials
        cellMOST{size(cellMOST,2) + 1} = EEG.data(:,:,iterEpoch);
    end
    
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0);
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, {  'HTST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Turn'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    
    for iterEpoch = 1 : EEG.trials
        cellHTST{size(cellHTST,2) + 1} = EEG.data(:,:,iterEpoch);
    end
    
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',1,'study',0);
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, {  'HNST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Nod'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    EEG = eeg_checkset( EEG );
    
    for iterEpoch = 1 : EEG.trials
        cellHNST{size(cellHNST,2) + 1} = EEG.data(:,:,iterEpoch);
    end
end

perm = randperm(size(cellEYST, 2));
cellEYST = cellEYST(perm);
perm = randperm(size(cellHNST, 2));
cellHNST = cellHNST(perm);
perm = randperm(size(cellHTST, 2));
cellHTST = cellHTST(perm);
perm = randperm(size(cellMOST, 2));
cellMOST = cellMOST(perm);


% testCellHNST = cellHNST(1 : ceil(size(cellHNST,2)/2));
% testCellEYST = cellEYST(1 : ceil(size(cellEYST,2)/2));
% testCellHTST = cellHTST(1 : ceil(size(cellHTST,2)/2));
% testCellMOST = cellMOST(1 : ceil(size(cellMOST,2)/2));
% 
% cellEYST = cellEYST(ceil(size(cellEYST,2)/2) + 1 : end);
% cellHNST = cellHNST(ceil(size(cellHNST,2)/2) + 1 : end);
% cellHTST = cellHTST(ceil(size(cellHTST,2)/2) + 1 : end);
% cellMOST = cellMOST(ceil(size(cellMOST,2)/2) + 1 : end);


path = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
files = extractFiles(path);
testCellEYST = {};
testCellMOST = {};
testCellHTST = {};
testCellHNST = {};

for iteratorFile = 1 : size(files,1)
    currentFilename = strcat(files(iteratorFile,:), '_band_0_60_notch50_fil.raw');
    currentPath = strcat(path,files(iteratorFile,:),'/');
    %     mkdir(fullfile(path,toSavePath));
    
    rawFilename = erase(currentFilename,'_band_0_60_notch50_fil.raw');
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_readegi(strcat(currentPath,currentFilename), [],[],'auto');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Init'),'gui','on');
    
    
    fid = fopen(strcat(currentPath,files(iteratorFile,:), '_band_0_60_notch50_fil_IMP.txt'),'rt');
    
    inconfig = textscan(fid, '%s %*[:] %s', 'CommentStyle', '%','HeaderLines',5);
    fclose(fid);
    
    
    % EEG = pop_interp(EEG, find(str2double(inconfig{1,2}(1:128)) > 49)', 'spherical');
    % [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Interpolated'),'gui','off');
    
    EEG = eeg_checkset( EEG );
%     EEG.data = movmean(EEG.data,100);
%     EEG.data = diff(EEG.data,1,2);
    
    EEG = pop_epoch( EEG, { 'EYST' }, [0 3], 'newname', strcat(rawFilename, ' Eye Open and Close'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    EEG = eeg_checkset( EEG );
    
    for iterEpoch = 1 : EEG.trials
        testCellEYST{size(testCellEYST,2) + 1} = EEG.data(:,:,iterEpoch);
    end
    
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0);
    EEG = eeg_checkset( EEG );
    
    EEG = pop_epoch( EEG, {  'MOST'  }, [0  3], 'newname', strcat(rawFilename, ' Mouth Open and Close'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    EEG = eeg_checkset( EEG );
    
    for iterEpoch = 1 : EEG.trials
        testCellMOST{size(testCellMOST,2) + 1} = EEG.data(:,:,iterEpoch);
    end
    
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0);
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, {  'HTST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Turn'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    
    for iterEpoch = 1 : EEG.trials
        testCellHTST{size(testCellHTST,2) + 1} = EEG.data(:,:,iterEpoch);
    end
    
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',1,'study',0);
    EEG = eeg_checkset( EEG );
    EEG = pop_epoch( EEG, {  'HNST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Nod'), 'epochinfo', 'yes');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
    EEG = eeg_checkset( EEG );
    
    for iterEpoch = 1 : EEG.trials
        testCellHNST{size(testCellHNST,2) + 1} = EEG.data(:,:,iterEpoch);
    end
end


data = {};
label = [];
% [cellHNST{2}(1,:); cellHNST{2}(1,:)]
for iter = 1 : size(cellHNST,2)
    data = [data; cellHNST{iter}(:,:) - mean(cellHNST{iter}(:,:),2)];
end
label = [label; repmat('HNST', size(cellHNST,2), 1)];


for iter = 1 : size(cellHTST,2)
    data = [data; cellHTST{iter}(:,:) - mean(cellHTST{iter}(:,:),2)];
end
label = [label; repmat('HTST', size(cellHTST,2), 1)];


for iter = 1 : size(cellEYST,2)
    data = [data; cellEYST{iter}(:,:) - mean(cellEYST{iter}(:,:),2)];
end
label = [label; repmat('EYST', size(cellEYST,2), 1)];


for iter = 1 : size(cellMOST,2)
    data = [data; cellMOST{iter}(:,:) - mean(cellMOST{iter}(:,:),2)];
end
label = [label; repmat('MOST', size(cellMOST,2), 1)];




% multisvm(data, label, data);refData
% perm = randperm(size(data,1));
% data = data(perm, :);
% label = label(perm);

disp('HNST');
count = 0;
resHNST = {};
for iter = 1 : length(testCellHNST)
    resHNST = [resHNST; dtwWrapper(data, label, testCellHNST{iter},10)];
    if strcmp(resHNST{end}(1,:),'HNST')
        count = count + 1;
    end
end
countHNST = count
disp('EYST');
count = 0;
resEYST = {};
for iter = 1 : length(testCellEYST)
    resEYST = [resEYST; dtwWrapper(data, label, testCellEYST{iter}, 10)];
    if strcmp(resEYST{end}(1,:),'EYST')
        count = count + 1;
    end
end
countEYST = count
disp('HTST');
count = 0;
resHTST = {};
for iter = 1 : length(testCellHTST)
    resHTST = [resHTST; dtwWrapper(data, label, testCellHTST{iter}, 10)];
    if strcmp(resHTST{end}(1,:),'HTST')
        count = count + 1;
    end
end
countHTST = count
disp('MOST');
count = 0;
resMOST = {};
for iter = 1 : length(testCellMOST)
    resMOST = [resMOST; dtwWrapper(data, label, testCellMOST{iter}, 10)];
    if strcmp(resMOST{end}(1,:),'MOST')
        count = count + 1;
    end
end
countMOST = count



disp('f');
end