% Test script for preset blending interface
% close all
numberOfParameterValuesToCheck = 5;

squaredErrorSumHistory = cell(1,numberOfParameterValuesToCheck);
for j = 1:5
    %% Create Initial Presets and related data structures
    presetRead = matfile('PresetStore.mat');
    presetArray = presetRead.presetStore;
    
    % Generate random target preset
    targetParams = rand(1,length(presetArray(1,:)));
    targetParams = checkLowInHighIn(targetParams);
    
    %% Option parameters
    selectedImageNumber = j;
    numberOfIterations = 20;
    
    displayProgress = false;
    %% Miscellaneous parameters
    currentGeneration = 1;
    screenSize = get(0,'Screensize');
    
    
    for i = 1:numberOfParameterValuesToCheck
        squaredErrorSumHistory{j}{i} = zeros(1,numberOfIterations);
    end
    
    % Options for Optimisation
    if displayProgress == true
        options = optimoptions('patternsearch','PlotFcn', {@psplotbestfLogScale}, 'OutputFcn', @plotOptimValues);
    else
        options = optimoptions('patternsearch');
    end
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
    tempScaling = 0.4;
    lastValueWeighting = 0.5;
    
    %tempScalingToCheck = logspace(-1,0.5,numberOfParameterValuesToCheck);
    lastValueWeightingToCheck = linspace(0,1,numberOfParameterValuesToCheck);
    %% Loop over full process to optimise metaparameters
    for i = 1:numberOfParameterValuesToCheck
        currentGeneration = 1;
        
        P = presetGeneratorMonteCarloMV(presetArray(selectedPresetNumbers(1),:),...
            presetArray(selectedPresetNumbers(2),:),...
            presetArray(selectedPresetNumbers(3),:),...
            initialTempOffset,...
            tempScaling,...
            lastValueWeightingToCheck(i));
        
        %% Display Results of Closest Match
        % figure(5)
        % title('Press Any Key to Continue')
        % subplot(2,2,1)
        % imshow(imgTargetLarger)
        % title('Target Image')
        % subplot(2,2,2)
        % imshow(updateEditedImage2(imgLarger, P.presetA));
        % title('1st Closest Match')
        % subplot(2,2,3)
        % imshow(updateEditedImage2(imgLarger, P.presetB));
        % title('2nd Closest Match')
        % subplot(2,2,4)
        % imshow(updateEditedImage2(imgLarger, P.presetC));
        % title('3rd Closest Match')
        % set(gcf,'Position',[screenSize(3)/6,0,screenSize(3)/1.5,screenSize(4)])
        %
        % annotation('textbox', [0.4, 0.47, 0.2, 0.06], 'string', 'Press Any Key To Continue', 'FontSize',25, 'Color','k', ...
        %     'HorizontalAlignment','Center', 'VerticalAlignment','Middle');
        % pause()
        % close figure 5
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
        subplot(1,3,2)
        imshow(updateEditedImage2(imgLarger, targetParams));
        title('Target Image')
        subplot(1,3,1)
        imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(1),:)));
        title('Initial Best Match')
        set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/0.95,screenSize(4)/2.1])
        subplot(1,3,3)
        currentImageDisplay = imshow(updateEditedImage2(imgLarger, presetArray(selectedPresetNumbers(1),:)));
        title('Current Best Image')
        
        %% Main Loop
        figure(1)
        
        %jpause()
        G.pauseText.Visible = 'off';
        % Currently if you click during the paused time it will trigger the
        % callback and cause a bug
        
        figure(6)
        searchingText = annotation('textbox', [0.4, 0.9, 0.2, 0.06], 'string', 'Searching For Optimal Setting', 'FontSize',25, 'Color','k', ...
            'HorizontalAlignment','Center', 'VerticalAlignment','Middle');
        set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/0.95,screenSize(4)/2.1])
        drawnow()
        hold on
        figure(1)
        while(currentGeneration <= numberOfIterations)
            %%  Optimisation Step
            %Optimise for Vector P1
            mousePosInitial = [0,0];
            
            %Call the solver patternsearch with the anonymous function, f: First on small image
            f = @(mousePos)evaluateFitnessUI(imgSmall, imgTargetSmall, mousePos, P.presetA, P.presetB, P.presetC);
            
            [optimumMousePos,squaredErrorSum] = patternsearch(f,mousePosInitial,[],[],[],[],[],[],options);
            squaredErrorSumHistory{j}{i}(currentGeneration) = squaredErrorSum;
            
            G.P1 = optimumMousePos';
            %% move to the next generation of presets
            G = updateGeometry(G);
            
            [alpha,beta,gamma] = calculatePresetRatios(G);
            
            P = P.mixPresets(alpha,beta,gamma);
            
            % Generate new presets
            P = P.iteratePresets();
            
            % Update Point History
            G.P1Sum = G.P1Sum + G.P1;
            G.P1History = [G.P1History, G.P1Sum];
            %% Render and Plot Output of Optimisation Stage
            if displayProgress == true
                
                historyPlot = updatePresetHistoryPlot(historyPlot,P.presetAHistory);
                
                barMix = updateMixBarPLot(barMix, P.presetMix);
                
                currentImageDisplay.CData = updateEditedImage2(imgLarger, P.presetA);
                
                P1HistoryPlot = updatePointHistoryPlot(P1HistoryPlot,G.P1History);
                
                [barA, barB, barC] = updateBarPlots(barA,barB,barC,P.presetA,P.presetB,P.presetC);
                
            end
            currentGeneration = currentGeneration + 1
            
        end
        
        figure(6)
        subplot(1,3,3)
        imshow(updateEditedImage2(imgLarger, P.presetA));
        title('Final Image')
        
        % figure(8)
        % subplot(3,3,j)
        % semilogy(squaredErrorSumHistory{j}{i})
        % hold on
        %Normalise so that initial error sum = 1 for comparison with other runs
        
        squaredErrorSumHistory{j}{i} = squaredErrorSumHistory{j}{i}/squaredErrorSumHistory{j}{i}(1);
        
        %lengendArray = [
        % legend('1','2','3','4','5','6','7','8','9','10')
        
    end
end

%% Plot graphs
figure(8)
for j = 1:5
    subplot(2,3,j)
    for i = 1:5
        semilogy(squaredErrorSumHistory{j}{i})
        hold on
        legend('1','2','3','4','5')
    end
    hold off
end
