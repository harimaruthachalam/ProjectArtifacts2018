function main
% Updated on Sep 12, 2018
% I will update the help once the code is complete

close all;
clear;
clc;

electrode = 30;

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
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Init'),'gui','off');
    
    EEG = eeg_checkset( EEG );
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

data = [];
label = [];
% [cellHNST{2}(1,:); cellHNST{2}(1,:)]
for iter = 1 : size(cellHNST,2)
    data = [data; cellHNST{iter}(electrode,:) - mean(cellHNST{iter}(electrode,:))];
end
label = [label; repmat(0, size(cellHNST,2), 1)];


for iter = 1 : size(cellHTST,2)
    data = [data; cellHTST{iter}(electrode,:) - mean(cellHTST{iter}(electrode,:))];
end
label = [label; repmat(1, size(cellHTST,2), 1)];


for iter = 1 : size(cellEYST,2)
    data = [data; cellEYST{iter}(electrode,:) - mean(cellEYST{iter}(electrode,:))];
end
label = [label; repmat(2, size(cellEYST,2), 1)];


for iter = 1 : size(cellMOST,2)
    data = [data; cellMOST{iter}(electrode,:) - mean(cellMOST{iter}(electrode,:))];
end
label = [label; repmat(3, size(cellMOST,2), 1)];


% multisvm(data, label, data);
perm = randperm(size(data,1));
data = data(perm, :);
label = label(perm);


count = 0;
for iter = 101 : 350
    if label(iter) == dtwWrapper(data(1:100, :), label(1:100), data(iter,:))
        count = count + 1;
    end
end

disp('f');
end