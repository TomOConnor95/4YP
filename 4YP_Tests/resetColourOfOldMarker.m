function P1HistoryPlot = resetColourOfOldMarker(P1HistoryPlot, oldIndex)

        marker = P1HistoryPlot.plot_markers_tree.get(oldIndex);
        marker.MarkerFaceColor = [.8 .6 .6];
        P1HistoryPlot.plot_markers_tree = P1HistoryPlot.plot_markers_tree.set(oldIndex, marker);
end