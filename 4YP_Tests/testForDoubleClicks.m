 function [P, presetsDoubleClicked] = testForDoubleClicks(P, presetsDoubleClicked,currentMarkerIndex, markerIndex)
    if markerIndex == currentMarkerIndex

        if ismember(markerIndex, presetsDoubleClicked)
            presetsDoubleClicked(presetsDoubleClicked == markerIndex) = [];
            disp('removed double click')
        else
            presetsDoubleClicked = [presetsDoubleClicked, markerIndex];
            disp('double clicked')
            P.P1HistoryPlot.plot_markers_tree.Node{markerIndex}.MarkerFaceColor = [0,1,0];
        end
    end
 end