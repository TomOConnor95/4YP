% Test script for preset blending interface
close all
%% Create Initial Presets and related data structures
%Ptest = createPresetsForImageEditing();

%% Option parameters
savePresetsToFile = true;
displayParameters = false;
displayBarGraphs = false;

timbreColour = [0.94, 0.6, 0.6];
timeColour = [0.94, 0.94, 0.6];
pauseColour = [0.6, 0.94, 0.6];
normalColour = [0.4,0.5,0.9];
normalButtonColour = [0.94, 0.94, 0.94];

%% Miscellaneous Set-up Parameters
% Mouse clicks
MOUSE = [0,0];              % Mouse State
isMouseClicked = false;          % Has mouse been pressed?

% UI Buttons
isSaveButtonPressed = false;
isPauseButtonPressed = false;
isTimbreButtonPressed = false;
isTimeButtonPressed = false;

% Preset Markers
isMarkerClicked = false;
markerIndex = 1;
currentMarkerIndex = 0;
presetsDoubleClicked = [];

% Program State
S.isBlending = true;          % Is UI in blending mode?
S.isSearching = true;         % Is the program's while loop active

S.isPaused = true;
S.isTimbreFrozen = false;
S.isTimeFrozen = false;

screenSize = get(0,'Screensize');

%% Open UDP connection
u = udp('127.0.0.1',57120); 
fopen(u); 

%% Choose initial presets
[presetA, nameStrings, typeStrings] = createPresetAforOSC();

%presetB = createPresetBforOSC();
%presetC = createPresetCforOSC();


% [presetA, presetB, presetC] = loadPresetsFromStore(4,9,7);
[presetA, presetB, presetC] = loadPresetsFromStoreRandom('PresetStoreSC.mat');
P = presetGeneratorSCMonteCarloMV(presetA, presetB, presetC);

sendAllStructParamsOverOSC(P.presetA, nameStrings, typeStrings, u);
%% Plot all geometry for Blending Interface
figure(1)
G = createBlendingGeometry();
G = createPauseSaveButtons(G);
G = createFreezeButtons(G);
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

% Initialsise the command line printing of parameters.
dispstat('','init')  

while(S.isSearching)
    
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
            
            
            P = P.combineSelectedPresets(presetsDoubleClicked, timeColour);
            
            P = P.combineSelectedPresets(presetsDoubleClicked);
%             if isTimeFrozen == true
%                 P = P.combineSelectedPresets(presetsDoubleClicked, timeColour);
%             elseif isTimbreFrozen == true
%                 P = P.combineSelectedPresets(presetsDoubleClicked, timbreColour);
%             else
%                 P = P.combineSelectedPresets(presetsDoubleClicked, 'g');
%             end
            
            presetsDoubleClicked = [];
            currentMarkerIndex = 0;
            continue
            
        elseif ~isempty(presetsDoubleClicked)
            P = setMarkerFaceColours(P, presetsDoubleClicked, [0,1,0]);
        end
        
        currentMarkerIndex = markerIndex;
        
        continue 
        
    end
    
    %% Press Freeze Timbre Button
    if isTimbreButtonPressed
        isTimbreButtonPressed = false;
        
        if S.isTimbreFrozen
            S.isTimbreFrozen = false;
            G.but_freeze_timbre.BackgroundColor = normalButtonColour;
        else
            S.isTimbreFrozen = true;
        	G.but_freeze_timbre.BackgroundColor = timbreColour;
            
            % Don't allow Time and Timbre to be frozen at the same time
            if S.isTimeFrozen
                S.isTimeFrozen = false;
                G.but_freeze_time.BackgroundColor = normalButtonColour;
            end
            
        end
        
        continue
    end
    
    %% Press Freeze Time Button
    if isTimeButtonPressed
        isTimeButtonPressed = false;
        
        if S.isTimeFrozen
            S.isTimeFrozen = false;
            G.but_freeze_time.BackgroundColor = normalButtonColour;
        else
            S.isTimeFrozen = true;
        	G.but_freeze_time.BackgroundColor = timeColour;
            
            % Don't allow Time and Timbre to be frozen at the same time
            if S.isTimbreFrozen
                S.isTimbreFrozen = false;
                G.but_freeze_timbre.BackgroundColor = normalButtonColour;
            end
        end

        continue
    end
    
    %% Paused State
    if S.isPaused
        
        if isPauseButtonPressed
            isPauseButtonPressed = false;
            %isMouseClicked = false;
            S.isBlending = true;
            S.isPaused = false;   
            G.but_pause.String = 'Pause On Last Preset';
            G.but_pause.BackgroundColor = normalButtonColour;
            continue
        end
        	
       continue 
    end
    %% Press pause button to pause searching
    if isPauseButtonPressed
        isPauseButtonPressed = false;
        S.isBlending = false;
        %isMouseClicked = false;
        S.isPaused = true;
        
        G.but_pause.String = 'Resume Searching';
        
        G.but_pause.BackgroundColor = pauseColour;
        % Revert to last clicked preset
        sendAllStructParamsOverOSC(P.presetA, nameStrings, typeStrings, u);
        continue
    end
    
    
    %% If mouse is clicked move to the next generation of presets
    if isMouseClicked
        isMouseClicked = false;
        
        if S.isTimeFrozen
            P = P.iteratePresets(G.P1, timeColour);
        elseif S.isTimbreFrozen
            P = P.iteratePresets(G.P1, timbreColour);
        else
            P = P.iteratePresets(G.P1, normalColour);
        end
        
        if displayBarGraphs
            barStruct = updateBarGraphsStruct(P.presetA, barStruct);
        end
    end
    %%  Live Preset Blending Step
    if S.isBlending
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
            
            drawnow()
            
        end
    end
    
end

%% Close UDP Connection
fclose(u);
