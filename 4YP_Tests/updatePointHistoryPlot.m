function [phPlot] = updatePointHistoryPlot(phPlot, mousePos)
figure(3);
oldIndex = phPlot.index;

%function [newIndex, vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree]...
    %= addNewNodeToTrees(index, value, vector_tree, sum_tree, plot_tree, plot_markers_tree, value_tree, text_tree)

% Add a new data point and update all trees

[phPlot.vector_tree, newIndex] = phPlot.vector_tree.addnode(oldIndex, mousePos');

phPlot.index = newIndex;

phPlot.sum_tree = phPlot.sum_tree.addnode(oldIndex, phPlot.sum_tree.get(oldIndex) + phPlot.vector_tree.get(newIndex));

P1 = phPlot.sum_tree.get(oldIndex);

P2 = phPlot.sum_tree.get(newIndex);

%value_tree = value_tree.addnode(index, rand());

%text_tree = text_tree.addnode(index, text(P2(1), P2(2), ['  ', num2str(value_tree.get(newIndex))], 'PickableParts','none'));

phPlot.plot_tree = phPlot.plot_tree.addnode(oldIndex, plot([P1(1), P2(1)], [P1(2), P2(2)],'b','LineWidth',3, 'PickableParts','none'));

phPlot.plot_markers_tree = phPlot.plot_markers_tree.addnode(oldIndex, plot(P2(1), P2(2), 'ro','MarkerSize',12,'MarkerFaceColor',[0.1,1.0,0.1], 'ButtonDownFcn',{@markerClickedCallback2, newIndex}, 'PickableParts','all'));
%recolour child node
marker = phPlot.plot_markers_tree.get(oldIndex);
marker.MarkerFaceColor = [.8 .6 .6];
phPlot.plot_markers_tree = phPlot.plot_markers_tree.set(oldIndex, marker);
figure(1)
end

% 
%         pointHistoryPlot.Line.XData = pointHistory(1,:);
%         pointHistoryPlot.Line.YData = pointHistory(2,:);
%         pointHistoryPlot.Points.XData = pointHistory(1,:);
%         pointHistoryPlot.Points.YData = pointHistory(2,:);
%         
%         pointHistoryPlot.PointsFirstLast.XData = pointHistory(1,[1,length(pointHistory(1,:))]);
%         pointHistoryPlot.PointsFirstLast.YData = pointHistory(2,[1,length(pointHistory(1,:))]);                        
% end
