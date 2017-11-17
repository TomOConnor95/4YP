% Test script for preset blending interface

%% Create Initial Presets and related data structures
P = createPresetsForImageEditing();

%% Option parameters
initialTempOffset = 0.3;
tempOffset = initialTempOffset;
tempScaling = 0.5;
selectedImageNumber = 1;
savePresetsToFile = false;

%% Miscellaneous parameters
MOUSE = [0,0];              % Variable for mouse position to be stored in
isBlending = true;          % Is UI in blending mode?
isPressed = false;          % Has mouse been pressed?
isButtonPressed = false;    % Has push button been pressed?
isSearching = true;
isBeginBlending = false;
currentGeneration = 1;
screenSize = get(0,'Screensize');

%% Load Image for testing Filtering
imgFullSize = loadSelectedImage(selectedImageNumber);

img = imresize(imgFullSize,0.2);    % Reduce image size for increased speed
imgBW = rgb2gray(img);              % Create Black & White copy
imgBWFullSize = rgb2gray(imgFullSize);

%% Display Images
figure(4)
subplot(1,2,1)      % Original image for comparison
imageOriginal1 = imshow(img);
title('Original');

subplot(1,2,2);     % 3 layers of images: Original, B&W, Edited
imageOriginal2 = imshow(img);   hold on
imageBW = imshow(imgBW);
imageEdited = imshow(img);
title('Edited');
hold off
set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/1.2,screenSize(4)/2.1])
%% Create Photo mosaic to choose initail presets from
mosaicWidth = 3;
mosaicHeight = 3;

selectedPresetNumbers = chooseFromImageMosaic(img,imgBW, mosaicWidth, mosaicHeight);

presetRead = matfile('PresetStore.mat');
P.presetA = presetRead.presetStore(selectedPresetNumbers(1),:);
P.presetB = presetRead.presetStore(selectedPresetNumbers(2),:);
P.presetC = presetRead.presetStore(selectedPresetNumbers(3),:);

%% Plot all geometry for Blending Interface
figure(1)
G = createBlendingGeometry();
%set(gcf,'Position',[(screenSize(3)/2 - screenSize(3)/26),screenSize(4)/2,screenSize(3)/3,screenSize(4)/2])

%% Create all necessary bar graphs
figure(2)
[barA, barB, barC, barMix] = createBarGraphs(P.presetA,P.presetB,P.presetC);

%% Create plots to show evolution of parameters and Mouse Points
figure(2)
subplot(2,7,[4,5,11,12])
historyPlot = createHistoryPlot(P.presetAHistory);

subplot(2,7,[6,7,13,14])
P1HistoryPlot = createPointHistoryPlot(G.P1History);
set(gcf,'Position',[-screenSize(3)/26,screenSize(4)/1.6,screenSize(3)/2,screenSize(4)/2.3])

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
        P.presetMix = P.presetA;
        [imageEdited, imageBW] = updateEditedImage(img, imageEdited, imageBW, P.presetMix);
        
        if savePresetsToFile == true
            presetSave = matfile('PresetStore.mat','Writable',true);
            presetSave.presetStore(1+length(presetSave.presetStore(:,1)),:) = P.presetA;
        end
        % Plot full size final output in new figure
        figure;
        imageFullSize = imshow(imgFullSize);   hold on;
        imageBWFullSize = imshow(imgBWFullSize);
        imageEditedFullSize = imshow(imgFullSize);
        [imageEditedFullSize, imageBWFullSize] = ...
            updateEditedImage(imgFullSize, imageEditedFullSize, imageBWFullSize, P.presetMix);
    end
    %% If mouse is clicked move to the next generation of presets
    if isPressed == true
        currentGeneration = currentGeneration + 1;
        % Generate new presets
        [P,tempOffset] = generateNewPresets(P,tempOffset,tempScaling);
        
        % Update plot to show evolution of parameters
        historyPlot = updatePresetHistoryPlot(historyPlot,P.presetAHistory);
        
        % Update Plot showing Point History
        G.P1Sum = G.P1Sum + G.P1;
        G.P1History = [G.P1History, G.P1Sum];
        P1HistoryPlot = updatePointHistoryPlot(P1HistoryPlot,G.P1History);
        
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
            
            P.presetMix = mixPresets(P.presetA,P.presetB,P.presetC,alpha,beta,gamma);
            
            barMix = updateMixBarPLot(barMix, P.presetMix);

            [imageEdited, imageBW] = updateEditedImage(img, imageEdited, imageBW, P.presetMix);

        end
    end
    
end

