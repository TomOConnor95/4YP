%%mouseClickTestScript

% read continuous mouse position
clear figure 1
figure(1)
set (gcf, 'WindowButtonMotionFcn', @mouseMoveTest);




% Plot lines
figure(1)
hold off;
pointA = plot(A(1),A(2), 'r+');
hold on
pointB = plot(B(1),B(2), 'r+');
pointC = plot(C(1),C(2), 'r+');
lineSides = plot(sides(1,:),sides(2,:));
axis([-14,14,-9,17])
axis equal
pointCenter = plot(0,sideLength*(sqrt(3)/2)*(2/3),'b+');



% guide lines outside of triangle
linesA = plot([-1/2,0,1/2]*sideLength,[-(sqrt(3)/2),0,-(sqrt(3)/2)]*sideLength,'r');
linesB = plot([1,1/2,3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r');
linesC = plot([-1,-1/2,-3/2]*sideLength,[sqrt(3),(sqrt(3)/2),(sqrt(3)/2)]*sideLength,'r');

P1 = [0;sideLength*(sqrt(3)/2)*(2/3)];
P1current = P1;

cursorPoint = plot(P1(1),P1(2), 'r+');

lineA = plot([A(1), P1(1)],[A(2),P1(2)]);
lineB = plot([B(1), P1(1)],[B(2),P1(2)]);
lineC = plot([C(1), P1(1)],[C(2),P1(2)]);

% set(pointA,'HitTest','off')
% set(pointB,'HitTest','off')
% set(pointC,'HitTest','off')
% set(linesA,'HitTest','off')
% set(linesB,'HitTest','off')
% set(linesC,'HitTest','off')
% 
% set(pointCenter,'HitTest','off')
% set(cursorPoint,'HitTest','off')
% set(lineSides,'HitTest','off')

MOUSE = [0,0];

% Click callback
child_handles = allchild(gca);

set(child_handles,'HitTest','off')
set (gca, 'ButtonDownFcn', @mousePressedTest);
% option parameters
isBlending = true;
isPressed = false;

while(true)
    pause(0.02)
    if isPressed ==true
        isBlending = 1 - isBlending;
        isPressed = false;
    end
    
    if isBlending == true
        P1 = [MOUSE(1,1);MOUSE(1,2)];
        
        % has P1 Changed?
        if isequal(P1,P1current)
            disp('Mouse Still')
        else
            disp('Mouse Changed')
            P1current = P1;
            
%             cursorPoint.XData = P1(1);
%             cursorPoint.YData = P1(2);
%             
%             % lines from corners to point
%             lineA.XData(2) = P1(1);
%             lineA.YData(2) = P1(2);
%             
%             lineB.XData(2) = P1(1);
%             lineB.YData(2) = P1(2);
%             
%             lineC.XData(2) = P1(1);
%             lineC.YData(2) = P1(2);
%             
%             %find vectors
%             vecA = [P1-A];
%             vecB = [P1-B];
%             vecC = [P1-C];
%             
%             % matrix equation for no orthogonal basis vectors
%             %https://math.stackexchange.com/questions/148199/
%             % equation-for-non-orthogonal-projection-of-a-point-onto-two-vectors-representing
%             
%             M = [B,C];
%             Y = (M'*M)\M'*P1;
%             beta = Y(1);
%             gamma = Y(2);
%             alpha = 1-beta-gamma;
%             
%             barA.YData =[alpha,beta,gamma];
%             
%             presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
%             barB.YData = presetMix;
%             
%             barC(1).YData = (presetA' * alpha);
%             barC(2).YData = (presetB'*beta);
%             barC(3).YData = (presetC'*gamma);
%             drawnow()
        end
    end
end

