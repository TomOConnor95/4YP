% Test script for preset blending interface
%close all



% Miscellaneous Set-up Parameters
% Mouse clicks
appData = ApplicationDataBlendingInterface();
% global MOUSE
% global isMouseClicked
% MOUSE = [0,0];              % Mouse State
% isMouseClicked = false;          % Has mouse been pressed?

% 
% % UI Buttons
% isSaveButtonPressed = false;
% isPauseButtonPressed = false;
% isTimbreButtonPressed = false;
% isTimeButtonPressed = false;
% isFreezeSectionToggled = false;

% Preset Markers
%isMarkerClicked = false;

% appData.markerIndex = 1;
% appData.currentMarkerIndex = 0;
% appData.presetsDoubleClicked = [];

% % Program State
% isBlending = true;          % Is UI in blending mode?
% isSearching = true;         % Is the program's while loop active
% isPaused = true;

screenSize = get(0,'Screensize');

% Open UDP connection
appData.u = udp('127.0.0.1',57120); 
fopen(appData.u); 

% Choose initial presets

% Get nameStrings and TypeStrings    Maybe just save these in presetStore
[~, appData.nameStrings, appData.typeStrings] = createPresetAforOSC();

% selectedIndeces = voronoiSelection('PresetStoreSC.mat', u, nameStrings, typeStrings);

% [presetA, presetB, presetC] = loadPresetsFromStore(selectedIndeces(1),...
%                                                    selectedIndeces(2),...
%                                                    selectedIndeces(3),...
%                                                    'PresetStoreSC.mat');

[presetA, presetB, presetC] = loadPresetsFromStore(20,21,22, 'PresetStoreSC.mat');
      

% presetA = appData.presetStoreVaried(appData.idxSelected(1),:);
% presetB = appData.presetStoreVaried(appData.idxSelected(2),:);
% presetC = appData.presetStoreVaried(appData.idxSelected(3),:);
%                                                
appData.P = presetGeneratorSCMonteCarloMV(presetA, presetB, presetC, appData);

sendAllStructParamsOverOSC(appData.P.presetA, appData.nameStrings, appData.typeStrings, appData.u);
% Plot all geometry for Blending Interface
figure(1)
appData.G = createBlendingGeometry();
% Blending Interface Callbacks
set (gca, 'ButtonDownFcn', {@mouseClickedBlending, appData});
set (gcf, 'WindowButtonMotionFcn', {@mouseMovedBlending, appData});

createPauseButton(appData)
createSaveButton(appData)
createFreezeSectionUI(appData)


% Create all necessary parameters visualisations
if appData.displayBarGraphs == true
    figure(2)
    appData.barStruct = createBarGraphsStruct(P.presetA, nameStrings);
    set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/2.4,screenSize(4)/2])
end
% Create plots to show evolution of parameters and Mouse Points
% This is done by the presetGenerator class

% Main Loop
figure(1)

% Initialsise the command line printing of parameter
dispstat('','init')  

% while(isSearching)
%     
%     pause(0.01)
%     % Press button to save final image and quit program
%     if isSaveButtonPressed
%         isSaveButtonPressed = false;
%         
%         if savePresetsToFile
%             presetSave = matfile('PresetStoreSC.mat','Writable',true);
%             presetSave.presetStore(1+length(presetSave.presetStore(:,1)),:) = P.presetA;
%         end
%         continue
%     end
%     
%     % Switch presets if a preset marker is clicked
%     if isMarkerClicked
%         isMarkerClicked = false;
%         
%         P = P.switchPresets(markerIndex);
%         sendAllStructParamsOverOSC(P.presetA, nameStrings, typeStrings, u);
%         dispstat(sprintf(preset2string(P.presetA, nameStrings)));
%         
%         [P, presetsDoubleClicked] = testForDoubleClicks(P, presetsDoubleClicked, currentMarkerIndex, markerIndex);
%         
%         if length(presetsDoubleClicked) >2
%             
%             P = setMarkerFaceColours(P, presetsDoubleClicked, [0.8, 0.6, 0.6]);
%             
%             P = P.combineSelectedPresets(presetsDoubleClicked);
%             
%             presetsDoubleClicked = [];
%             currentMarkerIndex = 0;
%             continue
%             
%         elseif ~isempty(presetsDoubleClicked)
%             P = setMarkerFaceColours(P, presetsDoubleClicked, [0,1,0]);
%         end
%         
%         currentMarkerIndex = markerIndex;
%         
%         continue 
%     end
%     % Press Freeze Time Button
%     if isTimeButtonPressed
%         isTimeButtonPressed = false;
%         
%         P = P.toggleTimeState();
%         G = correctlyColourFreezeButtons(G, P);
%         G = correctlyDisableFreezeToggles(G, P);
%         continue
%     end
%     
%     % Press Freeze Timbre Button
%     if isTimbreButtonPressed
%         isTimbreButtonPressed = false;
%         
%         P = P.toggleTimbreState();
%         G = correctlyColourFreezeButtons(G, P);
%         G = correctlyDisableFreezeToggles(G, P);
%         continue
%     end
%     
%     % Press Freeze Section Toggle Button
%     if isFreezeSectionToggled
%         isFreezeSectionToggled = false;
%         
%         P = P.setFreezeSectionsToggled(checkFreezeToggles(G));
%         
%         continue
%     end
%     
%     % Paused State
%     if isPaused
%         
%         if isPauseButtonPressed
%             isPauseButtonPressed = false;
%             isMouseClicked = false;
%             isBlending = true;
%             isPaused = false;  
%             
%             G.but_pause.String = 'Pause On Last Preset';
%             G.but_pause.BackgroundColor = G.normalButtonColour;
%             continue
%         end
%         	
%        continue 
%     end
%     % Press pause button to pause searching
%     if isPauseButtonPressed
%         isPauseButtonPressed = false;
%         isBlending = false;
%         isMouseClicked = false;
%         isPaused = true;
%         
%         G.but_pause.String = 'Resume Searching';
%         G.but_pause.BackgroundColor = G.pauseColour;
%         
%         % Revert to last clicked preset
%         P = P.mixPresets(1,0,0);
%         sendAllStructParamsOverOSC(P.presetMix, nameStrings, typeStrings, u);
%         continue
%     end
%     
%     
%     % If mouse is clicked move to the next generation of presets
%     if isMouseClicked
%         isMouseClicked = false;
%         
%         P = P.iteratePresets(G.P1);
%         
%         if displayBarGraphs
%             barStruct = updateBarGraphsStruct(P.presetA, barStruct);
%         end
%     end
%     %  Live Preset Blending Step
%     if isBlending
%         G.P1 = [MOUSE(1,1);MOUSE(1,2)];
%         
%         % has P1 Changed?
%         if ~isequal(G.P1,G.P1current)
%             
%             G = updateGeometry(G);
%             
%             [alpha,beta,gamma] = calculatePresetRatios(G);
%             
%             P = P.mixPresets(alpha,beta,gamma);
%             
%             sendAllStructParamsOverOSC(P.presetMix, nameStrings, typeStrings, u);
%             
%             if displayParameters
%                 dispstat(sprintf(preset2string(P.presetMix, nameStrings)));
%             end
%             
%         end
%     end
%     
%     
%     
% end

function mouseMovedBlending (object, eventdata, appData)
    if appData.isPaused == false
        MOUSE = get (gca, 'CurrentPoint');
        mousePos = MOUSE(1,1:2);

        if mousePosOutOfBlendingRange(mousePos)
            disp('Mouse out of range');
        else
            appData.G.P1 = mousePos';
            appData.G = updateGeometry(appData.G);

            [alpha,beta,gamma] = calculatePresetRatios(appData.G);

            appData.P = appData.P.mixPresets(alpha,beta,gamma);

            sendAllStructParamsOverOSC(appData.P.presetMix, appData.nameStrings, appData.typeStrings, appData.u);

            if appData.displayParameters
                dispstat(sprintf(preset2string(appData.P.presetMix, appData.nameStrings)));
            end
        end
    end
end


function mouseClickedBlending (object, eventdata, appData)
    if appData.isPaused == false
        appData.P = appData.P.iteratePresets(appData.G.P1);

        if appData.displayBarGraphs
            appData.barStruct = updateBarGraphsStruct(P.presetA, appData.barStruct);
        end
    end
end

function [isOutOfRange] = mousePosOutOfBlendingRange(mousePos)

A = mousePos(1) < -16.4826 || mousePos(1) > 16.4826;
B = mousePos(2) < -9 || mousePos(2) > 17;
    if A || B
        isOutOfRange = true;
    else
        isOutOfRange = false;
    end
end

function createPauseButton(appData)
% create a "push button" user interface (UI) object
appData.pauseButton = uicontrol('style', 'pushbutton',...
    'string', 'Pause On Last Preset',...
    'units', 'normalized',...
    'position', [0.25 0 0.25 0.11],...
    'callback', {@pauseButtonCallback, appData},...
    'visible', 'on',...
    'FontSize', 13);

set(appData.pauseButton,'HitTest','on')

% Initilally the program is in pause mode
appData.pauseButton.String = 'Begin Searching';    
appData.pauseButton.BackgroundColor = appData.pauseColour;

end

function createSaveButton(appData)

% create a "push button" user interface (UI) object
appData.saveButton = uicontrol('style', 'pushbutton',...
    'string', 'Save Last Preset',...
    'units', 'normalized',...
    'position', [0.0 0 0.25 0.11],...
    'callback', {@saveButtonCallback, appData},...
    'visible', 'on',...
    'FontSize', 13);

set(appData.saveButton,'HitTest','on')

end



function saveButtonCallback (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('Save Button Clicked')

if savePresetsToFile
    presetSave = matfile('PresetStoreSC.mat','Writable',true);
    presetSave.presetStore(1+length(presetSave.presetStore(:,1)),:) = P.presetA;
end

end

function pauseButtonCallback (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('Pause Button Clicked')

if appData.isPaused == true

        appData.isBlending = true;
        appData.isPaused = false;  

        appData.pauseButton.String = 'Pause On Last Preset';
        appData.pauseButton.BackgroundColor = appData.normalButtonColour;

else
        
        appData.isBlending = false;
        appData.isPaused = true;
        
        appData.pauseButton.String = 'Resume Searching';
        appData.pauseButton.BackgroundColor = appData.pauseColour;
        
        % Revert to last clicked preset
        appData.P = appData.P.mixPresets(1,0,0);
        sendAllStructParamsOverOSC(appData.P.presetMix,...
            appData.nameStrings, appData.typeStrings, appData.u);
        
        appData.G.P1 = [0,0]';
        appData.G = updateGeometry(appData.G);
end

end

function createFreezeSectionUI(appData)

figure(4)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
appData.p1.panel = uipanel('Title','Timbre Controls',...
             'Position',[.05 .05 .425 .9]);
 
appData.p1.freezeTimbreButton = uicontrol(appData.p1.panel,...
    'style', 'pushbutton',...
    'string', 'Freeze Timbre',...
    'units', 'normalized',...
    'position', [0.0 0.9 1.0 0.11],...
    'callback', {@timbreButtonCallback, appData},...
    'FontSize', 13);
         
appData.p1.togglePMparams = uicontrol(appData.p1.panel,...
    'style', 'checkbox',...
    'string', 'Freeze PM Params',...
    'units', 'normalized',...
    'position', [0.05 0.8 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p1.toggleFreqCoarse = uicontrol(appData.p1.panel,...
    'style', 'checkbox',...
    'string', 'Freeze Freq Coarse',...
    'units', 'normalized',...
    'position', [0.05 0.7 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p1.toggleFreqFine = uicontrol(appData.p1.panel,...
    'style', 'checkbox',...
    'string', 'Freeze Freq Fine',...
    'units', 'normalized',...
    'position', [0.05 0.6 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p1.toggleOutputLevels = uicontrol(appData.p1.panel,...
    'style', 'checkbox',...
    'string', 'Freeze Output Levels',...
    'units', 'normalized',...
    'position', [0.05 0.5 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p1.toggleEnvAmt = uicontrol(appData.p1.panel,...
    'style', 'checkbox',...
    'string', 'Freeze Mod Env Amt',...
    'units', 'normalized',...
    'position', [0.05 0.4 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p1.toggleLfoADepth = uicontrol(appData.p1.panel,...
    'style', 'checkbox',...
    'string', 'Freeze LFO A Depth',...
    'units', 'normalized',...
    'position', [0.05 0.3 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p1.toggleLfoBDepth = uicontrol(appData.p1.panel,...
    'style', 'checkbox',...
    'string', 'Freeze LFO B Depth',...
    'units', 'normalized',...
    'position', [0.05 0.2 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
appData.p2.panel = uipanel('Title','Time Controls',...
             'Position',[.5 .05 .45 .9]);
         
        
appData.p2.freezeTimeButton = uicontrol(appData.p2.panel,...
    'style', 'pushbutton',...
    'string', 'Freeze Time',...
    'units', 'normalized',...
    'position', [0.0 0.9 1.0 0.11],...
    'callback', {@timeButtonCallback, appData},...
    'FontSize', 13);
         
appData.p2.toggleLfoAParams = uicontrol(appData.p2.panel,...
    'style', 'checkbox',...
    'string', 'Freeze LFO A Params',...
    'units', 'normalized',...
    'position', [0.05 0.8 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p2.toggleLfoBParams = uicontrol(appData.p2.panel,...
    'style', 'checkbox',...
    'string', 'Freeze LFO B Params',...
    'units', 'normalized',...
    'position', [0.05 0.7 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p2.toggleEnvAmpParams = uicontrol(appData.p2.panel,...
    'style', 'checkbox',...
    'string', 'Freeze Amp Env Params',...
    'units', 'normalized',...
    'position', [0.05 0.6 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p2.toggleEnv1Params = uicontrol(appData.p2.panel,...
    'style', 'checkbox',...
    'string', 'Freeze Mod Env Params',...
    'units', 'normalized',...
    'position', [0.05 0.5 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);

appData.p2.toggleMisc = uicontrol(appData.p2.panel,...
    'style', 'checkbox',...
    'string', 'Freeze Misc Params',...
    'units', 'normalized',...
    'position', [0.05 0.4 0.9 0.1],...
    'callback', {@freezeSectionsCallback, appData},...
    'FontSize', 13);
  
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function timbreButtonCallback (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('Freeze Timbre Button Clicked')

appData.P = appData.P.toggleTimbreState();
correctlyColourFreezeButtons(appData);
correctlyDisableFreezeToggles(appData);
end

function timeButtonCallback (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('Freeze Time Button Clicked')

appData.P = appData.P.toggleTimeState();
correctlyColourFreezeButtons(appData);
correctlyDisableFreezeToggles(appData);
end

function freezeSectionsCallback (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('Freeze Section Toggle Button Clicked')

appData.P = appData.P.setFreezeSectionsToggled(...
    checkFreezeToggles(appData.p1, appData.p2));
end  

function correctlyColourFreezeButtons(appData)
    % Corretly Colour blending UI Buttons based on frozen state
    
    if appData.P.isTimeFrozen
        appData.p2.freezeTimeButton.BackgroundColor =  appData.P.timeColour; 
    else
        appData.p2.freezeTimeButton.BackgroundColor =  appData.normalButtonColour; 
    end

    if appData.P.isTimbreFrozen
        appData.p1.freezeTimbreButton.BackgroundColor =  appData.P.timbreColour; 
    else
        appData.p1.freezeTimbreButton.BackgroundColor =  appData.normalButtonColour; 
    end
end

function correctlyDisableFreezeToggles(appData)
    % Corretly Colour blending UI Buttons based on frozen state
    
    if appData.P.isTimbreFrozen
        appData.p1.togglePMparams.Enable = 'off';
        appData.p1.toggleFreqCoarse.Enable = 'off';
        appData.p1.toggleFreqFine.Enable = 'off';
        appData.p1.toggleOutputLevels.Enable = 'off';
        appData.p1.toggleEnvAmt.Enable = 'off';
        appData.p1.toggleLfoADepth.Enable = 'off';
        appData.p1.toggleLfoBDepth.Enable = 'off';
    else
        appData.p1.togglePMparams.Enable = 'on';
        appData.p1.toggleFreqCoarse.Enable = 'on';
        appData.p1.toggleFreqFine.Enable = 'on';
        appData.p1.toggleOutputLevels.Enable = 'on';
        appData.p1.toggleEnvAmt.Enable = 'on';
        appData.p1.toggleLfoADepth.Enable = 'on';
        appData.p1.toggleLfoBDepth.Enable = 'on';
    end

    if appData.P.isTimeFrozen
        appData.p2.toggleLfoAParams.Enable = 'off';
        appData.p2.toggleLfoBParams.Enable = 'off';
        appData.p2.toggleEnvAmpParams.Enable = 'off';
        appData.p2.toggleEnv1Params.Enable = 'off';
        appData.p2.toggleMisc.Enable = 'off';
    else
        appData.p2.toggleLfoAParams.Enable = 'on';
        appData.p2.toggleLfoBParams.Enable = 'on';
        appData.p2.toggleEnvAmpParams.Enable = 'on';
        appData.p2.toggleEnv1Params.Enable = 'on';
        appData.p2.toggleMisc.Enable = 'on';
    end
end

function sectionsToFreeze = checkFreezeToggles(p1, p2)

sectionsToFreeze = [...
    p1.togglePMparams.Value > 0,...
    p1.toggleFreqCoarse.Value > 0,...
    p1.toggleFreqFine.Value > 0,...
    p1.toggleOutputLevels.Value > 0,...
    p1.toggleEnvAmt.Value > 0,...
    p1.toggleLfoADepth.Value > 0,...
    p1.toggleLfoBDepth.Value > 0,...
    p2.toggleLfoAParams.Value > 0,...
    p2.toggleLfoBParams.Value > 0,...
    p2.toggleEnvAmpParams.Value > 0,...
    p2.toggleEnv1Params.Value > 0,...
    p2.toggleMisc.Value > 0];
end
