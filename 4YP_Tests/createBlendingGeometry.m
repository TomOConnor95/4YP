function [G] = createBlendingGeometry()
% Construct Equilateral triangle

sideLength = 10;

G.A = [0;0];
G.B = [-sideLength/2;sideLength*(sqrt(3)/2)];
G.C = [sideLength/2;sideLength*(sqrt(3)/2)];
sides = [G.A,G.B,G.C,G.A];


% Plot lines
hold off;
G.fillCenter = fill(sides(1,:),sides(2,:),'c','FaceAlpha',0.3);
hold on
G.pointA = plot(G.A(1),G.A(2), 'r+');
G.pointB = plot(G.B(1),G.B(2), 'r+');
G.pointC = plot(G.C(1),G.C(2), 'r+');
G.lineSides = plot(sides(1,:),sides(2,:), 'LineWidth',3);
axis([-14,14,-9,17])
axis equal
G.pointCenter = plot(0,sideLength*(sqrt(3)/2)*(2/3),'b+','MarkerSize',12);



% guide lines outside of triangle
G.linesA = plot([-1/2,0,1/2]*sideLength,[-(sqrt(3)/2),0,-(sqrt(3)/2)]*sideLength,'r', 'LineWidth',3);
G.linesB = plot([1,1/2,3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r', 'LineWidth',3);
G.linesC = plot([-1,-1/2,-3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r', 'LineWidth',3);

% Data to do with the point where the mouse is clicked
G.P1 = [0;0];
G.P1current = G.P1;
G.P1Sum = G.P1;
G.P1History = G.P1;

G.cursorPoint = plot(G.P1(1),G.P1(2), 'r+');

G.lineA = plot([G.A(1), G.P1(1)],[G.A(2),G.P1(2)], 'LineWidth',2);
G.lineB = plot([G.B(1), G.P1(1)],[G.B(2),G.P1(2)], 'LineWidth',2);
G.lineC = plot([G.C(1), G.P1(1)],[G.C(2),G.P1(2)], 'LineWidth',2);

% Background Colour
set(gca,'color',[0.7 0.9 1])
hold off

% create a "push button" user interface (UI) object
G.but_h = uicontrol('style', 'pushbutton',...
    'string', 'Save Last Preset',...
    'units', 'normalized',...
    'position', [0 0 0.3 0.12],...
    'callback', {@pushButtonCallback},...
    'visible', 'on');

% % create a "push button" user interface (UI) object
% G.but_h_2 = uicontrol('style', 'pushbutton',...
%     'string', 'Begin Blending',...
%     'units', 'normalized',...
%     'position', [0.4 0.4 0.3 0.12],...
%     'callback', {@pushButtonCallback2},...
%     'visible', 'on');

% Message to be displayed at start
G.pauseText = text(0.5, 0.5, 'Press Any Key To Begin Searching', 'FontSize',25, 'Color','k', ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle');

% Edit response to mouse clicks
child_handles = allchild(gca);

set(child_handles,'HitTest','off')
set(G.but_h,'HitTest','on')
set (gca, 'ButtonDownFcn', @mousePressedTest);

% read continuous mouse position
set (gcf, 'WindowButtonMotionFcn', @mouseMoveTest);

end