% Test script for PCA selection editing of presets blending interface
% Settings
isMidiEnabled = true;

% Set up GUI figure
appData = ApplicationDataVoronoi();

%----------------------------------------------------------%
%------------------PCA Calculations------------------------%
%----------------------------------------------------------%

% Perform PCA on presets
presetStoreFlattened = cell2mat(appData.presetStore);

mu = mean(presetStoreFlattened);

presetStoreFlattened = presetStoreFlattened - mu;


[coeff, score, latent] = pca(presetStoreFlattened);

appData.coeff = coeff;
appData.score = score;
appData.latent = latent;

%appData.coeffCell = createCoeffCell(appData.coeff);

x = score(:,1:2);
x(:,1) = mapVectorRange(x(:,1), 0.05,0.95);
x(:,2) = mapVectorRange(x(:,2), 0.05,0.95);

appData.presetPositions = x;

% Colours
R = mapVectorRange(score(:,3), 0.1,1);
G = mapVectorRange(score(:,4), 0.1,1);
B = mapVectorRange(score(:,5), 0.1,1);
appData.colours = num2cell([R,G,B],2);

% Perform PCA on presets - timbre parameters
[timbreCoeff, timbreScore, timbreLatent] = pca(presetStoreFlattened(:,1:72));

% Perform PCA on presets - time parameters
[timeCoeff, timeScore, timeLatent] = pca(presetStoreFlattened(:,73:94));

coeffCombined = [timbreCoeff(:,1:4), zeros(size(timbreCoeff(:,1:4)));...
                 zeros(size(timeCoeff(:,1:4))), timeCoeff(:,1:4), ];
appData.coeffCell = createCoeffCell(coeffCombined);
             
%----------------------------------------------------------%
%----------------------Figures & Plots---------------------%
%----------------------------------------------------------%


% Create voronoi diagram from global PCA preset locations
figure(2), clf, hold on

appData.patches = filledVoronoi(appData.presetPositions, appData.colours);

for i = 1:length(appData.presetStore(:,1))
    set(appData.patches{i}, 'ButtonDownFcn', {@patchClicked, i, appData})
    set(appData.patches{i}, 'HitTest', 'On')  
end

plot(appData.presetPositions(:,1), appData.presetPositions(:,2),...
    'b+', 'HitTest', 'off', 'PickableParts', 'none')

set(gcf, 'WindowButtonMotionFcn', {@mouseMoving, appData});
set(gca, 'Position', [0.1300 0.2100 0.7750 0.7150]);

% Add number to display the selected Preset
% Create pop-up menu

popupString = cell(1,length(appData.presetStore(:,1)));
for i = 1:length(popupString)
   popupString{i} = num2str(i);    
end

appData.popup = uicontrol('Style', 'popup',...
           'String', popupString,...
           'units', 'normalized',...
           'Position', [0,0.12, 0.12, 0.05],...
           'Callback', {@numPopUpCallback, appData});

% Sliders - To adjust the principal components of presets
appData.leftSliders = cell(1,4);
appData.rightSliders = cell(1,4);
for i = 1:length(appData.leftSliders)
appData.leftSliders{i} = uicontrol('style', 'slider',...
    'string', 'Slider1',...
    'units', 'normalized',...
    'position', [0.14 (0.12 -0.04*(i-1)) 0.26 0.05],...
    'callback', {@leftSliderCallback, i, appData},...
    'visible', 'on',...
    'FontSize', 13,...
    'min', -5,...
    'max', 5);
end
for i = 1:length(appData.rightSliders)
appData.rightSliders{i} = uicontrol('style', 'slider',...
    'string', 'Slider1',...
    'units', 'normalized',...
    'position', [0.64 (0.12 -0.04*(i-1)) 0.26 0.05],...
    'callback', {@rightSliderCallback, i, appData},...
    'visible', 'on',...
    'FontSize', 13,...
    'min', -5,...
    'max', 5);
end

% NumberDisplays
appData.leftNumDisplays = cell(1,4);
appData.rightNumDisplays = cell(1,4);

for i = 1:length(appData.leftSliders)
appData.leftNumDisplays{i} = uicontrol('Style','text',...
    'units', 'normalized',...
    'BackgroundColor', [0.800 0.9400 0.9400],...
    'ButtonDownFcn', {@leftTextCallback, i, appData},...
    'String',num2str(appData.leftSliders{i}.Value),...
    'Position',[0.41,(0.12 -0.04*(i-1)),0.1,0.05]);
end
for i = 1:length(appData.rightSliders)
appData.rightNumDisplays{i} = uicontrol('Style','text',...
    'units', 'normalized',...
    'BackgroundColor', [0.800 0.9400 0.9400],...
    'ButtonDownFcn', {@rightTextCallback, i, appData},...
    'String',num2str(appData.rightSliders{i}.Value),...
    'Position',[0.53,(0.12 -0.04*(i-1)),0.1,0.05]);
end


% Time plots
figure(3), clf

appData.timeData = timePlotDataFromPreset(appData.presetStore(1,:));
appData.timePlots = createAllTimePlots(appData.timeData);
set(figure(3), 'Position',(get(figure(2), 'Position') - [0, 420, 0, 0]))

% Timbre plots
figure(4), clf

appData.timbreData = timbrePlotDataFromPreset(appData.presetStore(1,:));
appData.timbrePlots = createAllTimbrePlots(appData.timbreData);
set(figure(4), 'Position',(get(figure(2), 'Position') - [560, 420, 0, -420]))

%Initialise seding data to command line
dispstat('','init') 

if isMidiEnabled == true
    %Initilasise Midi CC input
    midiControls = cell(1,8);
    for i = 1:8
        midiControls{i} = midicontrols(i, 'MIDIDevice', 'IAC Driver Bus 1');
        functionHandle = @(x)midiCallback(x,i, appData);
        midicallback(midiControls{i},functionHandle);
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
%                     selectedIndeces = idxSelected;
%                     break
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
%     
%     % Change parameters to this preset
%     sendAllStructParamsOverOSC(appData.presetStoreVaried(idx,:),...
%         appData.nameStrings, appData.typeStrings, appData.u);
%     
%     % Update Time Plots
%     appData.timeData = timePlotDataFromPreset(appData.presetStoreVaried(idx,:));
%     appData.timePlots = updateTimePlots(appData.timePlots, appData.timeData); 
%     
%     % Update Timbre Plots
%     appData.timbreData = timbrePlotDataFromPreset(appData.presetStoreVaried(idx,:));
%     appData.timbrePlots = updateTimbrePlots(appData.timbrePlots, appData.timbreData); 
%     
%     % Update Preset number popup
%     appData.popup.Value = idx;
%     
%     % Display Parameter Values to Command Line
%     dispstat(sprintf(preset2string(appData.presetStoreVaried(appData.idxCurrent, :),...
%                                 appData.nameStrings)));
%     % Old Patch
%     if ~ismember(appData.idxCurrent, appData.idxSelected)
%         
%         %appData.patches{appData.idxCurrent}.FaceColor = appData.colours{appData.idxCurrent};
%         appData.patches{appData.idxCurrent}.EdgeColor = [0,0,0];
%         appData.patches{appData.idxCurrent}.LineWidth = 0.5;
%     else
%         %appData.patches{appData.idxCurrent}.FaceColor = appData.selectedColour;
%         appData.patches{appData.idxCurrent}.EdgeColor = appData.selectedColour;
%     end
%     
%     % New patch
%     if ~ismember(idx, appData.idxSelected)
%         
%         %appData.patches{idx}.FaceColor = appData.mouseOverColour;
%         appData.patches{idx}.EdgeColor = appData.mouseOverColour;
%         appData.patches{idx}.LineWidth = 5;
%         
%     else
%         %appData.patches{idx}.FaceColor = appData.mouseOverSelectedColour;
%         appData.patches{idx}.EdgeColor = appData.mouseOverSelectedColour;
%         appData.patches{idx}.LineWidth = 5;
%     end
%     
%     % Update sliders to new preset
%     appData.leftSliders{1}.Value = appData.presetPCAParams{idx}(1,1);
%     appData.leftSliders{2}.Value = appData.presetPCAParams{idx}(1,2);
%     appData.leftSliders{3}.Value = appData.presetPCAParams{idx}(1,3);
%     appData.leftSliders{4}.Value = appData.presetPCAParams{idx}(1,4);
%     
%     appData.rightSliders{1}.Value = appData.presetPCAParams{idx}(2,1);
%     appData.rightSliders{2}.Value = appData.presetPCAParams{idx}(2,2);
%     appData.rightSliders{3}.Value = appData.presetPCAParams{idx}(2,3);
%     appData.rightSliders{4}.Value = appData.presetPCAParams{idx}(2,4);
%     
%     % Update NumDisplays top new preset
%     appData.leftNumDisplays{1}.String = num2str(appData.presetPCAParams{idx}(1,1));
%     appData.leftNumDisplays{2}.String = num2str(appData.presetPCAParams{idx}(1,2));
%     appData.leftNumDisplays{3}.String = num2str(appData.presetPCAParams{idx}(1,3));
%     appData.leftNumDisplays{4}.String = num2str(appData.presetPCAParams{idx}(1,4));
%     
%     appData.rightNumDisplays{1}.String = num2str(appData.presetPCAParams{idx}(2,1));
%     appData.rightNumDisplays{2}.String = num2str(appData.presetPCAParams{idx}(2,2));
%     appData.rightNumDisplays{3}.String = num2str(appData.presetPCAParams{idx}(2,3));
%     appData.rightNumDisplays{4}.String = num2str(appData.presetPCAParams{idx}(2,4));
%     
%     appData.idxCurrent = idx;
%     %drawnow()

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

testScore = alteredPresetFlattened*appData.coeff(:,1:5);

% Maybe should store the minimum and maximum value to avoid recalculation
x = mapRange(testScore(1), min(appData.score(:,1)), max(appData.score(:,1)), 0.05, 0.95);
y = mapRange(testScore(2), min(appData.score(:,2)), max(appData.score(:,2)), 0.05, 0.95);
R = bound(mapRange(testScore(3), min(appData.score(:,3)), max(appData.score(:,3)), 0.1, 1), 0, 1);
G = bound(mapRange(testScore(4), min(appData.score(:,4)), max(appData.score(:,4)), 0.1, 1), 0, 1);
B = bound(mapRange(testScore(5), min(appData.score(:,5)), max(appData.score(:,5)), 0.1, 1), 0, 1);

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
    
    appData.variedPresetLines{appData.idxCurrent}.XData(2) = x;
    appData.variedPresetLines{appData.idxCurrent}.YData(2) = y;
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

function numPopUpCallback(object, eventdata, appData)
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
