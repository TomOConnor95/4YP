function [barA, barB, barC] = updateBarPlots(barA,barB,barC, presetA, presetB,presetC)
        
        barA.YData =presetA;
        barB.YData =presetB;
        barC.YData =presetC;
%         errorBarA.YData = presetA;
%         errorBarA.YNegativeDelta = tempScaling*(tempOffset + std(presetAHistory));
%         errorBarA.YPositiveDelta = tempScaling*(tempOffset + std(presetAHistory));
end