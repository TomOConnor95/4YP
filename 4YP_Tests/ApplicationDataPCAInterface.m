classdef ApplicationDataPCAInterface < handle
    properties (SetAccess = public, GetAccess = public)
        % Preset Data
        presetStore;
        presetStoreVaried;
        
        presetCategories;
        
        presetPositions;
        
        nameStrings;
        typeStrings;
        
        % PCA
        coeff;
        score;
        latent;
        
        idxX = 1;
        idxY = 2;
        idxR = 3;
        idxG = 4;
        idxB = 5;
        
        minX; maxX;
        minY; maxY;
        minR; maxR;
        minG; maxG;
        minB; maxB;
        
        coeffCell;
        
        presetPCAParams;
        
        % UI elements - PCA Voronoi
        selectedColour = [1.0, 0, 0];
        mouseOverColour = [0, 0, 1.0];
        mouseOverSelectedColour = [1.0, 0.4, 0.75];
        
        normaliseHistogram = true;
        histBlend = 0.9;
        histParams;
        
        colours;
        
        patches;
        
        ax;     %Axes fot PCA plot
        
        variedPresetMarkers;
        variedPresetLines;
        
        leftSlidersPanel;
        rightSlidersPanel;
        leftSliders;
        rightSliders;
        
        leftNumDisplays;
        rightNumDisplays;
        
        timeColour = [0.94, 0.6, 0.6];
        timbreColour = [0.94, 0.94, 0.6];
        normalColour = [0.4,0.5,0.9];
        
        popup;
        
        blendModeButton;
        
        categoriesPanel;
        pianoKeysButton;
        pluckedMalletButton;
        bassButton;
        synthLeadButton;
        synthPadButton;
        rhythmicButton;
        
        categoriesSelected = [0, 0, 0, 0, 0, 0];
        
        idxCurrent = 1;
        idxSelected = [];
        idxPopupSelected = [];
        
        % UI elements - time/timbre
        timeData;
        timePlots;
        
        timbreData;
        timbrePlots;
        
        % Connectivity
        u; % UDP adress
        
        midiControls;
        
        blendingAppData;
    end
    
    methods
        % Constructor
        function obj = ApplicationDataPCAInterface()
            
            % Open UDP connection
            obj.u = udp('127.0.0.1',57120);
            fopen(obj.u);
            
            %----------------------------------------------------------%
            %----------------------Presets-----------------------------%
            %----------------------------------------------------------%
            
            % Get nameStrings and TypeStrings
            [~, obj.nameStrings, obj.typeStrings] = createPresetAforOSC();
            
            % Load Presets
            presetRead = matfile('PresetStoreSC.mat');
            obj.presetStore = presetRead.presetStore;
            
            obj.presetStoreVaried = obj.presetStore;
            
            obj.presetPCAParams = repmat({zeros(2,4)},1,length(obj.presetStore(:,1)));
            
            obj.variedPresetMarkers = cell(1,length(obj.presetStore(:,1)));
            obj.variedPresetLines = cell(1,length(obj.presetStore(:,1)));
            
            obj.presetCategories = createPresetCategories();
            %----------------------------------------------------------%
            %------------------PCA Calculations------------------------%
            %----------------------------------------------------------%
            
            % Perform PCA on presets
            calculatePresetPCA(obj);
            
            %----------------------------------------------------------%
            %----------------------Figures & Plots---------------------%
            %----------------------------------------------------------%
            
            % Create voronoi diagram from global PCA preset locations
            createPresetVoronoi(obj);
            
            % Add number to display the selected Preset
            % Create pop-up menu
            createPopup(obj);
            
            % Sliders - To adjust the principal components of presets
            createSliders(obj);
            
            % NumberDisplays
            createNumDisplays(obj);
            
            % Time plots
            createTimePlots(obj);
            
            % Timbre plots
            createTimbrePlots(obj);
            
            % Blend Mode Button
            createBlendModeButton(obj);
            
            % Category Buttons
            createCategoryButtons(obj);
            
            %----------------------------------------------------------%
            %----------------------Miscellaneous-----------------------%
            %----------------------------------------------------------%
            
            %Initialise seding data to command line
            dispstat('','init')
            
            %Initilasise Midi CC input
            isMidiEnabled = true;
            if isMidiEnabled == true
                initialiseMidiInput(obj);
            end
            
            % Set up Blending App
            obj.blendingAppData = ApplicationDataBlendingInterface(obj);
            
        end
        
    end
end

%----------------------------------------------------------%
%----------------------Callbacks---------------------------%
%----------------------------------------------------------%
function patchClicked (object, eventdata, idx, appData)
    % writes continuous mouse position to base workspace
    disp(['Patch ', num2str(idx), ' Clicked'])

    if ~ismember(idx, appData.idxSelected)
                appData.idxSelected = [appData.idxSelected, idx];

                %appData.patches{idx}.FaceColor = appData.selectedColour;
                appData.patches{idx}.EdgeColor = appData.selectedColour;

                if length(appData.idxSelected) == 3
                    
                    disp('3 Presets Selected!');
                    appData.blendModeButton.Enable = 'on';
                end
            
                
            else

                appData.idxSelected(appData.idxSelected == idx) = [];

                %appData.patches{idx}.FaceColor = appData.mouseOverColour;
                appData.patches{idx}.EdgeColor = appData.mouseOverColour;

    end   
    %drawnow()
    
end

function mouseMoving (object, eventdata, appData)
% writes continuous mouse position to base workspace
MOUSE = get (gca, 'CurrentPoint');
mousePos = MOUSE(1,1:2);

if ~isempty(appData.idxSelected) && mousePosOutOfRange(mousePos)
    idx = appData.idxSelected(length(appData.idxSelected));
else
    closestPoint=bsxfun(@minus,appData.presetPositions,mousePos);
    [~,idx]=min(hypot(closestPoint(:,1),closestPoint(:,2)));
    %disp(['Index: ', num2str(idx)])
end

% Has index changed?
if idx ~= appData.idxCurrent
    
    switchToPreset(idx, appData);

end

end

function leftSliderCallback (object, eventdata, idx, appData)
appData.leftNumDisplays{idx}.String = num2str(appData.leftSliders{idx}.Value);

storeLeftSliderPosition(appData)

updatePCAWeightsAndSendParams(appData)

updatePresetVariedMarker(appData)

% Update Timbre Plots
appData.timbreData = timbrePlotDataFromPreset(appData.presetStoreVaried(appData.idxCurrent,:));
appData.timbrePlots = updateTimbrePlots(appData.timbrePlots, appData.timbreData); 

dispstat(sprintf(preset2string(appData.presetStoreVaried(appData.idxCurrent, :),...
                                appData.nameStrings)));
end
function rightSliderCallback (object, eventdata, idx, appData)
appData.rightNumDisplays{idx}.String = num2str(appData.rightSliders{idx}.Value);

storeRightSliderPosition(appData)

updatePCAWeightsAndSendParams(appData)

updatePresetVariedMarker(appData)

% Update Time Plots
appData.timeData = timePlotDataFromPreset(appData.presetStoreVaried(appData.idxCurrent,:));
appData.timePlots = updateTimePlots(appData.timePlots, appData.timeData); 

dispstat(sprintf(preset2string(appData.presetStoreVaried(appData.idxCurrent, :),...
                                appData.nameStrings)));
end

function leftTextCallback (object, eventdata, idx, appData)
% Works with Right click
appData.leftNumDisplays{idx}.String = num2str(0);
appData.leftSliders{idx}.Value = 0;

storeLeftSliderPosition(appData)

updatePCAWeightsAndSendParams(appData)

updatePresetVariedMarker(appData)

% Update Timbre Plots
appData.timbreData = timbrePlotDataFromPreset(appData.presetStoreVaried(appData.idxCurrent,:));
appData.timbrePlots = updateTimbrePlots(appData.timbrePlots, appData.timbreData); 

dispstat(sprintf(preset2string(appData.presetStoreVaried(appData.idxCurrent, :),...
                                appData.nameStrings)));
end
function rightTextCallback (object, eventdata, idx, appData)
% Works with Right click
appData.rightNumDisplays{idx}.String = num2str(0);
appData.rightSliders{idx}.Value = 0;

storeRightSliderPosition(appData)

updatePCAWeightsAndSendParams(appData)

updatePresetVariedMarker(appData)

% Update Time Plots
appData.timeData = timePlotDataFromPreset(appData.presetStoreVaried(appData.idxCurrent,:));
appData.timePlots = updateTimePlots(appData.timePlots, appData.timeData); 

dispstat(sprintf(preset2string(appData.presetStoreVaried(appData.idxCurrent, :),...
                                appData.nameStrings)));
end

function blendModeButtonCallback (object, eventdata, appData)
disp('Blend Mode Button Clicked');
appData.idxSelected;

presetA = appData.presetStoreVaried(appData.idxSelected(1),:);
presetB = appData.presetStoreVaried(appData.idxSelected(2),:);
presetC = appData.presetStoreVaried(appData.idxSelected(3),:);

appData.blendingAppData.P = presetGeneratorSCMonteCarloMV(presetA, presetB, presetC, appData.blendingAppData);

sendAllStructParamsOverOSC(appData.blendingAppData.P.presetA,...
    appData.blendingAppData.nameStrings,...
    appData.blendingAppData.typeStrings,...
    appData.blendingAppData.u);

set(figure(1), 'Visible', 'on')
if appData.blendingAppData.displayBarGraphs == true
    set(figure(2), 'Visible', 'on')
end
%set(figure(3), 'Visible', 'on')
set(figure(4), 'Visible', 'on')

set(figure(5), 'Visible', 'off')
%set(figure(6), 'Visible', 'off')
%set(figure(7), 'Visible', 'off')

figure(1)
axes(appData.blendingAppData.G.ax)
appData.blendingAppData.isBlending = false;
appData.blendingAppData.isPaused = true;

appData.blendingAppData.G.panel.Visible = 'on';
appData.blendingAppData.phPanel.Visible = 'off';

appData.blendingAppData.pauseButton.String = 'Begin Searching';
appData.blendingAppData.pauseButton.BackgroundColor = appData.blendingAppData.pauseColour;
end

function categoryButtonCallback (object, eventdata, idx, appData)

appData.categoriesSelected(idx) = 1 - appData.categoriesSelected(idx);

normalButtonColour = [0.94, 0.94, 0.94];

categoryColours = {[1,0,0], [0,1,0], [0,0,1], [1,1,0], [1,0,1], [0,1,1]};
switch idx
    case 1
        disp('Piano/Keys button Pressed')
        if appData.categoriesSelected(idx) ==1
            appData.pianoKeysButton.BackgroundColor = categoryColours{idx};
        else
            appData.pianoKeysButton.BackgroundColor = normalButtonColour;
        end
    case 2
        disp('Plucked/Mallet button Pressed')
        if appData.categoriesSelected(idx) ==1
            appData.pluckedMalletButton.BackgroundColor = categoryColours{idx};
        else
            appData.pluckedMalletButton.BackgroundColor = normalButtonColour;
        end
    case 3
        disp('Bass button Pressed')
        if appData.categoriesSelected(idx) ==1
            appData.bassButton.BackgroundColor = categoryColours{idx};
        else
            appData.bassButton.BackgroundColor = normalButtonColour;
        end
    case 4
        disp('Synth Lead button Pressed')
        if appData.categoriesSelected(idx) ==1
            appData.synthLeadButton.BackgroundColor = categoryColours{idx};
        else
            appData.synthLeadButton.BackgroundColor = normalButtonColour;
        end
    case 5
        disp('Synth Pad button Pressed')
        if appData.categoriesSelected(idx) ==1
            appData.synthPadButton.BackgroundColor = categoryColours{idx};
        else
            appData.synthPadButton.BackgroundColor = normalButtonColour;
        end
    case 6
        disp('Rhythmic button Pressed')
        if appData.categoriesSelected(idx) ==1
            appData.rhythmicButton.BackgroundColor = categoryColours{idx};
        else
            appData.rhythmicButton.BackgroundColor = normalButtonColour;
        end
end

if isequal(appData.categoriesSelected, [0,0,0,0,0,0])
    for i = 1:length(appData.presetCategories)
        appData.patches{i}.FaceColor = appData.colours{i};
    end
else
    for i = 1:length(appData.presetCategories)
        if isequal(appData.presetCategories{i}.*appData.categoriesSelected, [0,0,0,0,0,0])
            appData.patches{i}.FaceColor = appData.colours{i}/3;
        else
        combinedColour = sqrt((appData.presetCategories{i}.*appData.categoriesSelected)*...
            (cell2mat(categoryColours')).^2/length(nonzeros(appData.categoriesSelected)));
        combinedColour(combinedColour > 0) = mapRange(combinedColour(combinedColour > 0), 0,1,0.7,1);
        appData.patches{i}.FaceColor = combinedColour.*([0.7, 0.7, 0.7]...
                + 0.3*[appData.colours{i}(1), appData.colours{i}(2), appData.colours{i}(3)]);

        end
    end
end
end

function midiCallback(midicontrolsObject, idx, appData)

midiCC = midiread(midicontrolsObject);
%disp([num2str(idx), ': ', num2str(midiCC)])

if idx < 5
    appData.leftSliders{idx}.Value = (midiCC * 10) - 5;

    appData.leftNumDisplays{idx}.String = num2str(appData.leftSliders{idx}.Value);

    storeLeftSliderPosition(appData)
     
else
    appData.rightSliders{idx-4}.Value = (midiCC * 10) - 5;
 
    appData.rightNumDisplays{idx-4}.String = num2str(appData.rightSliders{idx-4}.Value);

    storeRightSliderPosition(appData)
end

updatePCAWeightsAndSendParams(appData)

updatePresetVariedMarker(appData)

if idx < 5
    % Update Timbre Plots
    appData.timbreData = timbrePlotDataFromPreset(appData.presetStoreVaried(appData.idxCurrent,:));
    appData.timbrePlots = updateTimbrePlots(appData.timbrePlots, appData.timbreData); 
else
    % Update Time Plots
    appData.timeData = timePlotDataFromPreset(appData.presetStoreVaried(appData.idxCurrent,:));
    appData.timePlots = updateTimePlots(appData.timePlots, appData.timeData);  
end
dispstat(sprintf(preset2string(appData.presetStoreVaried(appData.idxCurrent, :),...
                                appData.nameStrings)));
 
end

function numPopupCallback(object, eventdata, appData)
    idx = appData.popup.Value;
    
    switchToPreset(idx, appData);
    
    if ~ismember(idx, appData.idxSelected)
        appData.idxSelected = [appData.idxSelected, idx];

        appData.patches{idx}.EdgeColor = appData.selectedColour;
    end
    
    if ~isempty(appData.idxPopupSelected)
        appData.idxSelected(appData.idxSelected == appData.idxPopupSelected) = [];
        
        appData.patches{appData.idxPopupSelected}.FaceColor = appData.colours{appData.idxPopupSelected};
        appData.patches{appData.idxPopupSelected}.EdgeColor = [0,0,0];
        appData.patches{appData.idxPopupSelected}.LineWidth = 0.5;
    end
     
    appData.idxPopupSelected = idx;

    appData.patches{idx}.EdgeColor = appData.selectedColour;
    
end
%----------------------------------------------------------%
%----------------------Misc Functions----------------------%
%----------------------------------------------------------%

function updatePCAWeightsAndSendParams(appData)
          % Reshape is column elementwise so use the transpose!
pcaWeights = reshape(appData.presetPCAParams{appData.idxCurrent}',...   
            1, 2*length(appData.presetPCAParams{appData.idxCurrent}));
            
% Alter Selected preset
appData.presetStoreVaried(appData.idxCurrent,:) = adjustPresetWithPCA(...
    appData.presetStore(appData.idxCurrent,:), appData.coeffCell,...
    pcaWeights);

sendAllStructParamsOverOSC(appData.presetStoreVaried(appData.idxCurrent,:),...
    appData.nameStrings, appData.typeStrings, appData.u);
end

function storeLeftSliderPosition(appData)
% Store left slider position for the currently selected preset
appData.presetPCAParams{appData.idxCurrent}(1,:) = [...
                                appData.leftSliders{1}.Value,...
                                appData.leftSliders{2}.Value,...
                                appData.leftSliders{3}.Value,...
                                appData.leftSliders{4}.Value,...
                                ];
end

function storeRightSliderPosition(appData)
% Store right slider position for the currently selected preset
appData.presetPCAParams{appData.idxCurrent}(2,:) = [...
                                appData.rightSliders{1}.Value,...
                                appData.rightSliders{2}.Value,...
                                appData.rightSliders{3}.Value,...
                                appData.rightSliders{4}.Value,...
                                ];
end

function updatePresetVariedMarker(appData)
alteredPresetFlattened = cell2mat(appData.presetStoreVaried(appData.idxCurrent,:));
mu = mean(cell2mat(appData.presetStoreVaried));
alteredPresetFlattened = alteredPresetFlattened - mu;

idxMax = max([appData.idxX, appData.idxY, appData.idxR, appData.idxG, appData.idxB]);
testScore = alteredPresetFlattened*appData.coeff(:,1:idxMax);

idxX = appData.idxX; 
idxY = appData.idxY; 
idxR = appData.idxR;
idxG = appData.idxG;
idxB = appData.idxB;

if appData.normaliseHistogram == true
    % Need to apply the same historam normalisation to the new positition
    testScore(idxX) = newPointHistogramNormalisation(...
        testScore(idxX),appData.histParams.nX, appData.histParams.edgesX, appData.histBlend);
    
    testScore(idxY) = newPointHistogramNormalisation(...
        testScore(idxY),appData.histParams.nY, appData.histParams.edgesY, appData.histBlend);
    
    testScore(idxR) = newPointHistogramNormalisation(...
        testScore(idxR),appData.histParams.nR, appData.histParams.edgesR, appData.histBlend);
    
    testScore(idxG) = newPointHistogramNormalisation(...
        testScore(idxG),appData.histParams.nG, appData.histParams.edgesG, appData.histBlend);
    
    testScore(idxB) = newPointHistogramNormalisation(...
        testScore(idxB),appData.histParams.nB, appData.histParams.edgesB, appData.histBlend);
end
    % Maybe should store the minimum and maximum value to avoid recalculation
    x = mapRange(testScore(idxX), appData.minX, appData.maxX, 0.05, 0.95);
    y = mapRange(testScore(idxY), appData.minY, appData.maxY, 0.05, 0.95);
    R = bound(mapRange(testScore(idxR), appData.minR, appData.maxR, 0.1, 1), 0, 1);
    G = bound(mapRange(testScore(idxG), appData.minG, appData.maxG, 0.1, 1), 0, 1);
    B = bound(mapRange(testScore(idxB), appData.minB, appData.maxB, 0.1, 1), 0, 1);

if isempty(appData.variedPresetMarkers{appData.idxCurrent})
    appData.variedPresetLines{appData.idxCurrent} = plot(...
        [x, appData.presetPositions(appData.idxCurrent, 1)],...
        [y, appData.presetPositions(appData.idxCurrent, 2)],...
        'Color', [0,0,0], 'LineWidth', 1.5);
    
    appData.variedPresetMarkers{appData.idxCurrent} =  plot(x, y, 'o',...
        'MarkerFaceColor', [R, G, B],...
        'MarkerEdgeColor', [0,0,0],...
        'MarkerSize', 15);
else
    appData.variedPresetMarkers{appData.idxCurrent}.XData = x; 
    appData.variedPresetMarkers{appData.idxCurrent}.YData = y;
    appData.variedPresetMarkers{appData.idxCurrent}.MarkerFaceColor = [R,G,B];
    
    appData.variedPresetLines{appData.idxCurrent}.XData(1) = x;
    appData.variedPresetLines{appData.idxCurrent}.YData(1) = y;
end
end

function switchToPreset(idx, appData)
    
    % Change parameters to this preset
    sendAllStructParamsOverOSC(appData.presetStoreVaried(idx,:),...
        appData.nameStrings, appData.typeStrings, appData.u);
    
    % Update Time Plots
    appData.timeData = timePlotDataFromPreset(appData.presetStoreVaried(idx,:));
    appData.timePlots = updateTimePlots(appData.timePlots, appData.timeData); 
    
    % Update Timbre Plots
    appData.timbreData = timbrePlotDataFromPreset(appData.presetStoreVaried(idx,:));
    appData.timbrePlots = updateTimbrePlots(appData.timbrePlots, appData.timbreData); 
    
    % Update Preset number popup
    appData.popup.Value = idx;
    
    % Display Parameter Values to Command Line
    dispstat(sprintf(preset2string(appData.presetStoreVaried(appData.idxCurrent, :),...
                                appData.nameStrings)));
    % Old Patch
    if ~ismember(appData.idxCurrent, appData.idxSelected)
        
        %appData.patches{appData.idxCurrent}.FaceColor = appData.colours{appData.idxCurrent};
        appData.patches{appData.idxCurrent}.EdgeColor = [0,0,0];
        appData.patches{appData.idxCurrent}.LineWidth = 0.5;
    else
        %appData.patches{appData.idxCurrent}.FaceColor = appData.selectedColour;
        appData.patches{appData.idxCurrent}.EdgeColor = appData.selectedColour;
    end
    
    % New patch
    if ~ismember(idx, appData.idxSelected)
        
        %appData.patches{idx}.FaceColor = appData.mouseOverColour;
        appData.patches{idx}.EdgeColor = appData.mouseOverColour;
        appData.patches{idx}.LineWidth = 5;
        
    else
        %appData.patches{idx}.FaceColor = appData.mouseOverSelectedColour;
        appData.patches{idx}.EdgeColor = appData.mouseOverSelectedColour;
        appData.patches{idx}.LineWidth = 5;
    end
    
    % Update sliders to new preset
    appData.leftSliders{1}.Value = appData.presetPCAParams{idx}(1,1);
    appData.leftSliders{2}.Value = appData.presetPCAParams{idx}(1,2);
    appData.leftSliders{3}.Value = appData.presetPCAParams{idx}(1,3);
    appData.leftSliders{4}.Value = appData.presetPCAParams{idx}(1,4);
    
    appData.rightSliders{1}.Value = appData.presetPCAParams{idx}(2,1);
    appData.rightSliders{2}.Value = appData.presetPCAParams{idx}(2,2);
    appData.rightSliders{3}.Value = appData.presetPCAParams{idx}(2,3);
    appData.rightSliders{4}.Value = appData.presetPCAParams{idx}(2,4);
    
    % Update NumDisplays top new preset
    appData.leftNumDisplays{1}.String = num2str(appData.presetPCAParams{idx}(1,1));
    appData.leftNumDisplays{2}.String = num2str(appData.presetPCAParams{idx}(1,2));
    appData.leftNumDisplays{3}.String = num2str(appData.presetPCAParams{idx}(1,3));
    appData.leftNumDisplays{4}.String = num2str(appData.presetPCAParams{idx}(1,4));
    
    appData.rightNumDisplays{1}.String = num2str(appData.presetPCAParams{idx}(2,1));
    appData.rightNumDisplays{2}.String = num2str(appData.presetPCAParams{idx}(2,2));
    appData.rightNumDisplays{3}.String = num2str(appData.presetPCAParams{idx}(2,3));
    appData.rightNumDisplays{4}.String = num2str(appData.presetPCAParams{idx}(2,4));
    
    appData.idxCurrent = idx;
    %drawnow()
end

function calculatePresetPCA(appData)

presetStoreFlattened = cell2mat(appData.presetStore);

mu = mean(presetStoreFlattened);

presetStoreFlattened = presetStoreFlattened - mu;


[coeff, score, latent] = pca(presetStoreFlattened);

appData.coeff = coeff;
appData.score = score;
appData.latent = latent;

%appData.coeffCell = createCoeffCell(appData.coeff);

x = score(:,[appData.idxX, appData.idxY]);

if appData.normaliseHistogram == true
    [xNorm, nX, edgesX] = histogramNormalisation(x(:,1), appData.histBlend);
    [yNorm, nY, edgesY] = histogramNormalisation(x(:,2), appData.histBlend);
    
    appData.histParams.nX = nX;
    appData.histParams.nY = nY;
    appData.histParams.edgesX = edgesX;
    appData.histParams.edgesY = edgesY;
    
    x = [xNorm, yNorm];
end

appData.minX = min(x(:,1));
appData.maxX = max(x(:,1));
appData.minY = min(x(:,2));
appData.maxY = max(x(:,2));

x(:,1) = mapVectorRange(x(:,1), 0.05,0.95);
x(:,2) = mapVectorRange(x(:,2), 0.05,0.95);

appData.presetPositions = x;

% Colours
R = score(:,appData.idxR);
G = score(:,appData.idxG);
B = score(:,appData.idxB);

if appData.normaliseHistogram == true
    [R, nR, edgesR] = histogramNormalisation(R, appData.histBlend);
    [G, nG, edgesG] = histogramNormalisation(G, appData.histBlend);
    [B, nB, edgesB] = histogramNormalisation(B, appData.histBlend);
    
    appData.histParams.nR = nR;
    appData.histParams.nG = nG;
    appData.histParams.nB = nB;
    appData.histParams.edgesR = edgesR;
    appData.histParams.edgesG = edgesG;
    appData.histParams.edgesB = edgesB;
end

appData.minR = min(R);
appData.maxR = max(R);
appData.minG = min(G);
appData.maxG = max(G);
appData.minB = min(B);
appData.maxB = max(B);

R = mapVectorRange(R, 0.1,1);
G = mapVectorRange(G, 0.1,1);
B = mapVectorRange(B, 0.1,1);

appData.colours = num2cell([R,G,B],2);

% Perform PCA on presets - timbre parameters
[timbreCoeff, timbreScore, timbreLatent] = pca(presetStoreFlattened(:,1:72));

% Perform PCA on presets - time parameters
[timeCoeff, timeScore, timeLatent] = pca(presetStoreFlattened(:,73:94));

coeffCombined = [timbreCoeff(:,1:4), zeros(size(timbreCoeff(:,1:4)));...
                 zeros(size(timeCoeff(:,1:4))), timeCoeff(:,1:4), ];
appData.coeffCell = createCoeffCell(coeffCombined);
end

function [xOut, n, edges] = histogramNormalisation(xIn, histBlend, numBins)

if nargin == 2
    numBins =6;
end

[n, edges] = histcounts(xIn, numBins);

xNorm = xIn;

nSumX = 0;

for i = 1:numBins
    xNorm(xIn >= edges(i) & xIn < edges(i+1)) = ...
    	mapRange(xIn(xIn >= edges(i) & xIn < edges(i+1)),...
        edges(i), edges(i+1), nSumX, nSumX + n(i));
    
    nSumX = nSumX + n(i);
end

%xOut = xNorm;
xOut = histBlend*xNorm + (1-histBlend)*xIn;

end

function [score] = newPointHistogramNormalisation(scoreIn, n, edges, histBlend)
    lowerEdgeIdx = find(edges < scoreIn, 1, 'last' );
    
    if isempty(lowerEdgeIdx)
        score = 0;
    else
        if lowerEdgeIdx == 0
        lowerSum = 0;
        else
            lowerSum = sum(n(1:lowerEdgeIdx-1));
        end

        if lowerEdgeIdx == length(edges)
            %disp('Out of range')
            score = mapRange(scoreIn,...
                        edges(lowerEdgeIdx), edges(lowerEdgeIdx)*1.1,...
                        lowerSum, lowerSum*1.1);
        else
        score = mapRange(scoreIn,...
                        edges(lowerEdgeIdx), edges(lowerEdgeIdx + 1),...
                        lowerSum, lowerSum + n(lowerEdgeIdx));
        end
    end
    score = histBlend*score + (1-histBlend)*scoreIn;
end
%----------------------------------------------------------%
%----------------------UI Objects--------------------------%
%----------------------------------------------------------%

function createPresetVoronoi(appData)
figure(5), clf, 
set(figure(5), 'MenuBar', 'none', 'ToolBar' ,'none')

appData.ax = axes('position',[0,0.2,1,0.7],...
        'Units','Normalized',...
        'XGrid','off',...
        'XMinorGrid','off',...
        'XTickLabel',[],...
        'YTickLabel',[],...
        'Xlim', [0,1],...
        'Ylim', [0,1]);
hold on
appData.patches = filledVoronoi(appData.presetPositions, appData.colours, appData.ax);

for i = 1:length(appData.presetStore(:,1))
    set(appData.patches{i}, 'ButtonDownFcn', {@patchClicked, i, appData})
    set(appData.patches{i}, 'HitTest', 'On')  
end

plot(appData.ax, appData.presetPositions(:,1), appData.presetPositions(:,2),...
    'b+', 'HitTest', 'off', 'PickableParts', 'none')

set(gcf, 'WindowButtonMotionFcn', {@mouseMoving, appData});
%set(gca, 'Position', [0.1300 0.2100 0.7750 0.7150]);
end

function createSliders(appData)
appData.leftSlidersPanel = uipanel('Title', 'Timbre PCA 1-4',...
                                'TitlePosition','righttop',...
                                'Position',[0.2, 0, 0.39, 0.2]);
appData.rightSlidersPanel = uipanel('Title', 'Time PCA 1-4',...
                                'TitlePosition','lefttop',...
                                'Position',[0.6, 0, 0.39, 0.2]);

appData.leftSliders = cell(1,4);
appData.rightSliders = cell(1,4);
for i = 1:length(appData.leftSliders)
appData.leftSliders{i} = uicontrol(appData.leftSlidersPanel,...
    'style', 'slider',...
    'string', 'Slider1',...
    'units', 'normalized',...
    'position', [0 (0.76 -0.25*(i-1)) 0.7 0.25],...
    'callback', {@leftSliderCallback, i, appData},...
    'visible', 'on',...
    'FontSize', 13,...
    'min', -5,...
    'max', 5);
end
for i = 1:length(appData.rightSliders)
appData.rightSliders{i} = uicontrol(appData.rightSlidersPanel,...
    'style', 'slider',...
    'string', 'Slider1',...
    'units', 'normalized',...
    'position', [0.27 (0.75 -0.25*(i-1)) 0.7 0.25],...
    'callback', {@rightSliderCallback, i, appData},...
    'visible', 'on',...
    'FontSize', 13,...
    'min', -5,...
    'max', 5);
end

end

function createPopup(appData)
popupString = cell(1,length(appData.presetStore(:,1)));
for i = 1:length(popupString)
   popupString{i} = num2str(i);    
end

appData.popup = uicontrol('Style', 'popup',...
           'String', popupString,...
           'units', 'normalized',...
           'Position', [0,0.12, 0.12, 0.05],...
           'Callback', {@numPopupCallback, appData});
end

function createNumDisplays(appData)
appData.leftNumDisplays = cell(1,4);
appData.rightNumDisplays = cell(1,4);

for i = 1:length(appData.leftSliders)
appData.leftNumDisplays{i} = uicontrol(appData.leftSlidersPanel,...
    'Style','text',...
    'units', 'normalized',...
    'BackgroundColor', appData.timbreColour,...
    'ButtonDownFcn', {@leftTextCallback, i, appData},...
    'String',num2str(appData.leftSliders{i}.Value),...
    'Position',[0.75,(0.78 -0.25*(i-1)),0.25,0.26]);
end
for i = 1:length(appData.rightSliders)
appData.rightNumDisplays{i} = uicontrol(appData.rightSlidersPanel,...
    'Style','text',...
    'units', 'normalized',...
    'BackgroundColor', appData.timeColour,...
    'ButtonDownFcn', {@rightTextCallback, i, appData},...
    'String',num2str(appData.rightSliders{i}.Value),...
    'Position',[0.0,(0.78 -0.25*(i-1)),0.25,0.26]);
end
end

function createBlendModeButton(appData)
appData.blendModeButton = uicontrol('style', 'pushbutton',...
    'string', 'Blend Mode',...
    'units', 'normalized',...
    'position', [0.0 0.0 0.14 0.08],...
    'callback', {@blendModeButtonCallback, appData},...
    'visible', 'on',...
    'FontSize', 13,...
    'Enable', 'off');

end

function createCategoryButtons(appData)
appData.categoriesPanel = uipanel('Position',[0, 0.9, 1, 0.1]);

appData.pianoKeysButton = uicontrol(appData.categoriesPanel,...
    'style', 'pushbutton',...
    'string', 'Piano/Keys',...
    'units', 'normalized',...
    'position', [0, 0, 1/6 1],...
    'callback', {@categoryButtonCallback, 1, appData},...
    'FontSize', 13);

appData.pluckedMalletButton = uicontrol(appData.categoriesPanel,...
    'style', 'pushbutton',...
    'string', 'Plucked/Mallet',...
    'units', 'normalized',...
    'position', [1/6, 0, 1/6 1],...
    'callback', {@categoryButtonCallback, 2, appData},...
    'FontSize', 13);

appData.bassButton = uicontrol(appData.categoriesPanel,...
    'style', 'pushbutton',...
    'string', 'Bass',...
    'units', 'normalized',...
    'position', [2/6, 0, 1/6 1],...
    'callback', {@categoryButtonCallback, 3, appData},...
    'FontSize', 13);

appData.synthLeadButton = uicontrol(appData.categoriesPanel,...
    'style', 'pushbutton',...
    'string', 'Synth Lead',...
    'units', 'normalized',...
    'position', [3/6, 0, 1/6 1],...
    'callback', {@categoryButtonCallback, 4, appData},...
    'FontSize', 13);

appData.synthPadButton = uicontrol(appData.categoriesPanel,...
    'style', 'pushbutton',...
    'string', 'SynthPad',...
    'units', 'normalized',...
    'position', [4/6, 0, 1/6 1],...
    'callback', {@categoryButtonCallback, 5, appData},...
    'FontSize', 13);

appData.rhythmicButton = uicontrol(appData.categoriesPanel,...
    'style', 'pushbutton',...
    'string', 'Rhythmic',...
    'units', 'normalized',...
    'position', [5/6, 0, 1/6 1],...
    'callback', {@categoryButtonCallback, 6, appData},...
    'FontSize', 13);
end

function createTimePlots(appData)
figure(6), clf
set(figure(6), 'MenuBar', 'none', 'ToolBar' ,'none')

appData.timeData = timePlotDataFromPreset(appData.presetStore(1,:));
appData.timePlots = createAllTimePlots(appData.timeData);
set(figure(6), 'Position',(get(figure(5), 'Position') - [550, 0, 0, 0]))
end

function createTimbrePlots(appData)
figure(7), clf
set(figure(7), 'MenuBar', 'none', 'ToolBar' ,'none')

appData.timbreData = timbrePlotDataFromPreset(appData.presetStore(1,:));
appData.timbrePlots = createAllTimbrePlots(appData.timbreData);
set(figure(7), 'Position',(get(figure(5), 'Position') - [550, 420, -550, 0]))
end

function initialiseMidiInput(appData)
    appData.midiControls = cell(1,8);
    for i = 1:8
        appData.midiControls{i} = midicontrols(i, 'MIDIDevice', 'IAC Driver Bus 1');
        functionHandle = @(x)midiCallback(x,i, appData);
        midicallback(appData.midiControls{i},functionHandle);
    end
end



