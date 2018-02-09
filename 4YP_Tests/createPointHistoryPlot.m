function [pointHistoryPlot] = createPointHistoryPlot(appData)
% Creates plot showing the history of the positions clicked on

pointHistoryPlot.vector_tree = tree([0,0]);
pointHistoryPlot.sum_tree = tree([0,0]);

hold off
pointHistoryPlot.plot_tree = tree('clear');
pointHistoryPlot.plot_markers_tree = tree(plot(0,0, 'ro','MarkerSize',25,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback2, 1, appData}, 'PickableParts','all'));

title('Selection Location History')
set(gca,'color',[0.7 0.9 1])
%set(gca,'color',[0.5, 0.5, 0.5])
hold on

pointHistoryPlot.frozenLine = plot([0,0],[0,0],'LineStyle', ':', 'LineWidth', 2, 'Visible', 'off', 'PickableParts','none');
pointHistoryPlot.frozenLineStore = [];
end

