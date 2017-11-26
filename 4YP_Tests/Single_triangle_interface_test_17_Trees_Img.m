% Test script for preset blending interface
close all
%% Create Initial Presets and related data structures
%Ptest = createPresetsForImageEditing();

%% Option parameters
selectedImageNumber = 1;
savePresetsToFile = true;

%% Miscellaneous parameters
MOUSE = [0,0];              % Variable for mouse position to be stored in
isBlending = true;          % Is UI in blending mode?
isPressed = false;          % Has mouse been pressed?
isButtonPressed = false;    % Has push button been pressed?
isPauseButtonPressed = false;
isPaused = false;
isSearching = true;
isBeginBlending = false;
isMarkerClicked = false;
markerIndex = 1;
currentGeneration = 1;
screenSize = get(0,'Screensize');

%% Load Image for testing Filtering
imgFullSize = loadSelectedImage(selectedImageNumber);

img = imresize(imgFullSize, 0.2);    % Reduce image size for increased speed

%% Display Images
figure(4)
subplot(1,2,1)      % Original image for comparison
imageOriginal1 = imshow(img);
title('Original');

subplot(1,2,2);     % Edited Image
imageEdited = imshow(img);
title('Edited');
hold off
set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/1.2,screenSize(4)/2.1])
%% Create Photo mosaic to choose initail presets from
mosaicWidth = 4;
mosaicHeight = 4;

selectedPresetNumbers = chooseFromImageMosaic(img, mosaicWidth, mosaicHeight);

presetRead = matfile('PresetStore.mat');
presetArray = presetRead.presetStore;
P = presetGeneratorMonteCarloMV(presetArray(selectedPresetNumbers(1),:),...
                        presetArray(selectedPresetNumbers(2),:),...
                        presetArray(selectedPresetNumbers(3),:));
%% Plot all geometry for Blending Interface
figure(1)
G = createBlendingGeometry();
%set(gcf,'Position',[(screenSize(3)/2 - screenSize(3)/26),screenSize(4)/2,screenSize(3)/3,screenSize(4)/2])

%% Create all necessary bar graphs
figure(2)
%subplot(2,5,[1,2,3,6,7,8])
[barA, barB, barC, barMix] = createBarGraphs(P.presetA,P.presetB,P.presetC);

%% Create plots to show evolution of parameters and Mouse Points
% figure(3)
% subplot(2,5,[4,5,9,10])
% historyPlot = createHistoryPlot(P.presetAHistory);
% set(gcf,'Position',[-screenSize(3)/26,screenSize(4)/1.6,screenSize(3)/2.4,screenSize(4)/2.5])

% figure(3)
% %clf
% P1HistoryPlot = createPointHistoryPlot();
% set(gcf,'Position',[screenSize(3)/0.7,screenSize(4)/1.6,screenSize(3)/2.4,screenSize(4)/2.5])

%% Main Loop
figure(1)

pause()
G.pauseText.Visible = 'off';
% Currently if you click during the paused time it will trigger the
% callback and cause a bug

while(isSearching)
    pause(0.01)
    
    %% Press button to save final image and quit program
    if isButtonPressed == true
        isBlending = false;
        isPressed = false;
        isSearching = false;
        
        % Revert to last clicked preset
        imageEdited.CData = updateEditedImage2(img, P.presetA);
        
        if savePresetsToFile == true
            presetSave = matfile('PresetStore.mat','Writable',true);
            presetSave.presetStore(1+length(presetSave.presetStore(:,1)),:) = P.presetA;
        end
        % Plot full size final output in new figure
        figure;
        
        imageEditedFullSize = imshow(imgFullSize);
        imageEditedFullSize.CData = updateEditedImage2(imgFullSize, P.presetA);
    end
    
    %% Switch presets if a preset marker is clicked
    if isMarkerClicked == true
        isMarkerClicked = false;
        
        P = P.switchPresets(markerIndex);

        imageEdited.CData = updateEditedImage2(img, P.presetA);
       continue 
    end
    
    %% Paused State
    if isPaused == true
        
        if isPauseButtonPressed == true
            isPauseButtonPressed = false;
            isBlending = true;
            isPressed = false;
            isPaused = false;   
            G.but_pause.String = 'Pause On Last Preset';
            continue
        end
        	
       continue 
    end
    %% Press pause button to pause searching
    if isPauseButtonPressed == true
        isPauseButtonPressed = false;
        isBlending = false;
        isPressed = false;
        isPaused = true;
        %isSearching = false;
        
        G.but_pause.String = 'Click to Resume Searching';
        
        % Revert to last clicked preset
        imageEdited.CData = updateEditedImage2(img, P.presetA);
        continue
    end
    
    %% If mouse is clicked move to the next generation of presets
    if isPressed == true
        currentGeneration = currentGeneration + 1;
        
        % Generate new presets
        P = P.iteratePresets(G.P1);
        
        % Update Bar plots
        [barA, barB, barC] = updateBarPlots(barA,barB,barC,P.presetA,P.presetB,P.presetC);
        
        isPressed = false;
        %isBlending = true;
    end
    %%  Live Preset Blending Step
    if isBlending == true
        G.P1 = [MOUSE(1,1);MOUSE(1,2)];
        
        % has P1 Changed?
        if ~isequal(G.P1,G.P1current)
            
            G = updateGeometry(G);
            
            [alpha,beta,gamma] = calculatePresetRatios(G);
            
            P = P.mixPresets(alpha,beta,gamma);
            
            barMix = updateMixBarPLot(barMix, P.presetMix);

            imageEdited.CData = updateEditedImage2(img, P.presetMix);
            drawnow()
        end
    end
    
end
