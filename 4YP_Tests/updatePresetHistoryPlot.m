function historyPlot = updatePresetHistoryPlot(historyPlot,presetHistory)

historyArray = cell2mat(presetHistory.Node);

    for i=1:length(historyArray(1,:))
        historyPlot{i}.XData = 1:length(historyArray(:,1));
        historyPlot{i}.YData = historyArray(:,i);
    end
   

end