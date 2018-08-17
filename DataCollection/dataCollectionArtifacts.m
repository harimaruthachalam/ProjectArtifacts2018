function dataCollectionArtifacts
% Hari Maruthachalam - Updated on Aug 17, 2018
% dataCollectionArtifacts is a matlab code for collecting data for
% artifacts.
% Detailed description will be provided later.
% -----------------------------------------------------------------------
% Following are the event codes used in the data collection
% SBLS - Start BaseLine Start
% SBLE - Start BaseLine End
% EYST - Eye Open Start
% EYED - Eye Open End
% HNST - Head Nod Start
% HNED - Head Nod End
% HTST - Head Turn Start
% HTED - Head Turn End
% MOST - Mouth Open Start
% MOED - Mouth Open End
% LTCK - Left Click
% EBLS - End BaseLine Start
% EBLE - End BaseLine End

close all;
clear;
clc;

%% Configurations
isTestRun = 1;
numTrials = 2;
baseLinePause = 3; % in seconds
answerPause= 3;
ipAddress = '10.10.10.42';
mediaDirPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Media';
mediaFiles = dir(mediaDirPath);

%% Prepocessing
index = 0;
tempFiles = cell(1);
for iter = 1 : length(mediaFiles)
    if endsWith(mediaFiles(iter).name, 'wav')
        index = index + 1;
        tempFiles{index} = mediaFiles(iter).name;
    end
end
mediaFiles = tempFiles;
pattern = 1 : index;

%% Gloabal Variables
global button;

%% Setup Check
disp('Check the followings');
pause;
disp('Net Station is ready');
pause;
disp('IP is pinging');
pause;
disp('Ear phone is connected properly');
pause;
disp('Subject is ready');
pause;
disp('Enter to Start!');
pause;

%% Beep producee
beepLength = 0 : 4047;
fs = 8192;
freq = 300;
beepSampleTime = 1 / fs ;
beepSound = cos(2 * pi * freq * beepLength * beepSampleTime);
beepDuration = length(beepLength) / fs;

%% NetStation Connection
if isTestRun == 0
    NetStation('Connect', ipAddress);
    NetStation('StartRecording');
    NetStation('Synchronize');
end

%% Baseline
disp('Recording Starts...');
disp('Start Baseline...');
if isTestRun == 0
    NetStation('Event','SBLS');
end
pause(baseLinePause);
if isTestRun == 0
    NetStation('Event','SBLE');
end

%% Data Collection
for iter=1:numTrials
    clc;
    disp(strcat(num2str(iter),' Trial starts'));
    randomSeq = pattern(randperm(length(pattern)));
    for innerIter=1:size(pattern,2)
        soundsc(beepSound);
        pause(beepDuration);
        disp(strcat(char(mediaFiles(randomSeq(innerIter))),' Playing'));
        [startEvent, endEvent] = fetchEvents(mediaFiles(randomSeq(innerIter)));
        [audioSamples,Fs] = audioread(fullfile(mediaDirPath, char(mediaFiles(randomSeq(innerIter)))));
        player = audioplayer(audioSamples,Fs);
        player.play;
        pause(size(audioSamples,1)/Fs);
        if isTestRun == 0
            NetStation('Event',startEvent);
        end
        button = [];
        mouseEventListener;
        pause(answerPause);
        if ~isempty(button) && ~isempty(button{1})
            if strcmp(button{1},'normal')
                disp('Subject clicked');
                if isTestRun == 0
                    NetStation('Event','LTCK');
                end
            end
        else
            close;
        end
        if isTestRun == 0
            NetStation('Event',endEvent);
        end
    end
end

%% End Baseline
disp('End Baseline...');
if isTestRun == 0
    NetStation('Event','EBLS');
end
pause(baseLinePause);
if isTestRun == 0
    NetStation('Event','EBLE');
    NetStation('StopRecording');
    NetStation('Disconnect');
end
end

function [startEvent, endEvent] = fetchEvents(filename)
if strcmpi(filename, 'speechEye.wav')
    startEvent = 'EYST';
    endEvent = 'EYED';
elseif strcmpi(filename, 'speechHeadNod.wav')
    startEvent = 'HNST';
    endEvent = 'HNED';
elseif strcmpi(filename, 'speechHeadTurn.wav')
    startEvent = 'HTST';
    endEvent = 'HTED';
elseif strcmpi(filename, 'speechMouth.wav')
    startEvent = 'MOST';
    endEvent = 'MOED';
end
end