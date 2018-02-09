% Test script for preset blending interface
close all

%% Option parameters
savePresetsToFile = true;
displayParameters = true;
displayBarGraphs = false;

%% Miscellaneous Set-up Parameters
% Mouse clicks
global MOUSE
global isMouseClicked
MOUSE = [0,0];              % Mouse State
isMouseClicked = false;          % Has mouse been pressed?

% UI Buttons
isSaveButtonPressed = false;
isPauseButtonPressed = false;
isTimbreButtonPressed = false;
isTimeButtonPressed = false;
isFreezeSectionToggled = false;

% Preset Markers
isMarkerClicked = false;
markerIndex = 1;
currentMarkerIndex = 0;
presetsDoubleClicked = [];

% Program State
isBlending = true;          % Is UI in blending mode?
isSearching = true;         % Is the program's while loop active
isPaused = true;

screenSize = get(0,'Screensize');

%% Open UDP connection
u = udp('127.0.0.1',57120); 
fopen(u); 

%% Choose initial presets

% Get nameStrings and TypeStrings    Maybe just save these in presetStore
[~, nameStrings, typeStrings] = createPresetAforOSC();

selectedIndeces = voronoiSelection('PresetStoreSC.mat', u, nameStrings, typeStrings);

[presetA, presetB, presetC] = loadPresetsFromStore(selectedIndeces(1),...
                                                   selectedIndeces(2),...
                                                   selectedIndeces(3),...
                                                   'PresetStoreSC.mat');
%[presetA, presetB, presetC] = loadPresetsFromStoreRandom('PresetStoreSC.mat');
P = presetGeneratorSCMonteCarloMV(presetA, presetB, presetC);

sendAllStructParamsOverOSC(P.presetA, nameStrings, typeStrings, u);
%% Plot all geometry for Blending Interface
figure(1)
G = createBlendingGeometry();
% Blending Interface Callbacks
set (gca, 'ButtonDownFcn', @mouseClicked);
set (gcf, 'WindowButtonMotionFcn', @mouseMoved);


G = createPauseSaveButtons(G);
%G = createFreezeButtons(G);
G = createFreezeSections(G);
%% Create all necessary parameters visualisations
if displayBarGraphs == true
    figure(2)
    barStruct = createBarGraphsStruct(P.presetA, nameStrings);
    set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/2.4,screenSize(4)/2])
end
%% Create plots to show evolution of parameters and Mouse Points
% This is done by the presetGenerator class
%% Main Loop
figure(1)

% Initialsise the command line printing of parameter
dispstat('','init')  

while(isSearching)
    
    pause(0.01)
    %% Press button to save final image and quit program
    if isSaveButtonPressed
        isSaveButtonPressed = false;
        
        if savePresetsToFile
            presetSave = matfile('PresetStoreSC.mat','Writable',true);
            presetSave.presetStore(1+length(presetSave.presetStore(:,1)),:) = P.presetA;
        end
        continue
    end
    
    %% Switch presets if a preset marker is clicked
    if isMarkerClicked
        isMarkerClicked = false;
        
        P = P.switchPresets(markerIndex);
        sendAllStructParamsOverOSC(P.presetA, nameStrings, typeStrings, u);
        dispstat(sprintf(preset2string(P.presetA, nameStrings)));
        
        [P, presetsDoubleClicked] = testForDoubleClicks(P, presetsDoubleClicked, currentMarkerIndex, markerIndex);
        
        if length(presetsDoubleClicked) >2
            
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
    %% Press Freeze Time Button
    if isTimeButtonPressed
        isTimeButtonPressed = false;
        
        P = P.toggleTimeState();
        G = correctlyColourFreezeButtons(G, P);
        G = correctlyDisableFreezeToggles(G, P);
        continue
    end
    
    %% Press Freeze Timbre Button
    if isTimbreButtonPressed
        isTimbreButtonPressed = false;
        
        P = P.toggleTimbreState();
        G = correctlyColourFreezeButtons(G, P);
        G = correctlyDisableFreezeToggles(G, P);
        continue
    end
    
    %% Press Freeze Section Toggle Button
    if isFreezeSectionToggled
        isFreezeSectionToggled = false;
        
        P = P.setFreezeSectionsToggled(checkFreezeToggles(G));
        
        continue
    end
    
    %% Paused State
    if isPaused
        
        if isPauseButtonPressed
            isPauseButtonPressed = false;
            isMouseClicked = false;
            isBlending = true;
            isPaused = false;  
            
            G.but_pause.String = 'Pause On Last Preset';
            G.but_pause.BackgroundColor = G.normalButtonColour;
            continue
        end
        	
       continue 
    end
    %% Press pause button to pause searching
    if isPauseButtonPressed
        isPauseButtonPressed = false;
        isBlending = false;
        isMouseClicked = false;
        isPaused = true;
        
        G.but_pause.String = 'Resume Searching';
        G.but_pause.BackgroundColor = G.pauseColour;
        
        % Revert to last clicked preset
        P = P.mixPresets(1,0,0);
        sendAllStructParamsOverOSC(P.presetMix, nameStrings, typeStrings, u);
        continue
    end
    
    
    %% If mouse is clicked move to the next generation of presets
    if isMouseClicked
        isMouseClicked = false;
        
        P = P.iteratePresets(G.P1);
        
        if displayBarGraphs
            barStruct = updateBarGraphsStruct(P.presetA, barStruct);
        end
    end
    %%  Live Preset Blending Step
    if isBlending
        G.P1 = [MOUSE(1,1);MOUSE(1,2)];
        
        % has P1 Changed?
        if ~isequal(G.P1,G.P1current)
            
            G = updateGeometry(G);
            
            [alpha,beta,gamma] = calculatePresetRatios(G);
            
            P = P.mixPresets(alpha,beta,gamma);
            
            sendAllStructParamsOverOSC(P.presetMix, nameStrings, typeStrings, u);
            
            if displayParameters
                dispstat(sprintf(preset2string(P.presetMix, nameStrings)));
            end
            
        end
    end
    
end

%% Close UDP Connection
fclose(u);
