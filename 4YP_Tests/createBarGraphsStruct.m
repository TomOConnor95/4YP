function [barStruct] = createBarGraphsStruct(preset, nameStrings)

subplotsX = 4;
subplotsY = ceil(length(preset)/ subplotsX);

barStruct = cell(1,length(preset));

ylims = [0,5; 0,4; -0.05,0.05; 0,1.5; 0,1; 0,2; 0,2; 0,2; 0,2; 0,2; 0,2; 0,2];


subplot(subplotsY, subplotsX, 1)
barStruct{1} = bar(reshape(preset{1}, [6,6]), 'stacked');
title(nameStrings{1}, 'FontSize', 15)
l = legend('op1','op2','op3','op4','op5','op6');
l.Location = 'NorthWest';
l.AutoUpdate = 'off';
ylim(ylims(1,:))



for i = 2:length(preset)
    subplot(subplotsY, subplotsX, i)

    barStruct{i} = bar(preset{i});
    title(nameStrings{i}, 'FontSize', 15)
    xlim([0.5,length(preset{i})+0.5])
    ylim(ylims(i,:))

end


end