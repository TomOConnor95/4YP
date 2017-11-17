
% read continuous mouse position
%close all

figure(1)
set (gcf, 'WindowButtonMotionFcn', @mouseMoveTest);


currentGeneration = 1;



% test presets - For image adjust [[low_in; high_in],[low_out;
% high_out],Vignette]
initialPresetA = [0.2 0.1 0.0  1.0 0.8 0.9  0.0 0.4 0.2  0.9 0.7 0.8  0.5 0.5 0.5  0.5 1.0 0.2];
initialPresetB = [0.1 0.2 0.1  0.9 0.8 0.7  0.9 0.9 0.9  0.2 0.1 0.3  0.6 0.6 0.4  0.6 0.8 0.8];
initialPresetC = [0.3 0.2 0.1  0.8 0.7 0.9  0.2 0.1 0.2  0.7 0.9 0.8  0.3 0.5 0.4  0.4 0.9 0.5];

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
%hold on
% bar combined was being too slow with loty of params
%barCombined = bar([(presetA' * alpha),(presetB'*beta),(presetC'*gamma)]);
%hold off

ylim([-2,2])

% Create plot to show evolution of parameters
figure(3)
for i=1:length(presetA)
    plot(presetAHistory(:,i))
    hold on
end
hold off

% % Construct Equilateral triangle
% sideLength = 10;
% 
% A = [0;0];
% B = [-sideLength/2;sideLength*(sqrt(3)/2)];
% C = [sideLength/2;sideLength*(sqrt(3)/2)];
% sides = [A,B,C,A];

% Plot all geometry for Blending Interface
figure(1)
[G] = plotBlendingGeometry();

P1current = G.P1;


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
img1 = imread('Sunset.jpg');
img2 = imread('Sunset2.jpg');
img3 = imread('Sea.jpg');
img4 = imread('Venice.jpg');
img5 = imread('Gig.jpg');
img6 = imread('Bee.jpg');

% choose which image to use
img = imresize(img4,0.2);
imgBW = rgb2gray(img);
[imgHeight, imgWidth, numChannels] = size(img);
figure(4)
subplot(1,2,1)
imageOriginal1 = imshow(img);title('Original');

% 3 layers of images, Original
subplot(1,2,2);

imageOriginal2 = imshow(img);
hold on

imageBW = imshow(imgBW);

imageEdited = imshow(img);title('Edited');
%set(imageBW, 'AlphaData', 0);
hold off
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
            P1current = P1;         %%%!!!
            
            G.cursorPoint.XData = P1(1);
            G.cursorPoint.YData = P1(2);
            
            % lines from corners to point
            G.lineA.XData(2) = P1(1);
            G.lineA.YData(2) = P1(2);
            
            G.lineB.XData(2) = P1(1);
            G.lineB.YData(2) = P1(2);
            
            G.lineC.XData(2) = P1(1);
            G.lineC.YData(2) = P1(2);
            
%             %find vectors
%             vecA = P1-A;
%             vecB = P1-B;
%             vecC = P1-C;
            
            % matrix equation for no orthogonal basis vectors
            %https://math.stackexchange.com/questions/148199/
            % equation-for-non-orthogonal-projection-of-a-point-onto-two-vectors-representing
            
            M = [G.B,G.C];
            Y = (M'*M)\M'*P1;
            beta = Y(1);
            gamma = Y(2);
            alpha = 1-beta-gamma;
            
            %             barA.YData =[alpha,beta,gamma];
            
            presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
            % return bounded value clipped between 0 and 1
            presetMix = bound(presetMix,0,1);
            
            
            barMix.YData = presetMix;
            
            %barCombined(1).YData = (presetA' * alpha);
            %barCombined(2).YData = (presetB'*beta);
            %barCombined(3).YData = (presetC'*gamma);
            drawnow()
            
            %Update image
            low_in = presetMix(1:3); 
            high_in = presetMix(4:6);
            low_out = presetMix(7:9); 
            high_out = presetMix(10:12);
            gamma = presetMix(13:15);
            
            
            
            
            %ensure low_in & low_out are smaller than high_in & high_out
            low_in = min(low_in,high_in*0.95);
            high_in = max(low_in*1.05,high_in);
            %low_out = min(low_out,high_out*0.95);  only necesary for in
            
            % remap gamma so it goes from 0 to infinity
            gamma = tan(gamma*pi/2);
            
            enhanced = imadjust(img,[low_in; high_in],[low_out; high_out], gamma);
            % enhanced2 = imsharpen(enhanced,'Radius',2,'Amount',1,'Threshold',0.0);
            % sharpening filter too slow!
            %enhanced2 = imgaussfilt(enhanced, gaussianRadius);
            % didn't add gaussian as it slowed it down a bit, and doesn't
            % work well with a zero value
            imageEdited.CData = enhanced;
            drawnow();
            
            blackAndWhiteAmmount = presetMix(18);
            
            posRatio = presetMix(16);
            radius = presetMix(17);
            %grade = presetMix(16);
            
             %alphaMap =  alphaMapVignette(imgBW,posRatio,radius,grade);
            alphaMap =  alphaMapGaussian(imgHeight, imgWidth, radius, posRatio);
            % Vignettte the edited image
                  set(imageEdited, 'AlphaData', alphaMap);
            
            % Blend between Black and White vs Original Background
                 set(imageBW, 'AlphaData', blackAndWhiteAmmount);
        end
    else
        set(but_h,'visible','on')
        
    end
end

