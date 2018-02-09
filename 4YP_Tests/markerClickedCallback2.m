function markerClickedCallback2(~,~, index, appData)

disp(['Index: ',num2str(index), ' CLICKED']);
appData.markerIndex = index;

appData.P = appData.P.switchPresets(appData.markerIndex);
sendAllStructParamsOverOSC(appData.P.presetA, appData.nameStrings, appData.typeStrings, appData.u);
dispstat(sprintf(preset2string(appData.P.presetA, appData.nameStrings)));

[appData.P, appData.presetsDoubleClicked] = testForDoubleClicks(appData.P, appData.presetsDoubleClicked, appData.currentMarkerIndex, appData.markerIndex);

if length(appData.presetsDoubleClicked) >2
    
    appData.P = setMarkerFaceColours(appData.P, appData.presetsDoubleClicked, [0.8, 0.6, 0.6]);
    
    appData.P = appData.P.combineSelectedPresets(appData.presetsDoubleClicked);
    
    appData.presetsDoubleClicked = [];
    appData.currentMarkerIndex = 0;
    
elseif ~isempty(appData.presetsDoubleClicked)
    appData.P = setMarkerFaceColours(appData.P, appData.presetsDoubleClicked, [0,1,0]);
end

appData.currentMarkerIndex = appData.markerIndex;



end