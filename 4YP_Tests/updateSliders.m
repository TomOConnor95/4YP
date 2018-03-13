function updateSliders(PCAParams, appData)
appData.leftSliders{1}.Value = PCAParams(1,1);
appData.leftSliders{2}.Value = PCAParams(1,2);
appData.leftSliders{3}.Value = PCAParams(1,3);
appData.leftSliders{4}.Value = PCAParams(1,4);

appData.rightSliders{1}.Value = PCAParams(2,1);
appData.rightSliders{2}.Value = PCAParams(2,2);
appData.rightSliders{3}.Value = PCAParams(2,3);
appData.rightSliders{4}.Value = PCAParams(2,4);

appData.leftGlobalSliders{1}.Value = PCAParams(3,1);
appData.leftGlobalSliders{2}.Value = PCAParams(3,2);
appData.leftGlobalSliders{3}.Value = PCAParams(3,3);
appData.leftGlobalSliders{4}.Value = PCAParams(3,4);

appData.rightGlobalSliders{1}.Value = PCAParams(4,1);
appData.rightGlobalSliders{2}.Value = PCAParams(4,2);
appData.rightGlobalSliders{3}.Value = PCAParams(4,3);
appData.rightGlobalSliders{4}.Value = PCAParams(4,4);
end