function historyPlot = updateStructPresetHistoryPlot(historyPlot,presetHistory)

historyArrays = cell(1, length(presetHistory));
for j = 1:length(presetHistory)
    historyArrays{j} = cell2mat(presetHistory{j}.Node);

    for i=1:length(historyArrays{j}(1,:))
        set(historyPlot{j}{i}, 'XData', 1:length(historyArrays{j}(:,1)),...
                               'YData',historyArrays{j}(:,i));
%         historyPlot{j}{i}.XData = 1:length(historyArrays{j}(:,1));
%         historyPlot{j}{i}.YData = historyArrays{j}(:,i);
    end
    
end 
    %drawnow();
end