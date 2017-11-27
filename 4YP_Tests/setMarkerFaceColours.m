function P = setMarkerFaceColours(P, nodeIndeces, colour)
    for i = 1:length(nodeIndeces)
        P.P1HistoryPlot.plot_markers_tree.Node{nodeIndeces(i)}.MarkerFaceColor = colour;
    end
            
end