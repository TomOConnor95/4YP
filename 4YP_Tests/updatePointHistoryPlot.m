function [phPlot] = updatePointHistoryPlot(phPlot, mousePos, oldIndex, newIndex)
figure(3);

phPlot.vector_tree = phPlot.vector_tree.addnode(oldIndex, mousePos');

phPlot.sum_tree = phPlot.sum_tree.addnode(oldIndex, phPlot.sum_tree.get(oldIndex) + phPlot.vector_tree.get(newIndex));


P1 = phPlot.sum_tree.get(oldIndex);
P2 = phPlot.sum_tree.get(newIndex);


phPlot.plot_tree = phPlot.plot_tree.addnode(oldIndex, plot([P1(1), P2(1)], [P1(2), P2(2)], 'Color', [0.4,0.5,0.9,0.5],'LineWidth', 3, 'PickableParts','none'));

phPlot.plot_markers_tree = phPlot.plot_markers_tree.addnode(oldIndex, plot(P2(1), P2(2), 'ro','MarkerSize',12,'MarkerFaceColor',[0.1,1.0,0.1], 'ButtonDownFcn',{@markerClickedCallback2, newIndex}, 'PickableParts','all'));

%recolour child node
marker = phPlot.plot_markers_tree.get(oldIndex);
marker.MarkerFaceColor = [.8 .6 .6];
phPlot.plot_markers_tree = phPlot.plot_markers_tree.set(oldIndex, marker);
figure(1)
end

