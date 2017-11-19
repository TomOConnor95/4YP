function [pointHistoryPlot] = createPointHistoryPlot()
% Creates plot showing the history of the positions clicked on

pointHistoryPlot.vector_tree = tree([0,0]);
pointHistoryPlot.sum_tree = tree([0,0]);
%pointHistoryPlot.value_tree = tree(rand());
%pointHistoryPlot.text_tree = tree(text(0.0 + 0.1, 0.0, num2str(value_tree.get(1)), 'PickableParts','none'));

hold off
pointHistoryPlot.plot_tree = tree('clear');
pointHistoryPlot.plot_markers_tree = tree(plot(0,0, 'ro','MarkerSize',25,'MarkerFaceColor',[.8 .6 .6], 'ButtonDownFcn',{@markerClickedCallback2, 1}, 'PickableParts','all'));
%pointHistoryPlot.index = 1;

title('Selection Location History')
set(gca,'color',[0.7 0.9 1])
hold on
end



% if length(pointHistory(1,:)) == 1
%     pointHistory = [pointHistory,pointHistory];
% end
% 
% hold off
% pointHistoryPlot.Line = plot(pointHistory(1,:),pointHistory(2,:),'LineWidth',3);
% hold on
% pointHistoryPlot.Points = plot(pointHistory(1,:),pointHistory(2,:),...
%                                         'ro','MarkerSize',7,'MarkerFaceColor',[.8 .6 .6]);
%                                     
% pointHistoryPlot.PointsFirstLast = plot(pointHistory(1,[1,length(pointHistory(1,:))]),...
%                                         pointHistory(2,[1,length(pointHistory(1,:))]),...
%                                         'ro','MarkerSize',10,'MarkerFaceColor',[1 .6 .6]);
% 
%                                     
