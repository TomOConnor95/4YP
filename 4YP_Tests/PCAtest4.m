% Test script for PCA selection editing of presets blending interface
close all

% Option parameters

% Miscellaneous Set-up Parameters
% Mouse clicks
global MOUSE
global isMouseClicked
MOUSE = [0,0];              % Mouse State
isMouseClicked = false;          % Has mouse been pressed?

appData = ApplicationDataVoronoi();
% Open UDP connection
appData.u = udp('127.0.0.1',57120);
fopen(appData.u);

% Choose initial presets

% Get nameStrings and TypeStrings    Maybe just save these in presetStore
[~, appData.nameStrings, appData.typeStrings] = createPresetAforOSC();

presetRead = matfile('PresetStoreSC.mat');

appData.presetStore = presetRead.presetStore;
presetStoreFlattened = cell2mat(presetRead.presetStore);

numPoints = length(presetStore(:,1));

[coeff, score, latent] = pca(presetStoreFlattened);

appData.coeff = coeff;
appData.score = score;
appData.latent = latent;

x = score(:,1:2);
x(:,1) = mapRange(x(:,1), min(x(:,1)), max(x(:,1)), 0.05,0.95);
x(:,2) = mapRange(x(:,2), min(x(:,2)), max(x(:,2)), 0.05,0.95);

appData.presetPositions = x;
% Colours
appData.colours = cell(1,numPoints);
for i = 1:numPoints
    R = mapRange(score(i,3), min(score(:,3)), max(score(:,3)), 0.1,1);
    G = mapRange(score(i,4), min(score(:,4)), max(score(:,4)), 0.1,1);
    B = mapRange(score(i,5), min(score(:,5)), max(score(:,5)), 0.1,1);
    
    appData.colours{i} = [R,G,B];
    % Might be able to vectorise this whole thing!
    
    %         colours{i} = [0.6,0.9+ 0.1*rand,0.6 + 0.4*rand];
end

figure(2)
appData.patches = filledVoronoi(appData.presetPositions, appData.colours);

appData.patchesPressed = zeros(1,numPoints);
for i = 1:numPoints

    set(appData.patches{i}, 'ButtonDownFcn', {@patchClicked, i, appData})
    set(appData.patches{i}, 'HitTest', 'On')
    
end

hold on
plot(appData.presetPositions(:,1), appData.presetPositions(:,2),...
    'b+', 'HitTest', 'off', 'PickableParts', 'none')

set (gcf, 'WindowButtonMotionFcn', {@mouseMoving, appData});


function patchClicked (object, eventdata, idx, appData)
    % writes continuous mouse position to base workspace
    disp(['Patch ', num2str(idx), ' Clicked'])

%     if appData.patchesPressed(patchNo) == 0
%         appData.patchesPressed(patchNo) = 1;
%         appData.patches{patchNo}.FaceColor = appData.selectedColour;
% 
%     else
% 
%         appData.patchesPressed(patchNo) = 0;
%         appData.patches{patchNo}.FaceColor = appData.colours{patchNo};
%     end
    
    if ~ismember(idx, appData.idxSelected)
                appData.idxSelected = [appData.idxSelected, idx];

                appData.patches{idx}.FaceColor = appData.selectedColour;

                if length(appData.idxSelected) == 3
                    
                    disp('3 Presets Selected!');
%                     selectedIndeces = idxSelected;
%                     break
                end
            
                
            else

                appData.idxSelected(appData.idxSelected == idx) = [];

                appData.patches{idx}.FaceColor = appData.mouseOverColour;

    end   
    drawnow()
    
end

function mouseMoving (object, eventdata, appData)
% writes continuous mouse position to base workspace
MOUSE = get (gca, 'CurrentPoint');
mousePos = MOUSE(1,1:2);
closestPoint=bsxfun(@minus,appData.presetPositions,mousePos);
[~,idx]=min(hypot(closestPoint(:,1),closestPoint(:,2)));
disp(['Index: ', num2str(idx)])


% Has index changed?
if idx ~= appData.idxCurrent
    % Change parameters to this preset
    sendAllStructParamsOverOSC(appData.presetStore(idx,:),...
        appData.nameStrings, appData.typeStrings, appData.u);
    
    % Old Patch
    if ~ismember(appData.idxCurrent, appData.idxSelected)
        
        appData.patches{appData.idxCurrent}.FaceColor = appData.colours{appData.idxCurrent};
    else
        appData.patches{appData.idxCurrent}.FaceColor = appData.selectedColour;
    end
    
    % New patch
    if ~ismember(idx, appData.idxSelected)
        
        appData.patches{idx}.FaceColor = appData.mouseOverColour;
    else
        appData.patches{idx}.FaceColor = appData.mouseOverSelectedColour;
    end
    
    appData.idxCurrent = idx;
    drawnow()
    
    
end



end


