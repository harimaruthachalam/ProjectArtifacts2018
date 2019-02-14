function splitFiles(seed, path, trainPath, testPath, testPercent)
% Updated on Feb 11, 2019
% I will update the help once the code is complete

rng(seed);
testPercent = 100 / testPercent;

files = extractFileNames(path);
perm = randperm(size(files, 1));
files = files(perm,:);

testFiles = extractFileNames(testPath);
trainFiles = extractFileNames(trainPath);

newTestFiles = char();

for i = 1 : ceil(size(files, 1)/testPercent)
    newTestFiles(i,:) = files(i,:);
end

newTrainFiles = char();

for i = ceil(size(files, 1)/testPercent) + 1 : size(files, 1)
    j = i - ceil(size(files, 1)/testPercent);
    newTrainFiles(j,:) = files(i,:);
end

if size(testFiles,1) ~= size(newTestFiles,1)
    
    if( exist(testPath, 'dir') )
        rmdir( testPath, 's' );
    end
    mkdir(testPath);
    for i = 1 : size(newTestFiles,1)
        mkdir(testPath,newTestFiles(i,:));
        copyfile([path newTestFiles(i,:)], [testPath newTestFiles(i,:)]);
    end
else
    found = 0;
    for i = 1 : size(newTestFiles,1)
        for j = 1 : size(testFiles,1)
            if strcmp(newTestFiles(i,:), testFiles(j,:))
                found = found + 1;
            end
        end
    end
    if found ~= size(newTestFiles,1)
        rmdir( testPath, 's' );
        for i = 1 : size(newTestFiles,1)
            mkdir(testPath,newTestFiles(i,:));
            copyfile([path newTestFiles(i,:)], [testPath newTestFiles(i,:)]);
        end
    end
    
end


if size(trainFiles,1) ~= size(newTrainFiles,1)
    
    if( exist(trainPath, 'dir') )
        rmdir( trainPath, 's' );
    end
    mkdir(trainPath);
    for i = 1 : size(newTrainFiles,1)
        mkdir(trainPath,newTrainFiles(i,:));
        copyfile([path newTrainFiles(i,:)], [trainPath newTrainFiles(i,:)]);
    end
else
    found = 0;
    for i = 1 : size(newTrainFiles,1)
        for j = 1 : size(trainFiles,1)
            if strcmp(newTrainFiles(i,:), trainFiles(j,:))
                found = found + 1;
            end
        end
    end
    if found ~= size(newTrainFiles,1)
        rmdir( trainPath, 's' );
        for i = 1 : size(newTrainFiles,1)
            mkdir(trainPath,newTrainFiles(i,:));
            copyfile([path newTrainFiles(i,:)], [trainPath newTrainFiles(i,:)]);
        end
    end
    
end






