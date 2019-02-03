function run

rng(123);

path = '/home/hari/Documents/Projects/ProjectArtifacts2018/Data/';
testPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Test/';
trainPath = '/home/hari/Documents/Projects/ProjectArtifacts2018/Train/';
if( exist(testPath, 'dir') )
    rmdir( testPath, 's' );
end
if( exist(trainPath, 'dir') )
    rmdir( trainPath, 's' );
end
mkdir(testPath);
mkdir(trainPath);

files = extractFileNames(path);

perm = randperm(size(files, 1));
files = files(perm,:);

for i = 1 : ceil(size(files, 1)/4)
    mkdir(testPath,files(i,:));
    copyfile([path files(i,:)], [testPath files(i,:)]);
end

for i = ceil(size(files, 1)/4) + 1 : size(files, 1)
    mkdir(trainPath,files(i,:));
    copyfile([path files(i,:)], [trainPath files(i,:)]);
end

logger('Feature: S; topC: 1; thresholdClassWise: -0.5; thresholdSTD: 0');
Main('S', 1, -0.5, 0);
end