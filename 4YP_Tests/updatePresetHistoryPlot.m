function historyPlot = updatePresetHistoryPlot(historyPlot,presetHistory)

    for i=1:length(presetHistory(1,:))
        historyPlot{i}.XData = 1:length(presetHistory(:,1));
        historyPlot{i}.YData = presetHistory(:,i);
    end
end