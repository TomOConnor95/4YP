function [presetA, presetB, presetC] = loadPresetsFromStoreRandom()
%% Open Preset Store
presetRead = matfile('PresetStore2.mat');
numberOfPresets = length(presetRead.presetStore(:,1));

randomOrder = randperm(numberOfPresets);
%% Choose initial preset
presetA = presetRead.presetStore(randomOrder(1),:);
presetB = presetRead.presetStore(randomOrder(2),:);
presetC = presetRead.presetStore(randomOrder(3),:);

end