% Test script for preset blending interface
% close all
%% Create Initial Presets and related data structures
P = createPresetsForImageEditing();

% Generate random target preset
targetParams = rand(1,length(P.presetA));
targetParams = checkLowInHighIn(targetParams);

%% Option parameters
initialTempOffset = 0.3;
tempOffset = initialTempOffset;
tempScaling = 0.5;
selectedImageNumber = 2;
%savePresetsToFile = false;

numberOfIterations = 50;

%% Miscellaneous parameters
MOUSE = [0,0];              % Variable for mouse position to be stored in
%isBlending = true;          % Is UI in blending mode?
%isPressed = false;          % Has mouse been pressed?
%isButtonPressed = false;    % Has push button been pressed?
%isSearching = true;
%isBeginBlending = false;
currentGeneration = 1;
screenSize = get(0,'Screensize');

% Options for Optimisation
options = optimoptions('patternsearch','PlotFcn', @psplotbestfLogScale);
%options.Display = 'iter';

%% Load Image for testing Filtering
imgFullSize = loadSelectedImage(selectedImageNumber);

imgSmall = imresize(imgFullSize,0.02);    % Reduce image size for increased speed

imgLarger = imresize(imgFullSize,0.2);    % Reduce image size for increased speed

imgTargetSmall = updateEditedImage2(imgSmall, targetParams);
imgTargetLarger = updateEditedImage2(imgLarger, targetParams);


%% Find closest match from preset store
presetRead = matfile('PresetStore.mat');
presetArray = presetRead.presetStore;

[selectedPresetNumbers] = findClosestImages(imgLarger, imgTargetLarger, presetArray, 3);

%% Display Results of Closest Match
figure(5)
title('Press Any Key to Continue')
subplot(2,2,1)
imshow(imgTargetLarger)
title('Target Image')
subplot(2,2,2)
imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(1),:)));
title('1st Closest Match')
subplot(2,2,3)
imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(2),:)));
title('2nd Closest Match')
subplot(2,2,4)
imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(3),:)));
title('3rd Closest Match')
set(gcf,'Position',[screenSize(3)/6,0,screenSize(3)/1.5,screenSize(4)])

annotation('textbox', [0.4, 0.47, 0.2, 0.06], 'string', 'Press Any Key To Continue', 'FontSize',25, 'Color','k', ...
    'HorizontalAlignment','Center', 'VerticalAlignment','Middle');
pause()
close figure 5
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

%% Display Images
figure(6)
clf
subplot(1,3,2)
imshow(updateEditedImage2(imgLarger, targetParams));
title('Target Image')
subplot(1,3,1)
imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(1),:)));
title('Initial Best Match')
set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/0.95,screenSize(4)/2.1])


%% Main Loop
figure(1)

pause()
G.pauseText.Visible = 'off';
% Currently if you click during the paused time it will trigger the
% callback and cause a bug

while(currentGeneration < numberOfIterations)
    %%  Optimisation Step
    %Optimise for Vector P1
    mousePosInitial = [0,0];
    
    %Call the solver patternsearch with the anonymous function, f: First on small image
    f = @(mousePos)evaluateFitnessUI(imgSmall, imgTargetSmall, mousePos, P.presetA, P.presetB, P.presetC);
    
    [optimumMousePos,~] = patternsearch(f,mousePosInitial,[],[],[],[],[],[],options);
    
    
    G.P1 = optimumMousePos';
    
    %% Render and Plot Output of Optimisation Stage
    G = updateGeometry(G);
    
    [alpha,beta,gamma] = calculatePresetRatios(G);
    
    P.presetMix = mixPresetsF(P.presetA,P.presetB,P.presetC,alpha,beta,gamma);
    
    barMix = updateMixBarPLot(barMix, P.presetMix);
    
    figure(6)
    subplot(1,3,3)
    imshow(updateEditedImage2(imgLarger, P.presetA));
    title('Current Best Image')
    
    %% move to the next generation of presets
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
    
    currentGeneration = currentGeneration + 1;
    
end

figure(6)
subplot(1,3,3)
imshow(updateEditedImage2(imgLarger, P.presetA));
title('Final Image')