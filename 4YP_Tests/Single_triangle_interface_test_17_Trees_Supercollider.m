% Test script for preset blending interface
%close all
%% Create Initial Presets and related data structures
%Ptest = createPresetsForImageEditing();


%% Option parameters
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

%% Open UDP connection
u = udp('127.0.0.1',57120); 
fopen(u); 

%% Choose initial presets
[presetA, nameStrings, typeStrings] = createPresetAforOSC();

presetB = createPresetBforOSC();
presetC = createPresetCforOSC();


% [presetA, presetB, presetC] = loadPresetsFromStore(4,9,7);
 %[presetA, presetB, presetC] = loadPresetsFromStoreRandom();
P = presetGeneratorSCMonteCarloMV(presetA, presetB, presetC);

sendAllStructParamsOverOSC(P.presetA, nameStrings, typeStrings, u);
%% Plot all geometry for Blending Interface
figure(1)
G = createBlendingGeometry();
%set(gcf,'Position',[(screenSize(3)/2),0,screenSize(3)/2,screenSize(4)])

%% Create all necessary parameters visualisations
figure(2)
barStruct = createBarGraphsStruct(P.presetA, nameStrings);
set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/2.4,screenSize(4)/2])

%% Create plots to show evolution of parameters and Mouse Points
% This is done by the presetGenerator class
%% Main Loop
figure(1)

pause()
G.pauseText.Visible = 'off';
% Currently if you click during the paused time it will trigger the
% callback and cause a bug

 dispstat('','init')  


while(isSearching)
    
    pause(0.01)
    %% Press button to save final image and quit program
    if isButtonPressed == true
        %isBlending = false;
        %isPressed = false;
        %isSearching = false;
        isButtonPressed = false;
        
        if savePresetsToFile == true
            presetSave = matfile('PresetStoreSC.mat','Writable',true);
            presetSave.presetStore(1+length(presetSave.presetStore(:,1)),:) = P.presetA;
        end
        continue
    end
    
    %% Switch presets if a preset marker is clicked
    if isMarkerClicked == true
        isMarkerClicked = false;
        
        P = P.switchPresets(markerIndex);
        
        sendAllStructParamsOverOSC(P.presetA, nameStrings, typeStrings, u);
        
        barStruct = updateBarGraphsStruct(P.presetA, barStruct);

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
        sendAllStructParamsOverOSC(P.presetA, nameStrings, typeStrings, u);
        continue
    end
    
    
    
    %% If mouse is clicked move to the next generation of presets
    if isPressed == true
        currentGeneration = currentGeneration + 1;
        % Generate new presets
        P = P.iteratePresets(G.P1);
        
        % Update Bar plots
        barStruct = updateBarGraphsStruct(P.presetA, barStruct);
        
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
            
            
            sendAllStructParamsOverOSC(P.presetMix, nameStrings, typeStrings, u);
            
            dispstat(sprintf(preset2string(P.presetMix, nameStrings)));
            
            drawnow()
            
        end
    end
    
end

%% Close UDP Connection
fclose(u);
