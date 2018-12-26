function [lower, upper] = vad(signal, window, overlap, threshold)
% Updated on Nov 8, 2018
% Returns the signal which crosses VAD threshold

passedWindows = [];

for i = 1 : window - overlap : length(signal)
    lastSample = min(i + window, length(signal));
    if mean(signal(i:lastSample)) > threshold
        passedWindows = [passedWindows; i];
    end
end

lower = min(passedWindows);
upper = min(max(passedWindows) + window, length(signal));

end