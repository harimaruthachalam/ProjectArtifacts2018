function [trainData, trainLabel, testData, testLabelStruct] = extractDataFiles(trainPath, testPath)
% Updated on Jan 31, 2019
% I will update the help once the code is complete

files = extractFileNames(trainPath);

cellEYST = {};
cellMOST = {};
cellHTST = {};
cellHNST = {};

for iteratorFile = 1 : size(files,1)
    currentFilename = strcat(files(iteratorFile,:), '_band_0_60_notch50_fil.raw');
    currentPath = strcat(trainPath,files(iteratorFile,:),'/');
    %     mkdir(fullfile(path,toSavePath));
    
    rawFilename = erase(currentFilename,'_band_0_60_notch50_fil.raw');
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_readegi(strcat(currentPath,currentFilename), [],[],'auto');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Init'),'gui','on');
    
    
    fid = fopen(strcat(currentPath,files(iteratorFile,:), '_band_0_60_notch50_fil_IMP.txt'),'rt');
    
    inconfig = textscan(fid, '%s %*[:] %s', 'CommentStyle', '%','HeaderLines',5);
    fclose(fid);
    
    EEG = pop_interp(EEG, find(str2double(inconfig{1,2}(1:128)) > 49)', 'spherical');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Interpolated'),'gui','off');
    
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

trainData = {};
trainLabel = [];
% [cellHNST{2}(1,:); cellHNST{2}(1,:)]
for iter = 1 : size(cellEYST,2)
%     tempdata = cellEYST{iter}(:,:) - mean(cellEYST{iter}(:,:),2);
%     tempdata = tempdata/std(tempdata(:));
%     trainData = [trainData; tempdata];
    trainData = [trainData; cellEYST{iter}(:,:)];
end
trainLabel = [trainLabel; repmat('EYST', size(cellEYST,2), 1)];

for iter = 1 : size(cellHNST,2)
%     tempdata = cellHNST{iter}(:,:) - mean(cellHNST{iter}(:,:),2);
%     tempdata = tempdata/std(tempdata(:));
%     trainData = [trainData; tempdata];
    trainData = [trainData; cellHNST{iter}(:,:)];
end
trainLabel = [trainLabel; repmat('HNST', size(cellHNST,2), 1)];


for iter = 1 : size(cellHTST,2)
%     tempdata = cellHTST{iter}(:,:) - mean(cellHTST{iter}(:,:),2);
%     tempdata = tempdata/std(tempdata(:));
%     trainData = [trainData; tempdata];
    trainData = [trainData; cellHTST{iter}(:,:)];
end
trainLabel = [trainLabel; repmat('HTST', size(cellHTST,2), 1)];


for iter = 1 : size(cellMOST,2)
%     tempdata = cellMOST{iter}(:,:) - mean(cellMOST{iter}(:,:),2);
%     tempdata = tempdata/std(tempdata(:));
%     trainData = [trainData; tempdata];
    trainData = [trainData; cellMOST{iter}(:,:)];
end
trainLabel = [trainLabel; repmat('MOST', size(cellMOST,2), 1)];


files = extractFileNames(testPath);

testData = {};
testLabelStruct = {};

for iteratorFile = 1 : size(files,1)
    currentFilename = strcat(files(iteratorFile,:), '_band_0_60_notch50_fil.raw');
    currentPath = strcat(testPath,files(iteratorFile,:),'/');
    %     mkdir(fullfile(path,toSavePath));
    
    rawFilename = erase(currentFilename,'_band_0_60_notch50_fil.raw');
    
    [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
    EEG = pop_readegi(strcat(currentPath,currentFilename), [],[],'auto');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Init'),'gui','on');
    
    
    fid = fopen(strcat(currentPath,files(iteratorFile,:), '_band_0_60_notch50_fil_IMP.txt'),'rt');
    
    inconfig = textscan(fid, '%s %*[:] %s', 'CommentStyle', '%','HeaderLines',5);
    fclose(fid);
    
    EEG = pop_interp(EEG, find(str2double(inconfig{1,2}(1:128)) > 49)', 'spherical');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Interpolated'),'gui','off');
    
    EEG = eeg_checkset( EEG );
    testData{size(testData,2) + 1} = EEG.data(:, EEG.event(2).latency : EEG.event(size(EEG.event,2)-1).latency);
    currentLatency = EEG.event(2).latency;
    for eventIter = 1 : size(EEG.event,2)
        EEG.event(eventIter).latency = EEG.event(eventIter).latency - currentLatency;
    end
    testLabelStruct{size(testLabelStruct,2) + 1} = EEG.event;
end

end
