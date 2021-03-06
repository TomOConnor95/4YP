function selectedIndeces = voronoiSelection(storeString, u, nameStrings, typeStrings)
    global MOUSE
    global isMouseClicked
    
    if nargin == 0
        presetRead = matfile('PresetStoreSC.mat');
    else
        presetRead = matfile(storeString);
    end
    
     presetStore = presetRead.presetStore;

    numPoints = length(presetStore(:,1));
% 
%     x = gallery('uniformdata',[numPoints 2],1);

    presetStoreFlattened = cell2mat(presetRead.presetStore);

    [coeff, score, latent] = pca(presetStoreFlattened);

    x = score(:,1:2);
    x(:,1) = mapRange(x(:,1), min(x(:,1)), max(x(:,1)), 0.05,0.95);
    x(:,2) = mapRange(x(:,2), min(x(:,2)), max(x(:,2)), 0.05,0.95);

    colours = cell(1,numPoints);
    for i = 1:numPoints
        R = mapRange(score(i,3), min(score(:,3)), max(score(:,3)), 0.1,1);
        G = mapRange(score(i,4), min(score(:,4)), max(score(:,4)), 0.1,1);
        B = mapRange(score(i,5), min(score(:,5)), max(score(:,5)), 0.1,1);
        
        colours{i} = [R,G,B];
        % Might be able to vectorise this whole thing!
        
%         colours{i} = [0.6,0.9+ 0.1*rand,0.6 + 0.4*rand];
    end

    selectedColour = [1.0, 0.2, 0.7];
    mouseOverColour = [0.9, 0.6, 0.6];
    mouseOverSelectedColour = [1.0, 0.4, 0.75];

    patches = filledVoronoi(x, colours);

    hold on
    plot(x(:,1), x(:,2), 'b+')

    % read continuous mouse position
    set (gcf, 'WindowButtonMotionFcn', @mouseMoved);
    set (gca, 'ButtonDownFcn', @mouseClicked);

    % Misc variables
    P1current = [0,0];
    idxCurrent = 1;
    idxSelected = [];

    while(true)

        if isMouseClicked
            isMouseClicked = false;

            if ~ismember(idx, idxSelected)
                idxSelected = [idxSelected, idx];

                patches{idx}.FaceColor = selectedColour;

                if length(idxSelected) == 3
                    selectedIndeces = idxSelected;
                    break
                end

            else

                idxSelected(idxSelected == idx) = [];

                patches{idx}.FaceColor = mouseOverColour;

            end     

        end


        P1 = [MOUSE(1,1), MOUSE(1,2)];

        % has P1 Changed?
        if ~isequal(P1,P1current)
            P1current = P1;

            % Find closest point to mouse Point
            closestPoint=bsxfun(@minus,x,P1);
            [~,idx]=min(hypot(closestPoint(:,1),closestPoint(:,2)));
            
            % Has index changed?
            if idx ~= idxCurrent
                % Change parameters to this preset
                sendAllStructParamsOverOSC(presetStore(idx,:), nameStrings, typeStrings, u);
                
                % Old Patch
                if ~ismember(idxCurrent, idxSelected)

                    patches{idxCurrent}.FaceColor = colours{idxCurrent};
                else
                    patches{idxCurrent}.FaceColor = selectedColour;
                end

                % New patch
                if ~ismember(idx, idxSelected)

                    patches{idx}.FaceColor = mouseOverColour;
                else
                    patches{idx}.FaceColor = mouseOverSelectedColour;
                end

                idxCurrent = idx;
                drawnow()

            end
        end
        pause(0.02)
    end
end