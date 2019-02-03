function [trainData, trainLabel, testData, testLabel] = extractDataFiles(seed, trainPath, testPath, dataFromPool, applyVAD, thresholdSTD, VADWindow, VADOverlap, feature, standandize, interpolate, trainPercent)
% Updated on Jan 11, 2019
% I will update the help once the code is complete

rng(seed)
if dataFromPool == true
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
        
        if interpolate == true
            EEG = pop_interp(EEG, find(str2double(inconfig{1,2}(1:128)) > 49)', 'spherical');
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Interpolated'),'gui','off');
        end
        EEG = eeg_checkset( EEG );
        if feature == 'M'
            EEG.data = movmean(EEG.data, 100);
        elseif feature == 'D'
            EEG.data = diff(EEG.data,1,2);
        elseif feature == 'DM'
            EEG.data = movmean(EEG.data, 100);
            EEG.data = diff(EEG.data,1,2);
        end
        
        EEG = pop_epoch( EEG, { 'EYST' }, [0 3], 'newname', strcat(rawFilename, ' Eye Open and Close'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        EEG = eeg_checkset( EEG );
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'EYST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            cellEYST{size(cellEYST,2) + 1} = data;
        end
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0);
        EEG = eeg_checkset( EEG );
        
        EEG = pop_epoch( EEG, {  'MOST'  }, [0  3], 'newname', strcat(rawFilename, ' Mouth Open and Close'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        EEG = eeg_checkset( EEG );
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'MOST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            cellMOST{size(cellMOST,2) + 1} = data;
        end
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0);
        EEG = eeg_checkset( EEG );
        EEG = pop_epoch( EEG, {  'HTST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Turn'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'HTST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            cellHTST{size(cellHTST,2) + 1} = data;
        end
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',1,'study',0);
        EEG = eeg_checkset( EEG );
        EEG = pop_epoch( EEG, {  'HNST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Nod'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        EEG = eeg_checkset( EEG );
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'HNST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            cellHNST{size(cellHNST,2) + 1} = data;
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
    
    testPercent = 100 - trainPercent;
    
    testCellHNST = cellHNST(1 : ceil(size(cellHNST,2) * (testPercent/100)));
    testCellEYST = cellEYST(1 : ceil(size(cellEYST,2) * (testPercent/100)));
    testCellHTST = cellHTST(1 : ceil(size(cellHTST,2) * (testPercent/100)));
    testCellMOST = cellMOST(1 : ceil(size(cellMOST,2) * (testPercent/100)));
    
    cellEYST = cellEYST(ceil(size(cellEYST,2) * (testPercent/100)) + 1 : end);
    cellHNST = cellHNST(ceil(size(cellHNST,2) * (testPercent/100)) + 1 : end);
    cellHTST = cellHTST(ceil(size(cellHTST,2) * (testPercent/100)) + 1 : end);
    cellMOST = cellMOST(ceil(size(cellMOST,2) * (testPercent/100)) + 1 : end);
    
    
    
    trainData = {};
    trainLabel = [];
    % [cellHNST{2}(1,:); cellHNST{2}(1,:)]
    for iter = 1 : size(cellEYST,2)
        if standandize == true
            tempdata = cellEYST{iter}(:,:) - mean(cellEYST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            trainData = [trainData; tempdata];
        else
            trainData = [trainData; cellEYST{iter}(:,:) - mean(cellEYST{iter}(:,:),2)];
        end
    end
    trainLabel = [trainLabel; repmat('EYST', size(cellEYST,2), 1)];
    
    for iter = 1 : size(cellHNST,2)
        if standandize == true
            tempdata = cellHNST{iter}(:,:) - mean(cellHNST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            trainData = [trainData; tempdata];
        else
            trainData = [trainData; cellHNST{iter}(:,:) - mean(cellHNST{iter}(:,:),2)];
        end
    end
    trainLabel = [trainLabel; repmat('HNST', size(cellHNST,2), 1)];
    
    
    for iter = 1 : size(cellHTST,2)
        if standandize == true
            tempdata = cellHTST{iter}(:,:) - mean(cellHTST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            trainData = [trainData; tempdata];
        else
            trainData = [trainData; cellHTST{iter}(:,:) - mean(cellHTST{iter}(:,:),2)];
        end
    end
    trainLabel = [trainLabel; repmat('HTST', size(cellHTST,2), 1)];
    
    
    
    
    for iter = 1 : size(cellMOST,2)
        if standandize == true
            tempdata = cellMOST{iter}(:,:) - mean(cellMOST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            trainData = [trainData; tempdata];
        else
            trainData = [trainData; cellMOST{iter}(:,:) - mean(cellMOST{iter}(:,:),2)];
        end
    end
    trainLabel = [trainLabel; repmat('MOST', size(cellMOST,2), 1)];
    
    
    
    testData = {};
    testLabel = [];
    
    
    for iter = 1 : size(testCellEYST,2)
        if standandize == true
            tempdata = testCellEYST{iter}(:,:) - mean(testCellEYST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            testData = [testData; tempdata];
        else
            testData = [testData; testCellEYST{iter}(:,:) - mean(testCellEYST{iter}(:,:),2)];
        end
    end
    testLabel = [testLabel; repmat('EYST', size(testCellEYST,2), 1)];
    
    for iter = 1 : size(testCellHNST,2)
        if standandize == true
            tempdata = testCellHNST{iter}(:,:) - mean(testCellHNST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            testData = [testData; tempdata];
        else
            testData = [testData; testCellHNST{iter}(:,:) - mean(testCellHNST{iter}(:,:),2)];
        end
    end
    testLabel = [testLabel; repmat('HNST', size(testCellHNST,2), 1)];
    
    
    for iter = 1 : size(testCellHTST,2)
        if standandize == true
            tempdata = testCellHTST{iter}(:,:) - mean(testCellHTST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            testData = [testData; tempdata];
        else
            testData = [testData; testCellHTST{iter}(:,:) - mean(testCellHTST{iter}(:,:),2)];
        end
    end
    testLabel = [testLabel; repmat('HTST', size(testCellHTST,2), 1)];
    
    
    for iter = 1 : size(testCellMOST,2)
        if standandize == true
            tempdata = testCellMOST{iter}(:,:) - mean(testCellMOST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            testData = [testData; tempdata];
        else
            testData = [testData; testCellMOST{iter}(:,:) - mean(testCellMOST{iter}(:,:),2)];
        end
    end
    testLabel = [testLabel; repmat('MOST', size(testCellMOST,2), 1)];
    
else
    
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
        
        if interpolate == true
            EEG = pop_interp(EEG, find(str2double(inconfig{1,2}(1:128)) > 49)', 'spherical');
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Interpolated'),'gui','off');
        end
        EEG = eeg_checkset( EEG );
        if feature == 'M'
            EEG.data = movmean(EEG.data, 100);
        elseif feature == 'D'
            EEG.data = diff(EEG.data,1,2);
        elseif feature == 'DM'
            EEG.data = movmean(EEG.data, 100);
            EEG.data = diff(EEG.data,1,2);
        end
        
        EEG = pop_epoch( EEG, { 'EYST' }, [0 3], 'newname', strcat(rawFilename, ' Eye Open and Close'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        EEG = eeg_checkset( EEG );
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'EYST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            cellEYST{size(cellEYST,2) + 1} = data;
        end
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0);
        EEG = eeg_checkset( EEG );
        
        EEG = pop_epoch( EEG, {  'MOST'  }, [0  3], 'newname', strcat(rawFilename, ' Mouth Open and Close'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        EEG = eeg_checkset( EEG );
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'MOST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            cellMOST{size(cellMOST,2) + 1} = data;
        end
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0);
        EEG = eeg_checkset( EEG );
        EEG = pop_epoch( EEG, {  'HTST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Turn'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'HTST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            cellHTST{size(cellHTST,2) + 1} = data;
        end
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',1,'study',0);
        EEG = eeg_checkset( EEG );
        EEG = pop_epoch( EEG, {  'HNST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Nod'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        EEG = eeg_checkset( EEG );
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'HNST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            cellHNST{size(cellHNST,2) + 1} = data;
        end
    end
    
    trainData = {};
    trainLabel = [];
    % [cellHNST{2}(1,:); cellHNST{2}(1,:)]
    for iter = 1 : size(cellEYST,2)
        if standandize == true
            tempdata = cellEYST{iter}(:,:) - mean(cellEYST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            trainData = [trainData; tempdata];
        else
            trainData = [trainData; cellEYST{iter}(:,:) - mean(cellEYST{iter}(:,:),2)];
        end
    end
    trainLabel = [trainLabel; repmat('EYST', size(cellEYST,2), 1)];
    
    for iter = 1 : size(cellHNST,2)
        if standandize == true
            tempdata = cellHNST{iter}(:,:) - mean(cellHNST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            trainData = [trainData; tempdata];
        else
            trainData = [trainData; cellHNST{iter}(:,:) - mean(cellHNST{iter}(:,:),2)];
        end
    end
    trainLabel = [trainLabel; repmat('HNST', size(cellHNST,2), 1)];
    
    
    for iter = 1 : size(cellHTST,2)
        if standandize == true
            tempdata = cellHTST{iter}(:,:) - mean(cellHTST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            trainData = [trainData; tempdata];
        else
            trainData = [trainData; cellHTST{iter}(:,:) - mean(cellHTST{iter}(:,:),2)];
        end
    end
    trainLabel = [trainLabel; repmat('HTST', size(cellHTST,2), 1)];
    
    
    
    
    for iter = 1 : size(cellMOST,2)
        if standandize == true
            tempdata = cellMOST{iter}(:,:) - mean(cellMOST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            trainData = [trainData; tempdata];
        else
            trainData = [trainData; cellMOST{iter}(:,:) - mean(cellMOST{iter}(:,:),2)];
        end
    end
    trainLabel = [trainLabel; repmat('MOST', size(cellMOST,2), 1)];
    
    
    
    files = extractFileNames(testPath);
    
    testCellEYST = {};
    testCellMOST = {};
    testCellHTST = {};
    testCellHNST = {};
    
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
        
        if interpolate == true
            EEG = pop_interp(EEG, find(str2double(inconfig{1,2}(1:128)) > 49)', 'spherical');
            [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 0,'setname',strcat(rawFilename, ' Interpolated'),'gui','off');
        end
        EEG = eeg_checkset( EEG );
        if feature == 'M'
            EEG.data = movmean(EEG.data, 100);
        elseif feature == 'D'
            EEG.data = diff(EEG.data,1,2);
        elseif feature == 'DM'
            EEG.data = movmean(EEG.data, 100);
            EEG.data = diff(EEG.data,1,2);
        end
        
        EEG = pop_epoch( EEG, { 'EYST' }, [0 3], 'newname', strcat(rawFilename, ' Eye Open and Close'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        EEG = eeg_checkset( EEG );
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'EYST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            testCellEYST{size(testCellEYST,2) + 1} = data;
        end
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0);
        EEG = eeg_checkset( EEG );
        
        EEG = pop_epoch( EEG, {  'MOST'  }, [0  3], 'newname', strcat(rawFilename, ' Mouth Open and Close'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        EEG = eeg_checkset( EEG );
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'MOST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            testCellMOST{size(testCellMOST,2) + 1} = data;
        end
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 3,'retrieve',1,'study',0);
        EEG = eeg_checkset( EEG );
        EEG = pop_epoch( EEG, {  'HTST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Turn'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'HTST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            testCellHTST{size(testCellHTST,2) + 1} = data;
        end
        
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 4,'retrieve',1,'study',0);
        EEG = eeg_checkset( EEG );
        EEG = pop_epoch( EEG, {  'HNST'  }, [0  3], 'newname', strcat(rawFilename, ' Head Nod'), 'epochinfo', 'yes');
        [ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'gui','off');
        EEG = eeg_checkset( EEG );
        
        for iterEpoch = 1 : EEG.trials
            if applyVAD == 1
                [lower, upper] = findThresholdLimit(EEG.data(:,:,iterEpoch), 'HNST', thresholdSTD);
                %                 [lower, upper] = vad(sum(abs(EEG.data(:,:,iterEpoch)),1), VADWindow, VADOverlap, mean(sum(abs(EEG.data(:,:,iterEpoch)))) - 0 * std(sum(abs(EEG.data(:,:,iterEpoch)))) );
                data = EEG.data(:,lower:upper,iterEpoch);
            else
                data = EEG.data(:,:,iterEpoch);
            end
            testCellHNST{size(testCellHNST,2) + 1} = data;
        end
    end
    
    
    testData = {};
    testLabel = [];
    
    
    for iter = 1 : size(testCellEYST,2)
        if standandize == true
            tempdata = testCellEYST{iter}(:,:) - mean(testCellEYST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            testData = [testData; tempdata];
        else
            testData = [testData; testCellEYST{iter}(:,:) - mean(testCellEYST{iter}(:,:),2)];
        end
    end
    testLabel = [testLabel; repmat('EYST', size(testCellEYST,2), 1)];
    
    for iter = 1 : size(testCellHNST,2)
        if standandize == true
            tempdata = testCellHNST{iter}(:,:) - mean(testCellHNST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            testData = [testData; tempdata];
        else
            testData = [testData; testCellHNST{iter}(:,:) - mean(testCellHNST{iter}(:,:),2)];
        end
    end
    testLabel = [testLabel; repmat('HNST', size(testCellHNST,2), 1)];
    
    
    for iter = 1 : size(testCellHTST,2)
        if standandize == true
            tempdata = testCellHTST{iter}(:,:) - mean(testCellHTST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            testData = [testData; tempdata];
        else
            testData = [testData; testCellHTST{iter}(:,:) - mean(testCellHTST{iter}(:,:),2)];
        end
    end
    testLabel = [testLabel; repmat('HTST', size(testCellHTST,2), 1)];
    
    
    for iter = 1 : size(testCellMOST,2)
        if standandize == true
            tempdata = testCellMOST{iter}(:,:) - mean(testCellMOST{iter}(:,:),2);
            tempdata = tempdata/std(tempdata(:));
            testData = [testData; tempdata];
        else
            testData = [testData; testCellMOST{iter}(:,:) - mean(testCellMOST{iter}(:,:),2)];
        end
    end
    testLabel = [testLabel; repmat('MOST', size(testCellMOST,2), 1)];
    
end

end
