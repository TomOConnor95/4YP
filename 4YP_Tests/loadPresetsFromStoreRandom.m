function [presetA, presetB, presetC] = loadPresetsFromStoreRandom(fileName)
%% Open Preset Store
presetRead = matfile(fileName);
numberOfPresets = length(presetRead.presetStore(:,1));

randomOrder = randperm(numberOfPresets);
%% Choose initial preset
presetA = presetRead.presetStore(randomOrder(1),:);
presetB = presetRead.presetStore(randomOrder(2),:);
presetC = presetRead.presetStore(randomOrder(3),:);

end