function [barA, barB, barC, barMix] = createBarGraphs(presetA, presetB, presetC)

%create bar graphs
alpha = 1; beta = 0; gamma = 0;

subplot(2,7,8)
barA = bar(presetA);
ylim([0,1])
title('PresetA')
% hold on
% errorBarA = errorbar(1:length(presetA),presetA,zeros(1,length(presetA)),'.');
% hold off

subplot(2,7,9)
barB = bar(presetB);
ylim([0,1])
title('PresetB')

subplot(2,7,10)
barC = bar(presetC);
ylim([0,1])
title('PresetC')

subplot(2,7,[1,2,3])
presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
barMix = bar(presetMix,'r');
title('Blended Preset')
ylim([0,1])

end