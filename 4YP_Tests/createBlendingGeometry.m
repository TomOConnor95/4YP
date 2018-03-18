function [G] = createBlendingGeometry()
% Construct Equilateral triangle

G.panel = uipanel('Position',[0,0.11,1,0.89]);
G.ax = axes(G.panel, 'Units','Normalized',...
        'position',[0.05, 0.05, 0.9, 0.9],...
        'XGrid','off',...
        'XMinorGrid','off',...
        'XTickLabel',[],...
        'YTickLabel',[],...
        'XTick',[],...
        'YTick',[]);


sideLength = 10;

G.A = [0;0];
G.B = [-sideLength/2;sideLength*(sqrt(3)/2)];
G.C = [sideLength/2;sideLength*(sqrt(3)/2)];
sides = [G.A,G.B,G.C,G.A];


hold off;
% Shaded Centre Triangle


% Plot lines
G.fillCenter = fill(G.ax, sides(1,1:3),sides(2,1:3),'c','FaceAlpha',1);
set(G.fillCenter, 'FaceVertexCData', [1,0,0; 1,1,1; 0,0,0.5],...
                    'FaceColor','interp');
hold on
G.pointA = plot(G.ax, G.A(1),G.A(2), 'r+');
G.pointB = plot(G.ax, G.B(1),G.B(2), 'r+');
G.pointC = plot(G.ax, G.C(1),G.C(2), 'r+');
G.lineSides = plot(G.ax, sides(1,:),sides(2,:), 'LineWidth',3);

G.pointCenter = plot(G.ax, 0,sideLength*(sqrt(3)/2)*(2/3),'r+','MarkerSize',15);


% guide lines outside of triangle
G.linesA = plot(G.ax, [-1/2,0,1/2]*sideLength,[-(sqrt(3)/2),0,-(sqrt(3)/2)]*sideLength,'r', 'LineWidth',3);
G.linesB = plot(G.ax, [1,1/2,3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r', 'LineWidth',3);
G.linesC = plot(G.ax, [-1,-1/2,-3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r', 'LineWidth',3);

% Data to do with the point where the mouse is clicked
G.P1 = [0;0];
G.P1current = G.P1;
G.P1Sum = G.P1;
G.P1History = G.P1;

G.cursorPoint = plot(G.ax, G.P1(1),G.P1(2), 'r+');

G.lineA = plot(G.ax, [G.A(1), G.P1(1)],[G.A(2),G.P1(2)], 'LineWidth',2);
G.lineB = plot(G.ax, [G.B(1), G.P1(1)],[G.B(2),G.P1(2)], 'LineWidth',2);
G.lineC = plot(G.ax, [G.C(1), G.P1(1)],[G.C(2),G.P1(2)], 'LineWidth',2);

% Background Colour
set(G.ax, 'color',[0.7 0.9 1])
set(G.ax, 'XTickLabel',[],...
          'YTickLabel',[])
title('Blend Presets')
hold off
axis([-14,14,-9,17])
axis equal
axis manual

% Listen for mouse clicks mouse clicks
child_handles = allchild(gca);
set(child_handles,'HitTest','off')

G.figurePosition = get(figure(1), 'Position');

end

% function mouseClicked (object, eventdata)
% 
% disp('CLICK')
% 
% % detects mouse clicks and 
% assignin('base','isMouseClicked',1)
% 
% end
% 
% function mouseMoved (object, eventdata)
% % writes continuous mouse position to base workspace
% MOUSE = get (gca, 'CurrentPoint');
% 
% assignin('base','MOUSE',MOUSE)
% end
