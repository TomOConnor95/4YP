
midiControls = cell(1,8);
for i = 1:8
    midiControls{i} = midicontrols(i, 'MIDIDevice', 'IAC Driver Bus 1');
    functionHandle = @(x)midiCallback(x,i, appData);
    midicallback(midiControls{i},functionHandle);
end

function midiCallback(midicontrolsObject, idx, appData)

midiCC = midiread(midicontrolsObject);
 disp([num2str(idx), ': ', num2str(midiCC)])

 appData.leftSliders{idx}.Value = (midiCC * 10) - 5;
 
 appData.leftNumDisplays{idx}.String = num2str(appData.leftSliders{idx}.Value);

storeLeftSliderPosition(appData)

updatePCAWeightsAndSendParams(appData)

updatePresetVariedMarker(appData)

% Update Timbre Plots
appData.timbreData = timbrePlotDataFromPreset(appData.presetStoreVaried(appData.idxCurrent,:));
appData.timbrePlots = updateTimbrePlots(appData.timbrePlots, appData.timbreData); 

dispstat(sprintf(preset2string(appData.presetStoreVaried(appData.idxCurrent, :),...
                                appData.nameStrings)));
 
end

