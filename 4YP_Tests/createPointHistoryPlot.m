function [pointHistoryPlot] = createPointHistoryPlot(pointHistory)
% Creates plot showing the history of the positions clicked on

if length(pointHistory(1,:)) == 1
    pointHistory = [pointHistory,pointHistory];
end

hold off
pointHistoryPlot.Line = plot(pointHistory(1,:),pointHistory(2,:),'LineWidth',3);
hold on
pointHistoryPlot.Points = plot(pointHistory(1,:),pointHistory(2,:),...
                                        'ro','MarkerSize',7,'MarkerFaceColor',[.8 .6 .6]);
                                    
pointHistoryPlot.PointsFirstLast = plot(pointHistory(1,[1,length(pointHistory(1,:))]),...
                                        pointHistory(2,[1,length(pointHistory(1,:))]),...
                                        'ro','MarkerSize',10,'MarkerFaceColor',[1 .6 .6]);

title('Selection Location History')
set(gca,'color',[0.7 0.9 1])
hold off
end