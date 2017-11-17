function [presetA, presetB, presetC] = loadPresetsFromStore(numA, numB, numC)
%% Open Preset Store
presetRead = matfile('PresetStore2.mat');

%% Choose initial preset
presetA = presetRead.presetStore(numA,:);
presetB = presetRead.presetStore(numB,:);
presetC = presetRead.presetStore(numC,:);

end