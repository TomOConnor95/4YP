% Test script for preset blending interface
%close all

%% Initialise Blending UI
appData = ApplicationDataBlendingInterface();

%%
%----------------------------------------------------------%
%----------Choose initial presets--------------------------%
%----------------------------------------------------------%


% selectedIndeces = voronoiSelection('PresetStoreSC.mat', u, nameStrings, typeStrings);

% [presetA, presetB, presetC] = loadPresetsFromStore(selectedIndeces(1),...
%                                                    selectedIndeces(2),...
%                                                    selectedIndeces(3),...
%                                                    'PresetStoreSC.mat');

[presetA, presetB, presetC] = loadPresetsFromStore(20,21,22, 'PresetStoreSC.mat');
      

% presetA = appData.presetStoreVaried(appData.idxSelected(1),:);
% presetB = appData.presetStoreVaried(appData.idxSelected(2),:);
% presetC = appData.presetStoreVaried(appData.idxSelected(3),:);

appData.P = presetGeneratorSCMonteCarloMV(presetA, presetB, presetC, appData);

sendAllStructParamsOverOSC(appData.P.presetA, appData.nameStrings, appData.typeStrings, appData.u);

set(figure(1), 'Visible', 'on')
set(figure(2), 'Visible', 'on')
set(figure(3), 'Visible', 'on')
set(figure(4), 'Visible', 'on')

figure(1)
