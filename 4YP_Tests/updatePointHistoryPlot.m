function [pointHistoryPlot] = updatePointHistoryPlot(pointHistoryPlot,pointHistory)
        pointHistoryPlot.Line.XData = pointHistory(1,:);
        pointHistoryPlot.Line.YData = pointHistory(2,:);
        pointHistoryPlot.Points.XData = pointHistory(1,:);
        pointHistoryPlot.Points.YData = pointHistory(2,:);
        
        pointHistoryPlot.PointsFirstLast.XData = pointHistory(1,[1,length(pointHistory(1,:))]);
        pointHistoryPlot.PointsFirstLast.YData = pointHistory(2,[1,length(pointHistory(1,:))]);                        
end