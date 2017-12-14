function [presetA, presetB, presetC] = loadPresetsFromStore(numA, numB, numC, storeString)
%% Open Preset Store
if nargin <4
    presetRead = matfile('PresetStore2.mat');
else
    presetRead = matfile(storeString);
end

%% Choose initial preset
presetA = presetRead.presetStore(numA,:);
presetB = presetRead.presetStore(numB,:);
presetC = presetRead.presetStore(numC,:);

end