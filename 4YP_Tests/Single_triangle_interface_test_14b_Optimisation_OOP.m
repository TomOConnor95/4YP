% Test script for preset blending interface
% close all
%% Create Initial Presets and related data structures
presetRead = matfile('PresetStore.mat');
presetArray = presetRead.presetStore;

% Generate random target preset

testPreset = 11;
targetParams = presetArray(testPreset,:);
presetArray(testPreset,:) = [];
% targetParams = rand(1,length(presetArray(1,:)));
% targetParams = checkLowInHighIn(targetParams);



        
%% Option parameters
selectedImageNumber = 1;
numberOfIterations = 200;

squaredErrorSumHistory = zeros(1,numberOfIterations);
parameterError = zeros(1,numberOfIterations);
displayProgress = false;

%% Miscellaneous parameters
currentGeneration = 1;
screenSize = get(0,'Screensize');


% Options for Optimisation
% if displayProgress == true
% options = optimoptions('patternsearch','PlotFcn', {@psplotbestfLogScale}, 'OutputFcn', @plotOptimValues);
% else
 options = optimoptions('patternsearch');
% end
options.InitialMeshSize = 10;
options.UseCompleteSearch = true;
options.Display = 'none';
%% Load Image for testing Filtering
imgFullSize = loadSelectedImage(selectedImageNumber);

imgSmall = imresize(imgFullSize,0.02);    % Reduce image size for increased speed

imgLarger = imresize(imgFullSize,0.2);    % Reduce image size for increased speed

imgTargetSmall = updateEditedImage2(imgSmall, targetParams);
imgTargetLarger = updateEditedImage2(imgLarger, targetParams);


%% Find closest match from preset store
[selectedPresetNumbers] = findClosestImages(imgLarger, imgTargetLarger, presetArray, 3);

initialTempOffset = 0.2;
tempScaling = 0.1;
lastValueWeighting = 0.3;

P = presetGeneratorMonteCarloMV(presetArray(selectedPresetNumbers(1),:),...
    presetArray(selectedPresetNumbers(2),:),...
    presetArray(selectedPresetNumbers(3),:),...
    initialTempOffset,...
    tempScaling,...
    lastValueWeighting);

%% Display Results of Closest Match
if displayProgress == true
    figure(5)
    title('Press Any Key to Continue')
    subplot(2,2,1)
    imshow(imgTargetLarger)
    title('Target Image')
    subplot(2,2,2)
    imshow(updateEditedImage2(imgLarger, P.presetA));
    title('1st Closest Match')
    subplot(2,2,3)
    imshow(updateEditedImage2(imgLarger, P.presetB));
    title('2nd Closest Match')
    subplot(2,2,4)
    imshow(updateEditedImage2(imgLarger, P.presetC));
    title('3rd Closest Match')
    set(gcf,'Position',[screenSize(3)/6,0,screenSize(3)/1.5,screenSize(4)])
    
    annotation('textbox', [0.4, 0.47, 0.2, 0.06], 'string', 'Press Any Key To Continue', 'FontSize',25, 'Color','k', ...
        'HorizontalAlignment','Center', 'VerticalAlignment','Middle');
    pause()
    close figure 5
end
%% Plot all geometry for Blending Interface
figure(1)
G = createBlendingGeometry();
%set(gcf,'Position',[(screenSize(3)/2 - screenSize(3)/26),screenSize(4)/2,screenSize(3)/3,screenSize(4)/2])

%% Create all necessary bar graphs
if displayProgress == true
figure(2)
[barA, barB, barC, barMix] = createBarGraphs(P.presetA,P.presetB,P.presetC);
end
%% Create plots to show evolution of parameters and Mouse Points
if displayProgress == true
figure(2)
subplot(2,7,[4,5,11,12])
historyPlot = createHistoryPlot(P.presetAHistory);

subplot(2,7,[6,7,13,14])
P1HistoryPlot = createPointHistoryPlot(G.P1History);
set(gcf,'Position',[-screenSize(3)/26,screenSize(4)/1.6,screenSize(3)/2,screenSize(4)/2.3])
end
%% Display Images
figure(6)
clf
% subplot(1,3,2)
imshow(updateEditedImage2(imgLarger, targetParams));
title('Target Image', 'FontSize', 16)
set(gca,'Position',[0,0,1,1])

figure(7)
% subplot(1,3,1)
imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(1),:)));
title('Initial Best Match', 'FontSize', 16)
set(gca,'Position',[0,0,1,1])

figure(8)
% subplot(1,3,3)
currentImageDisplay = imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(1),:)));
title('Current Best Image', 'FontSize', 16)
set(gca,'Position',[0,0,1,1])




%% Main Loop
figure(1)
if displayProgress == true
pause()
end
G.pauseText.Visible = 'off';
pause(0.01)
% Currently if you click during the paused time it will trigger the
% callback and cause a bug
figure(6)
searchingText = annotation('textbox', [0.4, 0.9, 0.2, 0.06], 'string', 'Searching For Optimal Setting', 'FontSize',25, 'Color','k', ...
        'HorizontalAlignment','Center', 'VerticalAlignment','Middle');
% set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/0.95,screenSize(4)/2.1])
drawnow()
hold on
figure(1)

while(currentGeneration < numberOfIterations)
    %%  Optimisation Step
    %Optimise for Vector P1
    mousePosInitial = G.A';
    
    %Call the solver patternsearch with the anonymous function, f: First on small image
    f = @(mousePos)evaluateFitnessUI(imgSmall, imgTargetSmall, mousePos, P.presetA, P.presetB, P.presetC);
    
    %[optimumMousePos1,squaredErrorSum1] = patternsearch(f,mousePosInitial,[],[],[],[],[],[],options1);
    [optimumMousePos1,squaredErrorSum1] = patternsearch(f,mousePosInitial,[],[],[],[],[],[],options);
    squaredErrorSumHistory(currentGeneration) = squaredErrorSum1;
    parameterError(currentGeneration) = sum((P.presetA-targetParams).^2);
    
    %     [optimumMousePos2,squaredErrorSum2] = fminunc(f, G.A');
    
    %     [minErrorSum, index] = min([squaredErrorSum1, squaredErrorSum2]);
    %     if index == 1
    G.P1 = optimumMousePos1';
    %     else
    %     G.P1 = optimumMousePos2';
    %     end
    
    %% move to the next generation of presets
    G = updateGeometry(G);
    
    [alpha,beta,gamma] = calculatePresetRatios(G);
    
    P = P.mixPresets(alpha,beta,gamma);
    
    % Generate new presets
    P = P.iteratePresets();
    
    % Update  Point History
    G.P1Sum = G.P1Sum + G.P1;
    G.P1History = [G.P1History, G.P1Sum];
    
    %% Render and Plot Output of Current Generation Stage
    
    % Display Images and graphs to show current progress
    if displayProgress == true
        
        currentImageDisplay.CData = updateEditedImage2(imgLarger, P.presetA);
        
        historyPlot = updatePresetHistoryPlot(historyPlot,P.presetAHistory);
        P1HistoryPlot = updatePointHistoryPlot(P1HistoryPlot,G.P1History);
        
        barMix = updateMixBarPLot(barMix, P.presetMix);
        
        [barA, barB, barC] = updateBarPlots(barA,barB,barC,P.presetA,P.presetB,P.presetC);
    end
    
    currentGeneration = currentGeneration + 1;
    
end
%%
figure(7)
% subplot(1,3,3)
searchingText.Visible = 'off';
imshow(updateEditedImage2(imgLarger, P.presetA));
set(gca,'Position',[0,0,1,1])

% title('Final Image')


figure(9)
hold off
plot(squaredErrorSumHistory)
figure(10)
plot(parameterError)

figure(11), clf
plot(squaredErrorSumHistory/squaredErrorSumHistory(1))
hold on
plot(parameterError/parameterError(1))