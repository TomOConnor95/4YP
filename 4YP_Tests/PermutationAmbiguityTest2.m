% A test whether correcting for permutation ambiguity decreases the overal
% parameter cost between all sets of presets.

presetRead = matfile('PresetStoreSC.mat');
numPresets = length(presetRead.presetStore(:,1));

preset1 = presetRead.presetStore(1,:);
presetLengths = zeros(1,12);
for i = 1:length(preset1)
    presetLengths(i) = length(preset1{i});
end
presetLengthSum = [0, cumsum(presetLengths)];
totalPresetLength = presetLengthSum(end);

presetStoreOriginal = presetRead.presetStore;

%% Correct permutation ambiguity

% permute the operators such that the output levels are in decreasing order
presetStorePermuted = presetStoreOriginal;
for i = 1:numPresets
    [sortedOutputLevels, indeces] = sort(presetStoreOriginal{i,4}, 2, 'descend');
    
    %newOrder = [indeces(1), setdiff(1:6,indeces(1))];
    %newOrder = 1:6;
    %newOrder = [1,2,3,4,6,5];
    newOrder = indeces;
    
    PMParams = reshape(presetStoreOriginal{i,1},6,6);
    PMParamsPermuted = PMParams(newOrder,newOrder);
    
    presetStorePermuted{i,1} = reshape(PMParamsPermuted',1,36)';
    presetStorePermuted{i,2} = presetStoreOriginal{i,2}(newOrder);
    presetStorePermuted{i,3} = presetStoreOriginal{i,3}(newOrder);
    presetStorePermuted{i,4} = presetStoreOriginal{i,4}(newOrder);
    presetStorePermuted{i,5} = presetStoreOriginal{i,5}(newOrder);
    presetStorePermuted{i,6} = presetStoreOriginal{i,6}(newOrder);
    presetStorePermuted{i,7} = presetStoreOriginal{i,7}(newOrder);
    
end


