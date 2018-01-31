% Parameters
presetRead = matfile('PresetStoreSC.mat');
presetStore = presetRead.presetStore;

presetNo = 4;

preset = presetStore(presetNo,:);


Tdata = timbrePlotDataFromPreset(preset);
Tplots = createAllTimbrePlots(Tdata);

%% Change to different preset

presetNo = 6;

preset = presetStore(presetNo,:);

Tdata = timbrePlotDataFromPreset(preset);
Tplots = updateTimbrePlots(Tplots, Tdata);



