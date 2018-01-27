% Test script for PCA selection editing of presets blending interface
%close all

% Option parameters

% Set up GUI figure
appData = ApplicationDataVoronoi();


% Perform PCA on presets
presetStoreFlattened = cell2mat(appData.presetStore);
[coeff, score, latent] = pca(presetStoreFlattened);

appData.coeff = coeff;
appData.score = score;
appData.latent = latent;

appData.coeffCell = createCoeffCell(appData.coeff);

x = score(:,1:2);
x(:,1) = mapVectorRange(x(:,1), 0.05,0.95);
x(:,2) = mapVectorRange(x(:,2), 0.05,0.95);

appData.presetPositions = x;



% Colours
R = mapVectorRange(score(:,3), 0.1,1);
G = mapVectorRange(score(:,4), 0.1,1);
B = mapVectorRange(score(:,5), 0.1,1);
appData.colours = num2cell([R,G,B],2);

% Create voronoi diagram from preset locations
figure(2)
clf
hold on

appData.patches = filledVoronoi(appData.presetPositions, appData.colours);

for i = 1:length(appData.presetStore(:,1))
    set(appData.patches{i}, 'ButtonDownFcn', {@patchClicked, i, appData})
    set(appData.patches{i}, 'HitTest', 'On')  
end

plot(appData.presetPositions(:,1), appData.presetPositions(:,2),...
    'b+', 'HitTest', 'off', 'PickableParts', 'none')

set(gcf, 'WindowButtonMotionFcn', {@mouseMoving, appData});
set(gca, 'Position', [0.1300 0.2100 0.7750 0.7150]);


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

%Callbacks
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
    % Change parameters to this preset
    sendAllStructParamsOverOSC(appData.presetStore(idx,:),...
        appData.nameStrings, appData.typeStrings, appData.u);
    
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
    
    appData.idxCurrent = idx;
    %drawnow()

end


end

function leftSliderCallback (object, eventdata, idx, appData)
disp(['leftSlider 1: ', num2str(appData.leftSliders{1}.Value)])
disp(['leftSlider 2: ', num2str(appData.leftSliders{2}.Value)])
disp(['leftSlider 3: ', num2str(appData.leftSliders{3}.Value)])
disp(['leftSlider 4: ', num2str(appData.leftSliders{4}.Value)])

appData.leftNumDisplays{idx}.String = num2str(appData.leftSliders{idx}.Value);

pcaWeights = [appData.leftSliders{1}.Value,...
              appData.leftSliders{2}.Value,...
              appData.leftSliders{3}.Value,...
              appData.leftSliders{4}.Value,...
              appData.rightSliders{1}.Value,...
              appData.rightSliders{2}.Value,...
              appData.rightSliders{3}.Value,...
              appData.rightSliders{4}.Value];
% Alter Selected preset
appData.presetStoreVaried(appData.idxCurrent,:) = adjustPresetWithPCA(...
    appData.presetStore(appData.idxCurrent,:), appData.coeffCell,...
    pcaWeights);

    sendAllStructParamsOverOSC(appData.presetStoreVaried(appData.idxCurrent,:),...
        appData.nameStrings, appData.typeStrings, appData.u);


end
function rightSliderCallback (object, eventdata, idx, appData)
disp(['rightSlider 1: ', num2str(appData.rightSliders{1}.Value)])
disp(['rightSlider 2: ', num2str(appData.rightSliders{2}.Value)])
disp(['rightSlider 3: ', num2str(appData.rightSliders{3}.Value)])
disp(['rightSlider 4: ', num2str(appData.rightSliders{4}.Value)])

appData.rightNumDisplays{idx}.String = num2str(appData.rightSliders{idx}.Value);

end

function leftTextCallback (object, eventdata, idx, appData)
% Works with Right click
appData.leftNumDisplays{idx}.String = num2str(0);
appData.leftSliders{idx}.Value = 0;

end
function rightTextCallback (object, eventdata, idx, appData)
% Works with Right click
appData.rightNumDisplays{idx}.String = num2str(0);
appData.rightSliders{idx}.Value = 0;

end
