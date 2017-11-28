function [phPlot] = updatePointHistoryPlotCombinePresets(phPlot, oldIndex, newIndex, presetsDoubleClicked)
figure(3);
lineColour = 'g';

phPlot.vector_tree = phPlot.vector_tree.addnode(oldIndex, [0,0]);

phPlot.sum_tree = phPlot.sum_tree.addnode(oldIndex, (phPlot.sum_tree.get(presetsDoubleClicked(1)) +...
                                                     phPlot.sum_tree.get(presetsDoubleClicked(2)) +...
                                                     phPlot.sum_tree.get(presetsDoubleClicked(3)))/3);

P1a = phPlot.sum_tree.get(presetsDoubleClicked(1));
P1b = phPlot.sum_tree.get(presetsDoubleClicked(2));
P1c = phPlot.sum_tree.get(presetsDoubleClicked(3));

P2 = phPlot.sum_tree.get(newIndex);


phPlot.plot_tree = phPlot.plot_tree.addnode(oldIndex, plot([P2(1), P1a(1), P2(1), P1b(1), P2(1), P1c(1), P2(1)],...
                                                           [P2(2), P1a(2), P2(2), P1b(2), P2(2), P1c(2), P2(2)],...
                                                            'Color', lineColour, 'LineStyle', ':','LineWidth',3, 'PickableParts','none'));

phPlot.plot_markers_tree = phPlot.plot_markers_tree.addnode(oldIndex, plot(P2(1), P2(2), 'ro','MarkerSize',12,'MarkerFaceColor',[0.1,1.0,0.1], 'ButtonDownFcn',{@markerClickedCallback2, newIndex}, 'PickableParts','all'));

% %recolour child node
for index = presetsDoubleClicked
    marker = phPlot.plot_markers_tree.get(index);
    marker.Color = [0.1,1.0,0.1];
    phPlot.plot_markers_tree = phPlot.plot_markers_tree.set(index, marker);
end

figure(1)
end

