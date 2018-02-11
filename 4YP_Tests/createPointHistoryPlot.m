function [pointHistoryPlot] = createPointHistoryPlot(appData)
% Creates plot showing the history of the positions clicked on

appData.phAxes = axes('position',[0.025,0.15,0.95,0.8],...
        'Units','Normalized',...
        'XGrid','off',...
        'XMinorGrid','off',...
        'XTickLabel',[],...
        'YTickLabel',[],...
        'XTick',[],...
        'YTick',[]);

pointHistoryPlot.vector_tree = tree([0,0]);
pointHistoryPlot.sum_tree = tree([0,0]);

hold off
pointHistoryPlot.plot_tree = tree('clear');
pointHistoryPlot.plot_markers_tree = tree(plot(appData.phAxes, 0,0, 'ro','MarkerSize',25,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback2, 1, appData}, 'PickableParts','all'));

title('Selection Location History')
set(gca,'color',[0.7 0.9 1])
% set(gca,'YTickLabel',[])
% set(gca,'XTickLabel',[])
%set(gca,'color',[0.5, 0.5, 0.5])
hold on

pointHistoryPlot.frozenLine = plot(appData.phAxes, [0,0],[0,0],'LineStyle', ':', 'LineWidth', 2, 'Visible', 'off', 'PickableParts','none');
pointHistoryPlot.frozenLineStore = [];
end

