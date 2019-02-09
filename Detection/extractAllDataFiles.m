function [testData, testLabelStruct] = extractAllDataFiles(path)
% Updated on Jan 31, 2019
% I will update the help once the code is complete

files = extractFileNames(path);

testData = {};
testLabelStruct = {};

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
    
    EEG = pop_interp(EEG, find(str2double(inconfig{1,2}(1:128)) > 49)', 'spherical');
    [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Interpolated'),'gui','off');
    
    EEG = eeg_checkset( EEG );
    testData{size(testData,2) + 1} = EEG.data(:, EEG.event(2).latency : EEG.event(size(EEG.event,2)-1).latency) - mean(EEG.data(:, EEG.event(2).latency : EEG.event(size(EEG.event,2)-1).latency),2);
    currentLatency = EEG.event(2).latency;
    for eventIter = 1 : size(EEG.event,2)
        EEG.event(eventIter).latency = EEG.event(eventIter).latency - currentLatency;
    end
    testLabelStruct{size(testLabelStruct,2) + 1} = EEG.event;
end

end
