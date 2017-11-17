function [historyPlot] = createHistoryPlot(presetAHistory)
hold off
historyPlot = cell(1,length(presetAHistory(1,:)));
for i=1:length(presetAHistory(1,:))
    if length(presetAHistory(:,1)) == 1
        historyPlot{i} = plot([presetAHistory(:,i),presetAHistory(:,i)]);   %ensures enough points to plot lines
    else
        historyPlot{i} = plot(presetAHistory(:,i));    
    end
    hold on
end
hold off
title('Preset History')