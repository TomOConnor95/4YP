% Voronoi Diagram with Color
% This code uses |voronoin| and |patch| to
% fill the bounded cells of the same Voronoi diagram with color.

% Copyright 2015 The MathWorks, Inc.

figure(1)

numPoints = 20;

x = gallery('uniformdata',[numPoints 2],1);

global MOUSE
global isMouseClicked

MOUSE = [0,0];
isMouseClicked = false;

selectedIndeces = voronoiSelection(x);

disp(['selected indeces: ', mat2str(selectedIndeces)])


function selectedIndeces = voronoiSelection(x)
    global MOUSE
    global isMouseClicked
    
    numPoints = length(x(:,1));
    
    colours = cell(1,numPoints);
    for i = 1:numPoints
            colours{i} = [0.6,0.9+ 0.1*rand,0.6 + 0.4*rand];
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

            % Change parameters to this preset

            % Find closest point to mouse Point
            closestPoint=bsxfun(@minus,x,P1);
            [~,idx]=min(hypot(closestPoint(:,1),closestPoint(:,2)));

            if idx ~= idxCurrent

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



function mouseClicked (object, eventdata)

disp('CLICK')

% detects mouse clicks and 
assignin('base','isMouseClicked',1)

end

function mouseMoved (object, eventdata)
% writes continuous mouse position to base workspace
MOUSE = get (gca, 'CurrentPoint');

assignin('base','MOUSE',MOUSE)
end
