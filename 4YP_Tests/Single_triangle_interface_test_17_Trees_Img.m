% Test script for preset blending interface
close all
%% Create Initial Presets and related data structures
%Ptest = createPresetsForImageEditing();

%% Option parameters
selectedImageNumber = 1;
savePresetsToFile = true;
displayBarGraphs = false;

%% Miscellaneous parameters
% Mouse Clicks
MOUSE = [0,0];              % Variable for mouse position to be stored in
isMouseClicked = false;          % Has mouse been pressed?

% UI Buttons
isSaveButtonPressed = false;    
isPauseButtonPressed = false;
isForegroundButtonPressed = false;    
isBackgroundButtonPressed = false;

% Preset Markers
isMarkerClicked = false;
markerIndex = 1;
currentMarkerIndex = 0;
presetsDoubleClicked = [];

% Program State
isBlending = true;          % Is UI in blending mode?
isSearching = true;
isPaused = true;

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
G = createPauseSaveButtons(G);
G = createImgFreezeButtons(G);

%% Create all necessary bar graphs
if displayBarGraphs == true
    figure(2)
    [barA, barB, barC, barMix] = createBarGraphs(P.presetA,P.presetB,P.presetC);
end
%% Create plots to show evolution of parameters and Mouse Points
% This is done by the presetGenerator class

%% Main Loop
figure(1)

while(isSearching)
    pause(0.01)
    
    %% Press button to save final image and quit program
    if isSaveButtonPressed
        isBlending = false;
        isMouseClicked = false;
        isSearching = false;
        
        % Revert to last clicked preset
        imageEdited.CData = updateEditedImage2(img, P.presetA);
        
        if savePresetsToFile
            presetSave = matfile('PresetStore.mat','Writable',true);
            presetSave.presetStore(1+length(presetSave.presetStore(:,1)),:) = P.presetA;
        end
        % Plot full size final output in new figure
        figure;
        
        imageEditedFullSize = imshow(imgFullSize);
        imageEditedFullSize.CData = updateEditedImage2(imgFullSize, P.presetA);
    end
    


    %% Switch presets if a preset marker is clicked
    if isMarkerClicked
        isMarkerClicked = false;
        
        P = P.switchPresets(markerIndex);
        imageEdited.CData = updateEditedImage2(img, P.presetA);

        [P, presetsDoubleClicked] = testForDoubleClicks(P, presetsDoubleClicked,currentMarkerIndex, markerIndex);
                
        
        if length(presetsDoubleClicked) == 3
            
            P = setMarkerFaceColours(P, presetsDoubleClicked, [0.8, 0.6, 0.6]);
            
            P = P.combineSelectedPresets(presetsDoubleClicked);

            presetsDoubleClicked = [];
            currentMarkerIndex = 0;
            continue
            
        elseif ~isempty(presetsDoubleClicked)
            P = setMarkerFaceColours(P, presetsDoubleClicked, [0,1,0]);
        end
        
        currentMarkerIndex = markerIndex;
        
        continue 
    end
    %% Press Freeze Foreground/Background Buttons
    if isForegroundButtonPressed == true
        isForegroundButtonPressed = false;

        P = P.toggleForegroundState();
        G = correctlyColourFreezeButtons(G, P);

        continue
    end

    if isBackgroundButtonPressed == true
        isBackgroundButtonPressed = false;

        P = P.toggleBackgroundState();
        G = correctlyColourFreezeButtons(G, P);

        continue
    end

    %% Paused State
    if isPaused == true
        
        if isPauseButtonPressed == true
            isPauseButtonPressed = false;
            isBlending = true;
            isMouseClicked = false;
            isPaused = false;   
            G.but_pause.String = 'Pause On Last Preset';
            G.but_pause.BackgroundColor = normalButtonColour;
            continue
        end
        	
       continue 
    end
    %% Press pause button to pause searching
    if isPauseButtonPressed == true
        isPauseButtonPressed = false;
        isBlending = false;
        isMouseClicked = false;
        isPaused = true;
        
        G.but_pause.String = 'Resume Searching';
        G.but_pause.BackgroundColor = G.pauseColour;

        % Revert to last clicked preset
        imageEdited.CData = updateEditedImage2(img, P.presetA);
        continue
    end
    
    %% If mouse is clicked move to the next generation of presets
    if isMouseClicked == true
        
        P = P.iteratePresets(G.P1);
        
        if displayBarGraphs == true
            [barA, barB, barC] = updateBarPlots(barA,barB,barC,P.presetA,P.presetB,P.presetC);
        end
        
        isMouseClicked = false;
    end
    %%  Live Preset Blending Step
    if isBlending
        G.P1 = [MOUSE(1,1);MOUSE(1,2)];
        
        % has P1 Changed?
        if ~isequal(G.P1,G.P1current)
            
            G = updateGeometry(G);
            
            [alpha,beta,gamma] = calculatePresetRatios(G);
            
            P = P.mixPresets(alpha,beta,gamma); %S
            
            if displayBarGraphs == true
                barMix = updateMixBarPLot(barMix, P.presetMix);
            end
            
            imageEdited.CData = updateEditedImage2(img, P.presetMix);
            drawnow()
        end
    end
    
end

