function P1HistoryPlot = switchColourOfNewMarker(P1HistoryPlot, index)

        marker = P1HistoryPlot.plot_markers_tree.get(index);
        marker.MarkerFaceColor = [0 1 1];
        P1HistoryPlot.plot_markers_tree = P1HistoryPlot.plot_markers_tree.set(index, marker);
end