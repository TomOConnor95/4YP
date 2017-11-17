
% read continuous mouse position
close all
figure(1)
set (gcf, 'WindowButtonMotionFcn', @mouseMoveTest);




% Construct Equilateral triangle
sideLength = 10;

A = [0;0];
B = [-sideLength/2;sideLength*(sqrt(3)/2)];
C = [sideLength/2;sideLength*(sqrt(3)/2)];
sides = [A,B,C,A];

% test presets
initialPresetA = [0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5];
initialPresetB = [0.0,0.1,0.2,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];
initialPresetC = [1 0 1 0 1 0 1 0 1 0 1];

presetA = initialPresetA;
presetB = initialPresetB;
presetC = initialPresetC;


%create bar graphs
alpha = 0.4; beta = 0.4; gamma = 0.2;
figure(2)
subplot(1,2,1)
barA = bar([alpha,beta,gamma]);
ylim([-2,2])

subplot(1,2,2)
presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
barB = bar(presetMix,'r');
hold on
barC = bar([(presetA' * alpha),(presetB'*beta),(presetC'*gamma)]);
hold off

ylim([-2,2])
figure(1)

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

% create a "push button" user interface (UI) object
but_h = uicontrol('style', 'pushbutton',...
                    'string', 'Generate new presets',...
                    'units', 'normalized',...
                    'position', [0 0 0.3 0.12],...
                    'callback', {@pushButtonCallback},...
                    'visible', 'off');


% Click callback
child_handles = allchild(gca);

set(child_handles,'HitTest','off')
set(but_h,'HitTest','on')
set (gca, 'ButtonDownFcn', @mousePressedTest);
MOUSE = [0,0];

% option parameters
isBlending = true;
isPressed = false;
isButtonPressed = false;

while(true)
    pause(0.01)
%     if isPressed ==true
%         isBlending = 1 - isBlending;
%         isPressed = false;
%     end
    if isPressed ==true
        % Generate new presets
        presetA = presetMix;
        presetB = rand(1,length(presetA));
        presetC = rand(1,length(presetA));
        isPressed = false;
        %isBlending = true;
    end
    
    if isBlending == true
        set(but_h,'visible','off')
        P1 = [MOUSE(1,1);MOUSE(1,2)];
        
        % has P1 Changed?
        if isequal(P1,P1current)
            disp('Mouse Still')
        else
            disp('Mouse Changed')
            P1current = P1;
            
            cursorPoint.XData = P1(1);
            cursorPoint.YData = P1(2);
            
            % lines from corners to point
            lineA.XData(2) = P1(1);
            lineA.YData(2) = P1(2);
            
            lineB.XData(2) = P1(1);
            lineB.YData(2) = P1(2);
            
            lineC.XData(2) = P1(1);
            lineC.YData(2) = P1(2);
            
            %find vectors
            vecA = [P1-A];
            vecB = [P1-B];
            vecC = [P1-C];
            
            % matrix equation for no orthogonal basis vectors
            %https://math.stackexchange.com/questions/148199/
            % equation-for-non-orthogonal-projection-of-a-point-onto-two-vectors-representing
            
            M = [B,C];
            Y = (M'*M)\M'*P1;
            beta = Y(1);
            gamma = Y(2);
            alpha = 1-beta-gamma;
            
            barA.YData =[alpha,beta,gamma];
            
            presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
            barB.YData = presetMix;
            
            barC(1).YData = (presetA' * alpha);
            barC(2).YData = (presetB'*beta);
            barC(3).YData = (presetC'*gamma);
            drawnow()
        end
    else
    set(but_h,'visible','on')
    
    end
end

