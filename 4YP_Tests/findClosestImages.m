function [selectedPresetNumbers] = findClosestImages(img, targetImg, presetArray, numberChosenImages)
% Search all saved presets for closest matches to targetImage

if nargin < 4
    numberChosenImages = 3;
end

squaredErrorSums = zeros(1,length(presetArray(:,1)));
for i = 1:length(presetArray(:,1))
    squaredErrorSums(i) = evaluateFitness(presetArray(i,:), img, targetImg);
end
    
[~,sortIndex] = sort(squaredErrorSums(:),'ascend');

maxIndexes = sortIndex(1:numberChosenImages);  %# Get a linear index into A of the 5 largest values    

selectedPresetNumbers = maxIndexes;
end

