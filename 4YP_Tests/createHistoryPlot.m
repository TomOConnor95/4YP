function [historyPlot] = createHistoryPlot(presetAHistory)
hold off
historyArray = cell2mat(presetAHistory.Node);

historyPlot = cell(1,length(historyArray(1,:)));
for i=1:length(historyArray(1,:))
    if length(historyArray(:,1)) == 1
        historyPlot{i} = plot([historyArray(:,i),historyArray(:,i)]);   %ensures enough points to plot lines
    else
        historyPlot{i} = plot(historyArray(:,i));    
    end
    hold on
end
hold off
title('Preset History')