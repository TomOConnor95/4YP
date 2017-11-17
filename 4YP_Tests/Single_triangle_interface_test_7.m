
% read continuous mouse position
%close all
figure(1)
set (gcf, 'WindowButtonMotionFcn', @mouseMoveTest);


currentGeneration = 1;

% Construct Equilateral triangle
sideLength = 10;

A = [0;0];
B = [-sideLength/2;sideLength*(sqrt(3)/2)];
C = [sideLength/2;sideLength*(sqrt(3)/2)];
sides = [A,B,C,A];

% test presets - For image adjust [[low_in; high_in],[low_out;
% high_out],gamma]
initialPresetA = [0 1 0 1 1]; %,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5];
initialPresetB = [0.2 1 0.1 0.9 1]; %,0.3,0.4,0.5,0.6,0.7,0.8,0.9,1.0];
initialPresetC = [0.4 0.9 0 1 0.5]; % 0 1 0 1 0 1 0 1];

presetA = initialPresetA;
presetB = initialPresetB;
presetC = initialPresetC;

% Store all past values of the presets in this array
presetAHistory = presetA;
presetBHistory = presetB;
presetCHistory = presetC;

%create bar graphs
alpha = 0.4; beta = 0.4; gamma = 0.2;
figure(2)
subplot(3,2,1)
barA = bar(presetA);
ylim([0,1])
hold on
errorBarA = errorbar(1:length(presetA),presetA,zeros(1,length(presetA)),'.');
hold off
subplot(3,2,3)
barB = bar(presetB);
ylim([0,1])
subplot(3,2,5)
barC = bar(presetC);
ylim([0,1])

subplot(3,2,[2,4,6])
presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
barMix = bar(presetMix,'r');
hold on
barCombined = bar([(presetA' * alpha),(presetB'*beta),(presetC'*gamma)]);
hold off

ylim([-2,2])

% Create plot to show evolution of parameters
figure(3)
for i=1:length(presetA)
    plot(presetAHistory(:,i))
    hold on
end
hold off

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
P1 = [0;0];
P1Sum = P1;
P1History=P1;

% option parameters
isBlending = true;
isPressed = false;
isButtonPressed = false;

initialTempOffset = 0.3;
tempOffset = initialTempOffset;
tempScaling = 0.5;

% Image for testing Filtering
img = imread('Sunset.jpg');
img = imresize(img,0.4);
figure(4)
subplot(1,2,1)
image1 = imshow(img);title('Original');
subplot(1,2,2);
image2 = imshow(img);title('Edited');
figure(1)

while(true)
    pause(0.01)
    %     if isPressed ==true
    %         isBlending = 1 - isBlending;
    %         isPressed = false;
    %     end
    if isPressed ==true
        % Generate new presets
        presetA = presetMix;
        presetAHistory = [presetAHistory; presetA];
        
        presetB = (2*presetA + mean(presetAHistory))/3 + tempScaling * (tempOffset + std(presetAHistory).^1.5).*randn(1,length(presetA));
        presetC = (2*presetA + mean(presetAHistory))/3 + tempScaling * (tempOffset + std(presetAHistory).^1.5).*randn(1,length(presetA));
        
        presetB = bound(presetB,0,1);
        presetC = bound(presetC,0,1);
%         presetB = rand(1,length(presetA));
%         presetC = rand(1,length(presetA));
        
        %decay tempOffset
        tempOffset = tempOffset*0.9
        std(presetAHistory)
        % Store Presets and Mouse Position
        
        presetBHistory = [presetBHistory; presetB];
        presetCHistory = [presetCHistory; presetC];
        
        P1Sum = P1Sum + P1;
        P1History = [P1History, P1Sum];
        
        
        
        % Create plot to show evolution of parameters
        figure(3)
        hold off
        subplot(1,2,1)
        currentGeneration = currentGeneration + 1;
        for i=1:length(presetA)
            plot(presetAHistory(:,i))
            hold on
        end
        hold off
        subplot(1,2,2)
        plot(P1History(1,:),P1History(2,:))
        hold on
        plot(P1History(1,:),P1History(2,:),'r+')
        hold off
        figure(1)
        
        % Update Bar plots
        barA.YData =presetA;
        barB.YData =presetB;
        barC.YData =presetC;
        errorBarA.YData = presetA;
        errorBarA.YNegativeDelta = tempScaling*(tempOffset + std(presetAHistory));
        errorBarA.YPositiveDelta = tempScaling*(tempOffset + std(presetAHistory));
        isPressed = false;
        %isBlending = true;
    end
    
    if isBlending == true
        set(but_h,'visible','off')
        P1 = [MOUSE(1,1);MOUSE(1,2)];
        
        % has P1 Changed?
        if isequal(P1,P1current)
            %disp('Mouse Still')
        else
           % disp('Mouse Changed')
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
            
            %             barA.YData =[alpha,beta,gamma];
            
            presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
            % return bounded value clipped between 0 and 1
            presetMix = bound(presetMix,0,1);
            
            barMix.YData = presetMix;
            
            barCombined(1).YData = (presetA' * alpha);
            barCombined(2).YData = (presetB'*beta);
            barCombined(3).YData = (presetC'*gamma);
            drawnow()
            
            %Update image
            low_in = presetMix(1); 
            high_in = presetMix(2);
            low_out = presetMix(3); 
            high_out = presetMix(4);
            gamma = presetMix(5); 
            
            enhanced = imadjust(img,[min(low_in,low_out); min(high_in,high_out)],[low_out; high_out], gamma);
            image2.CData = enhanced;
      
        end
    else
        set(but_h,'visible','on')
        
    end
end

