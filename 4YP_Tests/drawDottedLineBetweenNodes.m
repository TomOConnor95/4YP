
function P1HistoryPlot = drawDottedLineBetweenNodes(P1HistoryPlot, indexA, indexB, lineColour)
% Draw Dotted line from frozen node to switched node
nodeA = P1HistoryPlot.sum_tree.Node{indexA};
nodeB = P1HistoryPlot.sum_tree.Node{indexB};

P1HistoryPlot.frozenLine.XData = [nodeA(1), nodeB(1)];
P1HistoryPlot.frozenLine.YData = [nodeA(2), nodeB(2)];
P1HistoryPlot.frozenLine.Color = lineColour;
P1HistoryPlot.frozenLine.Visible = 'on';

end