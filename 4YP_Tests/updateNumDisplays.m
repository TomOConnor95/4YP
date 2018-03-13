function updateNumDisplays(PCAParams, appData)
appData.leftNumDisplays{1}.String = num2str(PCAParams(1,1));
appData.leftNumDisplays{2}.String = num2str(PCAParams(1,2));
appData.leftNumDisplays{3}.String = num2str(PCAParams(1,3));
appData.leftNumDisplays{4}.String = num2str(PCAParams(1,4));

appData.rightNumDisplays{1}.String = num2str(PCAParams(2,1));
appData.rightNumDisplays{2}.String = num2str(PCAParams(2,2));
appData.rightNumDisplays{3}.String = num2str(PCAParams(2,3));
appData.rightNumDisplays{4}.String = num2str(PCAParams(2,4));

appData.leftGlobalNumDisplays{1}.String = num2str(PCAParams(3,1));
appData.leftGlobalNumDisplays{2}.String = num2str(PCAParams(3,2));
appData.leftGlobalNumDisplays{3}.String = num2str(PCAParams(3,3));
appData.leftGlobalNumDisplays{4}.String = num2str(PCAParams(3,4));

appData.rightGlobalNumDisplays{1}.String = num2str(PCAParams(4,1));
appData.rightGlobalNumDisplays{2}.String = num2str(PCAParams(4,2));
appData.rightGlobalNumDisplays{3}.String = num2str(PCAParams(4,3));
appData.rightGlobalNumDisplays{4}.String = num2str(PCAParams(4,4));
end