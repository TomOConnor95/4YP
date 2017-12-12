% Voronoi Diagram with Color
% This code uses |voronoin| and |patch| to
% fill the bounded cells of the same Voronoi diagram with color.

% Copyright 2015 The MathWorks, Inc.

figure(1)

numPoints = 20;



x = gallery('uniformdata',[2*numPoints 2],1);
[v,c] = voronoin(x); 
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),[0.6,0.9+ 0.1*rand,0.6 + 0.4*rand],'HitTest','off'); % use color i.
    end
end

xlim([0,1])
ylim([0,1])
colormap(summer(100))

hold on
plot(x(:,1), x(:,2), 'b+')



% read continuous mouse position
set (gcf, 'WindowButtonMotionFcn', @mouseMoved);
set (gca, 'ButtonDownFcn', @mouseClicked);

P1current = [0,0];
MOUSE = [0,0];

idxCurrent = 1;

isMouseClicked = false;
idxFrozen = [];

while(true)
    
    if isMouseClicked
        isMouseClicked = false;
        
        patch(v(c{idx},1),v(c{idx},2),[1.0, 0.2, 0.7],'HitTest','off');
        plot(x(idx,1), x(idx,2), 'b+')
        
        if ~ismember(idx, idxFrozen)
            idxFrozen = [idxFrozen, idx]
            
            if length(idxFrozen) == 3
                selectedIndeces = idxFrozen;
                break
            end
            
        end
  
    end
    
    
    P1 = [MOUSE(1,1), MOUSE(1,2)];
        
    % has P1 Changed?
    if ~isequal(P1,P1current)
        P1current = P1;
        
        % Find closest point to mouse Point
        closestPoint=bsxfun(@minus,x,P1);
        [out,idx]=min(hypot(closestPoint(:,1),closestPoint(:,2)));
        
        if ismember(idx, idxFrozen)
            continue
        end
        
        if idx ~= idxCurrent
            
            if ~ismember(idxCurrent, idxFrozen)
                % Old Patch
                patch(v(c{idxCurrent},1),v(c{idxCurrent},2),[0.6,0.9+ 0.1*rand,0.6 + 0.4*rand],'HitTest','off');
                plot(x(idxCurrent,1), x(idxCurrent,2), 'b+')
            end
            
            % New patch
            patch(v(c{idx},1),v(c{idx},2),[0.9, 0.6, 0.6],'HitTest','off');
            plot(x(idx,1), x(idx,2), 'b+')
            
            idxCurrent = idx;
            drawnow()
            
        end

    end
    pause(0.02)
end

disp(['selected indeces: ', mat2str(selectedIndeces)])






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
