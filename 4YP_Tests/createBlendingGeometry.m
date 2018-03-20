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

% Geometry Points
G.A = [0;0];
G.B = [-1/2; sqrt(3)/2]*sideLength;
G.C = [1/2;  sqrt(3)/2]*sideLength;
sides = [G.A,G.B,G.C,G.A];

G.A1 = [-1; -sqrt(3)]*sideLength;
G.A2 = [1;  -sqrt(3)]*sideLength;

G.B1 = [-3/2; 3*sqrt(3)/2]*sideLength;
G.B2 = [-5/2;   sqrt(3)/2]*sideLength;

G.C1 = [5/2;   sqrt(3)/2]*sideLength;
G.C2 = [3/2; 3*sqrt(3)/2]*sideLength;

G.AB = (G.A1 + G.B2)/2;
G.BC = (G.B1 + G.C2)/2;
G.CA = (G.C1 + G.A2)/2;

% Point Colours
G.col.A = [1, 0, 0];
G.col.B = [0, 1, 0];
G.col.C = [0, 0, 1];

G.col.A1 = [1, 0.5, 0];
G.col.A2 = [1, 0, 0.5];
G.col.B1 = [0.5, 1, 0];
G.col.B2 = [0, 1, 0.5];
G.col.C1 = [0.5, 0, 1];
G.col.C2 = [0, 0.5, 1];

G.col.AB = sqrt(G.col.A1.^2 +G.col.B2.^2);
G.col.BC = sqrt(G.col.B1.^2 +G.col.C2.^2);
G.col.CA = sqrt(G.col.C1.^2 +G.col.A2.^2);

% Calculate preset ratios for all geometry points
[ratios.A(1), ratios.A(2), ratios.A(3)] = calculatePresetRatios(G, G.A);
[ratios.B(1), ratios.B(2), ratios.B(3)] = calculatePresetRatios(G, G.B);
[ratios.B(1), ratios.B(2), ratios.B(3)] = calculatePresetRatios(G, G.C);

[ratios.A1(1), ratios.A1(2), ratios.A1(3)] = calculatePresetRatios(G, G.A1);
[ratios.A2(1), ratios.A2(2), ratios.A2(3)] = calculatePresetRatios(G, G.A2);
[ratios.B1(1), ratios.B1(2), ratios.B1(3)] = calculatePresetRatios(G, G.B1);
[ratios.B2(1), ratios.B2(2), ratios.B2(3)] = calculatePresetRatios(G, G.B2);
[ratios.C1(1), ratios.C1(2), ratios.C1(3)] = calculatePresetRatios(G, G.C1);
[ratios.C2(1), ratios.C2(2), ratios.C2(3)] = calculatePresetRatios(G, G.C2);

[ratios.AB(1), ratios.AB(2), ratios.AB(3)] = calculatePresetRatios(G, G.AB);
[ratios.BC(1), ratios.BC(2), ratios.BC(3)] = calculatePresetRatios(G, G.BC);
[ratios.CA(1), ratios.CA(2), ratios.CA(3)] = calculatePresetRatios(G, G.CA);

G.ratios = ratios;
hold off;

% Plot Fills
outerAlpha = 0.9;

G.fillCenter = fill(G.ax, [G.A(1), G.B(1), G.C(1)],...
                          [G.A(2), G.B(2), G.C(2)],...
                           'c','FaceAlpha',1);
                       
set(G.fillCenter, 'FaceVertexCData', [G.col.A; G.col.B; G.col.C],...
                    'FaceColor','interp');
hold on

G.fillA = fill(G.ax, [G.A1(1), G.A(1), G.A2(1)],...
                     [G.A1(2), G.A(2), G.A2(2)],...
                           'c','FaceAlpha',outerAlpha);

G.fillB = fill(G.ax, [G.B1(1), G.B(1), G.B2(1)],...
                     [G.B1(2), G.B(2), G.B2(2)],...
                           'c','FaceAlpha',outerAlpha);
                       
G.fillC = fill(G.ax, [G.C1(1), G.C(1), G.C2(1)],...
                     [G.C1(2), G.C(2), G.C2(2)],...
                           'c','FaceAlpha',outerAlpha);                    
                       
set(G.fillA, 'FaceVertexCData', [G.col.A1; G.col.A; G.col.A2],...
                    'FaceColor','interp');
                
set(G.fillB, 'FaceVertexCData', [G.col.B1; G.col.B; G.col.B2],...
                    'FaceColor','interp');
                
set(G.fillC, 'FaceVertexCData', [G.col.C1; G.col.C; G.col.C2],...
                    'FaceColor','interp'); 
              
                
G.fillAB = fill(G.ax, [G.A(1), G.A1(1), G.AB(1), G.B2(1), G.B(1)],...
                      [G.A(2), G.A1(2), G.AB(2), G.B2(2), G.B(2)],...
                           'c','FaceAlpha',outerAlpha);

G.fillBC = fill(G.ax, [G.B(1), G.B1(1), G.BC(1), G.C2(1), G.C(1)],...
                      [G.B(2), G.B1(2), G.BC(2), G.C2(2), G.C(2)],...
                           'c','FaceAlpha',outerAlpha);

G.fillCA = fill(G.ax, [G.C(1), G.C1(1), G.CA(1), G.A2(1), G.A(1)],...
                      [G.C(2), G.C1(2), G.CA(2), G.A2(2), G.A(2)],...
                           'c','FaceAlpha',outerAlpha);
                
set(G.fillAB, 'FaceVertexCData', [G.col.A; G.col.A1; G.col.AB; G.col.B2; G.col.B],...
                    'FaceColor','interp');
                
set(G.fillBC, 'FaceVertexCData', [G.col.B; G.col.B1; G.col.BC; G.col.C2; G.col.C],...
                    'FaceColor','interp');
                
set(G.fillCA, 'FaceVertexCData', [G.col.C; G.col.C1; G.col.CA; G.col.A2; G.col.A],...
                    'FaceColor','interp');

% Plot lines
G.pointA = plot(G.ax, G.A(1),G.A(2), 'r+');
G.pointB = plot(G.ax, G.B(1),G.B(2), 'r+');
G.pointC = plot(G.ax, G.C(1),G.C(2), 'r+');
G.lineSides = plot(G.ax, sides(1,:),sides(2,:), 'LineWidth',3);

G.pointCenter = plot(G.ax, 0,sideLength*(sqrt(3)/2)*(2/3),'r+','MarkerSize',15);


% guide lines outside of triangle
G.linesA = plot(G.ax, [G.A1(1), G.A(1), G.A2(1)],...
                      [G.A1(2), G.A(2), G.A2(2)],...
                      'color', [0,0,0], 'LineWidth',2);
G.linesB = plot(G.ax, [G.B1(1), G.B(1), G.B2(1)],...
                      [G.B1(2), G.B(2), G.B2(2)],...
                      'color', [0,0,0], 'LineWidth',2);
G.linesC = plot(G.ax, [G.C1(1), G.C(1), G.C2(1)],...
                      [G.C1(2), G.C(2), G.C2(2)],...
                      'color', [0,0,0], 'LineWidth',2);
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
