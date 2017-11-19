function [historyPlot] = createStructHistoryPlot(presetAHistory)
hold off

historyPlot = cell(1,length(presetAHistory));
for j = 1: length(presetAHistory)
    historyArray = cell2mat(presetAHistory{j}.Node);

    historyPlot{j} = cell(1,length(historyArray(1,:)));
    for i=1:length(historyArray(1,:))
        if length(historyArray(:,1)) == 1
            historyPlot{j}{i} = plot([historyArray(:,i),historyArray(:,i)]);   %ensures enough points to plot lines
        else
            historyPlot{j}{i} = plot(historyArray(:,i));    
        end
        hold on
    end
end
hold off
title('Preset History')