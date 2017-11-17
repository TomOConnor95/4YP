function [P] = createPresetsForImageEditing()
% test presets - For image adjust [[low_in; high_in],[low_out;
% high_out],Vignette]
keySetPresets = {'low_in_R','low_in_G','low_in_B', ...
                 'high_in_R','high_in_G','high_in_B',...
                 'low_out_R','low_out_G','low_out_B', ...
                 'high_out_R','high_out_G','high_out_B',...
                 'gamma_R','gamma_G','gamma_B',...
                 'guassian_position','guassian_radius','background_blend_greyscale','foreground_blend_greyscale'};
                 

% initialPresetA = [0.2 0.1 0.0  1.0 0.8 0.9  0.0 0.4 0.2  0.9 0.7 0.8  0.5 0.5 0.5  0.5 1.0 0.2];
% initialPresetB = [0.1 0.2 0.1  0.9 0.8 0.7  0.9 0.9 0.9  0.2 0.1 0.3  0.6 0.6 0.4  0.6 0.8 0.8];
% initialPresetC = [0.3 0.2 0.1  0.8 0.7 0.9  0.2 0.1 0.2  0.7 0.9 0.8  0.3 0.5 0.4  0.4 0.9 0.5];

presetRead = matfile('PresetStore.mat');

initialPresetA = presetRead.presetStore(4,:);
initialPresetB = presetRead.presetStore(5,:);
initialPresetC = presetRead.presetStore(6,:);

% Map container (Not used yet)
P.presetMapA = containers.Map(keySetPresets,initialPresetA);
P.presetMapB = containers.Map(keySetPresets,initialPresetB);
P.presetMapC = containers.Map(keySetPresets,initialPresetC);
    % example usage -- cell2mat(values(presetMap1,{'gamma_R'}))

P.presetA = initialPresetA;
P.presetB = initialPresetB;
P.presetC = initialPresetC;

% Store all past values of the presets in this array
P.presetAHistory = P.presetA;
P.presetBHistory = P.presetB;       % maybe make a cell of the presetMaps??
P.presetCHistory = P.presetC;
