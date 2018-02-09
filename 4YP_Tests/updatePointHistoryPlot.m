function [phPlot] = updatePointHistoryPlot(phPlot, mousePos, oldIndex, newIndex, lineColour, appData)

if nargin <5
    lineColour = [0.4,0.5,0.9];
end

figure(3);

phPlot.vector_tree = phPlot.vector_tree.addnode(oldIndex, mousePos');

phPlot.sum_tree = phPlot.sum_tree.addnode(oldIndex, phPlot.sum_tree.get(oldIndex) + phPlot.vector_tree.get(newIndex));


P1 = phPlot.sum_tree.get(oldIndex);
P2 = phPlot.sum_tree.get(newIndex);


phPlot.plot_tree = phPlot.plot_tree.addnode(oldIndex, plot([P1(1), P2(1)], [P1(2), P2(2)], 'Color', [lineColour, 0.9],'LineWidth', 4, 'PickableParts','none'));

phPlot.plot_markers_tree = phPlot.plot_markers_tree.addnode(oldIndex, plot(P2(1), P2(2), 'ro','MarkerSize',12,'MarkerFaceColor',[0.0, 1.0, 1.0], 'ButtonDownFcn',{@markerClickedCallback2, newIndex, appData}, 'PickableParts','all'));

%recolour child node
marker = phPlot.plot_markers_tree.get(oldIndex);
marker.MarkerFaceColor = [.8 .6 .6];
phPlot.plot_markers_tree = phPlot.plot_markers_tree.set(oldIndex, marker);


% Store frozen line if neccesary
if isequal(phPlot.frozenLine.Visible, 'on')
    phPlot.frozenLine.Visible = 'off';
    
    xData = phPlot.frozenLine.XData;
    yData = phPlot.frozenLine.YData;
    lineColour = phPlot.frozenLine.Color;
    
    phPlot.frozenLineStore = [phPlot.frozenLineStore, ...
        plot(xData, yData, 'Color', lineColour, 'LineStyle', ':',...
        'PickableParts','none', 'LineWidth', 2)];
    
    
end

figure(1)
end

