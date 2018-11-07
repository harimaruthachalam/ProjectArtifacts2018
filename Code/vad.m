function [signal] = vad(signal, window, overlap, threshold)
% Updated on Nov 7, 2018
% Returns the signal which crosses VAD threshold

passedWindows = [];

for i = 1 : window - overlap : length(signal)
    lastSample = min(i + window, length(signal))
    if mean(signal(i:lastSample)) > threshold
        passedWindows = [passedWindows; i];
    end
end

signal = signal(min(passedWindows) : min(max(passedWindows) + window, length(signal)));

end