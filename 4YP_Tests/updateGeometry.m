function G = updateGeometry(G)
% Mouse has moved so update current mouse value
G.P1current = G.P1;

% Update Cursor Point
G.cursorPoint.XData = G.P1(1);
G.cursorPoint.YData = G.P1(2);

% Update lines from corners to point
G.lineA.XData(2) = G.P1(1);
G.lineA.YData(2) = G.P1(2);

G.lineB.XData(2) = G.P1(1);
G.lineB.YData(2) = G.P1(2);

G.lineC.XData(2) = G.P1(1);
G.lineC.YData(2) = G.P1(2);
end