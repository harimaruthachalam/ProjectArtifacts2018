for iter = 1 : length(result)
    [uniqueStrings, ~, stringMap] = unique(string(result{iter}(1 : topC,:)));
    mostCommonString{iter} = uniqueStrings(mode(stringMap));
    if mostCommonString{iter} == string(testLabel(iter,:))
        result{iter} = {};
    end
end