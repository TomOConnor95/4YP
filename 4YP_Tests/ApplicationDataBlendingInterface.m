classdef ApplicationDataBlendingInterface < handle
    properties (SetAccess = public, GetAccess = public)
        
        % Program State
        isPaused = true;
        isBlending = true;
        
        markerIndex = 1;
        currentMarkerIndex = 0;
        presetsDoubleClicked = [];
        
        % Preset Structure
        P;
        nameStrings;
        typeStrings;
        
        Pversions;
        % Geometry Structure
        G;
        
        % UDP conneection
        u;
        
        pauseButton;
        saveButton;
        returnButton;
        % Button Colours
        pauseColour = [0.6, 0.94, 0.6];
        normalButtonColour = [0.94, 0.94, 0.94];
        
        
        % Point history plot
        phAxes;
        phPanel
        
        % Freezing UI
        p1;
        p2;
        
        barStruct; 
        % Option parameters
        savePresetsToFile = true;
        displayParameters = true;
        displayBarGraphs = false;
        
        pcaAppData;
        
        
    end
    
    methods
        % Constructor
        function obj = ApplicationDataBlendingInterface(pcaAppData_in)
            %----------------------------------------------------------%
            %----------------------Miscellaneous-----------------------%
            %----------------------------------------------------------%
            obj.pcaAppData = pcaAppData_in;
            
            % Open UDP connection
            obj.u = udp('127.0.0.1',57120); 
            fopen(obj.u); 

            %----------------------------------------------------------%
            %----------------------Presets-----------------------------%
            %----------------------------------------------------------%
            % Get nameStrings and TypeStrings    Maybe just save these in presetStore
            [testPreset, obj.nameStrings, obj.typeStrings] = createPresetAforOSC();

            %----------------------------------------------------------%
            %----------------------Figures & Plots---------------------%
            %----------------------------------------------------------%
            createBlendingInterface(obj)
            createPauseButton(obj)
            createSaveButton(obj)
            createReturnButton(obj)
            createFreezeSectionUI(obj)
            % Create all necessary parameters visualisations % Reqirues knowing a
            % preset
            if obj.displayBarGraphs == true
                figure(2)
                set(figure(2), 'MenuBar', 'none', 'ToolBar' ,'none')
                obj.barStruct = createBarGraphsStruct(testPreset, obj.nameStrings);
                screenSize = get(0,'Screensize');
                set(gcf,'Position',[-screenSize(3)/26,0,screenSize(3)/2.4,screenSize(4)/2])
            end
            
            if obj.displayParameters == true
                % Initialise the command line printing of parameter
                dispstat('','init')
            end
            
            set(figure(1), 'Visible', 'off')
            %set(figure(2), 'Visible', 'off')
            %set(figure(3), 'Visible', 'off')
            
            set(figure(4), 'Visible', 'off')
            
            
        end
        
    end
end

%----------------------------------------------------------%
%----------------------Callbacks---------------------------%
%----------------------------------------------------------%

function mouseMovedBlending (object, eventdata, appData)
    if appData.isPaused == false
        MOUSE = get (gca, 'CurrentPoint');
        mousePos = MOUSE(1,1:2);
        
        if mousePosOutOfBlendingRange(mousePos, get(gca, 'XLim'), get(gca, 'YLim'))
            %disp('Mouse out of range');
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
            appData.barStruct = updateBarGraphsStruct(appData.P.presetA, appData.barStruct);
        end
        % Update Time Plots
        appData.pcaAppData.timeData = timePlotDataFromPreset(appData.P.presetA);
        appData.pcaAppData.timePlots = updateTimePlots(appData.pcaAppData.timePlots,...
                                                        appData.pcaAppData.timeData); 

        % Update Timbre Plots
        appData.pcaAppData.timbreData = timbrePlotDataFromPreset(appData.P.presetA);
        appData.pcaAppData.timbrePlots = updateTimbrePlots(appData.pcaAppData.timbrePlots,...
                                                            appData.pcaAppData.timbreData); 
    end
end


function pauseButtonCallback (object, eventdata, appData)
disp('Pause Button Clicked')

if appData.isPaused == true

        appData.isBlending = true;
        appData.isPaused = false;  
        
        appData.G.panel.Visible = 'on';
        appData.phPanel.Visible = 'off';
        axes(appData.G.ax)
        
        appData.pauseButton.String = 'Pause On Last Preset';
        appData.pauseButton.BackgroundColor = appData.normalButtonColour;

else
        
        appData.isBlending = false;
        appData.isPaused = true;
        
        appData.G.panel.Visible = 'off';
        appData.phPanel.Visible = 'on';
        
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


function timbreButtonCallback (object, eventdata, appData)
disp('Freeze Timbre Button Clicked')

appData.P = appData.P.toggleTimbreState();
correctlyColourFreezeButtons(appData);
correctlyDisableFreezeToggles(appData);

% Update colours correctly
appData.P = appData.P.recolourPresets();
end

function timeButtonCallback (object, eventdata, appData)
disp('Freeze Time Button Clicked')

appData.P = appData.P.toggleTimeState();
correctlyColourFreezeButtons(appData);
correctlyDisableFreezeToggles(appData);

% Update colours correctly
appData.P = appData.P.recolourPresets();
end

function saveButtonCallback (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('Save Button Clicked')

if appData.savePresetsToFile == true
    presetSave = matfile('PresetStoreSC.mat','Writable',true);
    presetSave.presetStore(1+length(presetSave.presetStore(:,1)),:) = appData.P.presetA;
end

end

function returnButtonCallback (object, eventdata, appData)
disp('Return Button Clicked')

appData.Pversions{length(appData.Pversions)+1} = appData.P;

set(figure(1), 'Visible', 'off')
if appData.displayBarGraphs == true
    set(figure(2), 'Visible', 'off')
end
%set(figure(3), 'Visible', 'on')
set(figure(4), 'Visible', 'off')

set(figure(5), 'Visible', 'on')

axes(appData.pcaAppData.ax)          

% Calculate PCA scores for new preset
[x, y, R, G, B] = calculatePCAScores(appData.pcaAppData, appData.P.presetA);

%Create Marker on voronoi diagram for combined preset
presetPositions = [appData.pcaAppData.presetPositions(appData.pcaAppData.idxSelected,:);
                   appData.pcaAppData.combinedMarkerPositions(appData.pcaAppData.combinedMarkersSelected,:)];
%PM = mean(presetPositions);
PM = [x,y];
P1a = presetPositions(1,:);
P1b = presetPositions(2,:);
P1c = presetPositions(3,:);

lineColour = 'g';

idx = length(appData.pcaAppData.combinedPresets)+1;

appData.pcaAppData.combinedPresets{idx} = appData.P.presetA;
appData.pcaAppData.combinedPresetsEdited{idx} = appData.P.presetA;
appData.pcaAppData.combinedPresetsVaried{idx} = appData.P.presetA;

appData.pcaAppData.combinedMarkerPositions(idx,:) = PM;
appData.pcaAppData.combinedLines{idx} = plot(appData.pcaAppData.ax,...
                [PM(1), P1a(1), NaN, PM(1), P1b(1), NaN, PM(1), P1c(1)],...
                [PM(2), P1a(2), NaN, PM(2), P1b(2), NaN, PM(2), P1c(2)],...
                'Color', lineColour, 'LineStyle', ':','LineWidth',3, 'PickableParts','none');

appData.pcaAppData.combinedMarkers{idx} = plot(appData.pcaAppData.ax, PM(1), PM(2), 'o','MarkerSize',15,...
    'MarkerFaceColor',[R,G,B],...
    'Color', appData.pcaAppData.mouseOverSelectedColour,...
    'LineWidth', 3,...
    'PickableParts','all',...
    'ButtonDownFcn',{@combinedMarkerCallBack, appData.pcaAppData.combinedPresets{idx}, appData.pcaAppData, idx});

appData.pcaAppData.lastSelectedPresetType = 'Combined';


% Deselect the previously selected presets
for i = length(appData.pcaAppData.idxSelected):-1:1
    appData.pcaAppData.patches{appData.pcaAppData.idxSelected(i)}.EdgeColor = [0,0,0];
    appData.pcaAppData.patches{appData.pcaAppData.idxSelected(i)}.LineWidth = 0.5;
    
    appData.pcaAppData.idxSelected(i) = [];
end
      
%Deselect previous combined markers
if ~isempty(appData.pcaAppData.combinedMarkersSelected)
    for i = 1:length(appData.pcaAppData.combinedMarkersSelected)
        appData.pcaAppData.combinedMarkers{appData.pcaAppData.combinedMarkersSelected(i)}.LineWidth = 1;
        appData.pcaAppData.combinedMarkers{appData.pcaAppData.combinedMarkersSelected(i)}.Color = [1,0,0];
        
        appData.pcaAppData.combinedLines{appData.pcaAppData.combinedMarkersSelected(i)}.LineWidth = 2;
    end
end

if length(appData.pcaAppData.combinedLines) > 1
    for i = 1:length(appData.pcaAppData.combinedLines) 
        if i ~= idx
            appData.pcaAppData.combinedLines{i}.LineWidth = 2;
        end
    end
end

appData.pcaAppData.combinedMarkersSelected = idx;
appData.pcaAppData.combinedMarkerLastClicked = idx;
appData.pcaAppData.combinedPresetPCAParams{idx} = zeros(4);
% Disable blend mode button
appData.pcaAppData.blendModeButton.Enable = 'off';
end

function combinedMarkerCallBack (object, eventdata, preset, appData, idx)
% appData for this function is an ApplicatinoDataPCAInterface class

disp('Combined Marker Clicked')

sendAllStructParamsOverOSC(appData.combinedPresets{idx}, appData.nameStrings, appData.typeStrings, appData.u);

% Update Time Plots
appData.timeData = timePlotDataFromPreset(appData.blendingAppData.P.presetA);
appData.timePlots = updateTimePlots(appData.timePlots,...
                                                appData.timeData); 

% Update Timbre Plots
appData.timbreData = timbrePlotDataFromPreset(appData.blendingAppData.P.presetA);
appData.timbrePlots = updateTimbrePlots(appData.timbrePlots,...
                                                    appData.timbreData); 
     
if appData.combinedMarkerLastClicked == idx
    % Current marker has just been double clicked
    if isempty(appData.combinedMarkersSelected(appData.combinedMarkersSelected == idx))
        % Current marker hasn't already been selected
        appData.combinedMarkersSelected = [appData.combinedMarkersSelected, idx];
        appData.combinedMarkers{idx}.LineWidth = 3;
        appData.combinedMarkers{idx}.Color = appData.mouseOverSelectedColour;
        appData.lastSelectedPresetType = 'Combined';
        if (length(appData.idxSelected) + length(appData.combinedMarkersSelected)) < 3
            % No need to do anything else
        elseif (length(appData.idxSelected) + length(appData.combinedMarkersSelected)) == 3
            % Correct number of presets for blending
            if isequal(appData.blendModeButton.Enable, 'off')
                appData.blendModeButton.Enable = 'on';
                disp('3 Presets Selected!');
            end
        else
            % Too many presets for blending, remove one
            if ~isempty(appData.idxSelected)
                appData.patches{appData.idxSelected(1)}.EdgeColor = [0,0,0];
                appData.patches{appData.idxSelected(1)}.LineWidth = 0.5;
                appData.idxSelected(1) = [];
            else
                appData.combinedMarkers{appData.combinedMarkersSelected(1)}.Color = [1,0,0];
                appData.combinedMarkers{appData.combinedMarkersSelected(1)}.LineWidth = 1;
                appData.combinedMarkersSelected(1) = [];
            end
        end
    else
        % Current marker has already been selected
        appData.combinedMarkersSelected(appData.combinedMarkersSelected == idx) = [];
        appData.combinedMarkers{idx}.LineWidth = 3;
        appData.combinedMarkers{idx}.Color = appData.mouseOverColour;
    end  
    %Correctly Enable/Disable Edit Mode Button
    correctlyEnableDisableEditModeButton(appData);
else
    % Current marker has not just been double clicked
    if isempty(appData.combinedMarkersSelected(appData.combinedMarkersSelected == idx))
        % Current marker hasn't already been selected
        appData.combinedMarkers{idx}.LineWidth = 3;
        appData.combinedMarkers{idx}.Color = appData.mouseOverColour;

    else
        % Current marker has already been selected
        appData.combinedMarkers{idx}.LineWidth = 3;
        appData.combinedMarkers{idx}.Color = appData.mouseOverSelectedColour;
    end
    
    % Deselect previous combined marker if necessary
    if isempty(appData.combinedMarkersSelected(appData.combinedMarkersSelected == appData.combinedMarkerLastClicked))...
            && (appData.combinedMarkerLastClicked > 0)
        appData.combinedMarkers{appData.combinedMarkerLastClicked}.LineWidth = 1;
        appData.combinedMarkers{appData.combinedMarkerLastClicked}.Color = [1,0,0];
        
    elseif (appData.combinedMarkerLastClicked > 0)
        appData.combinedMarkers{appData.combinedMarkerLastClicked}.Color = appData.selectedColour;
    end
end

% Control dotted line thickness
appData.combinedLines{idx}.LineWidth = 3;
if length(appData.combinedLines) > 1
    for i = 1:length(appData.combinedLines) 
        if i ~= idx
            appData.combinedLines{i}.LineWidth = 2;
        end
    end
end

appData.combinedMarkerLastClicked = idx;

% Update sliders to new preset
updateSliders(appData.combinedPresetPCAParams{idx}, appData);

% Update NumDisplays to new preset
updateNumDisplays(appData.combinedPresetPCAParams{idx}, appData);


end

function freezeSectionsCallback (object, eventdata, appData)
% writes continuous mouse position to base workspace
disp('Freeze Section Toggle Button Clicked')

appData.P = appData.P.setFreezeSectionsToggled(...
    checkFreezeToggles(appData.p1, appData.p2));

% Update colours correctly
appData.P = appData.P.recolourPresets();
end  

%----------------------------------------------------------%
%----------------------Misc Functions----------------------%
%----------------------------------------------------------%

function [isOutOfRange] = mousePosOutOfBlendingRange(mousePos, XLim, YLim)

A = mousePos(1) < XLim(1) || mousePos(1) > XLim(2);
B = mousePos(2) < YLim(1) || mousePos(2) > YLim(2);
    if A || B
        isOutOfRange = true;
    else
        isOutOfRange = false;
    end
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

%----------------------------------------------------------%
%----------------------UI Objects--------------------------%
%----------------------------------------------------------%

function createBlendingInterface(appData)
% Plot all geometry for Blending Interface
figure(1), clf
set(figure(1), 'MenuBar', 'none', 'ToolBar' ,'none',...
               'Position', appData.pcaAppData.UIapp.UIFigure.Position)
appData.G = createBlendingGeometry();
% Blending Interface Callbacks
set (gca, 'ButtonDownFcn', {@mouseClickedBlending, appData});
set (gcf, 'WindowButtonMotionFcn', {@mouseMovedBlending, appData});
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

function createReturnButton(appData)

% create a "push button" user interface (UI) object
appData.saveButton = uicontrol('style', 'pushbutton',...
    'string', 'Return To Preset Selection',...
    'units', 'normalized',...
    'position', [0.6 0 0.3 0.11],...
    'callback', {@returnButtonCallback, appData},...
    'visible', 'on',...
    'FontSize', 13);

set(appData.returnButton,'HitTest','on')

end

function createFreezeSectionUI(appData)

figure(4)
clf
f1Pos = appData.G.figurePosition;
f4Pos = zeros(1,4);
f4Pos(1) = f1Pos(1)+f1Pos(3);
f4Pos(2) = f1Pos(2);
f4Pos(3) = 250;
f4Pos(4) = f1Pos(4);

set(figure(4), 'MenuBar', 'none', 'ToolBar' ,'none',...
    'Position', f4Pos);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
appData.p1.panel = uipanel('Title','Timbre Controls',...
             'Position',[.05 .025 .9 .45]);
 
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
             'Position',[.05 .5 .9 .475]);
         
        
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

