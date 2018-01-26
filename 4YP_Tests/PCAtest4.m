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
% Add Sliders to adjust the PCs

% Sliders
appData.sliders = cell(1,4);
for i = 1:length(appData.sliders)
appData.sliders{i} = uicontrol('style', 'slider',...
    'string', 'Slider1',...
    'units', 'normalized',...
    'position', [0.05 (0.12 -0.04*(i-1)) 0.25 0.05],...
    'callback', {@sliderCallback, i, appData},...
    'visible', 'on',...
    'FontSize', 13,...
    'min', -5,...
    'max', 5);

end
% NumberDisplays
appData.numDisplays = cell(1,4);
for i = 1:length(appData.sliders)
appData.numDisplays{i} = uicontrol('Style','text',...
    'units', 'normalized',...
    'BackgroundColor', [0.800 0.9400 0.9400],...
    'ButtonDownFcn', {@textCallback, i, appData},...
    'String',num2str(appData.sliders{i}.Value),...
    'Position',[0.3,(0.12 -0.04*(i-1)),0.1,0.05]);
end
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
    idx = appData.idxSelected(length(appData.idxSelected))
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

function sliderCallback (object, eventdata, idx, appData)
disp(['slider 1: ', num2str(appData.sliders{1}.Value)])
disp(['slider 2: ', num2str(appData.sliders{2}.Value)])
disp(['slider 3: ', num2str(appData.sliders{3}.Value)])
disp(['slider 4: ', num2str(appData.sliders{4}.Value)])

for i = 1:4
appData.numDisplays{i}.String = num2str(appData.sliders{i}.Value);
end

end

function textCallback (object, eventdata, idx, appData)
% NOT WORKING!!!!
appData.numDisplays{idx}.String = num2str(0);
appData.sliders{idx}.Value = 0;

end