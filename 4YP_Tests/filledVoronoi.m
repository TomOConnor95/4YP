function patches = filledVoronoi(D,ax)
% Colour unbounded cells of voronoi diagram in MATLAB
% https://stackoverflow.com/questions/40932015/color-unbounded-cells-of-voronoi-diagram-in-matlab
    [v,c]=voronoin(D);
        
    %This is needed to find the points that are plotted for the unbounded edges, 
    if nargin ==2
    h = voronoi(ax, D(:,1), D(:,2));    %This plots the diagram, so be careful!
    else
    h = voronoi(D(:,1), D(:,2));  
    end

    v1 = shiftdim(reshape([h(2).XData;h(2).YData],2,3,[]),2); % Arranged one edge per row, one vertex per slice in the third dimension

    % The unbounded edges are plotted last, so you can isolate these by counting unbounded cells in c:
    nUnbounded = sum(cellfun(@(ic)ismember(1,ic),c));
    v1Unbounded = v1(end-(nUnbounded-1):end,:,:);

    if nUnbounded == length(D)
       disp('All cells unbounded')
    end

    [~,iBounded] = min(pdist2(v,v1Unbounded(:,:,1))); % Index of the bounded vertex
    vUnbounded = v1Unbounded(:,:,2); % Displayed coordinate of the unbounded end of the cell edge

    patches = cell(1,length(c));

    for p=1:length(D(:,1))
        
        cPatch = c{p}; % List of vertex indices
            vPatch = v(cPatch,:); % Vertex coordinates which may contain Inf
            idx = find(cPatch==1); % Check if cell has unbounded edges
            if idx
                cPatch = circshift(cPatch,-idx); % Move the 1 to the end of the list of vertex indices
                
                % Replace Inf values at idx with coordinates from the unbounded
                % edges that meet the two adjacent finite vertices
                % - 
                % Lots of awkward corner cases
                
                if length(vPatch) ==2
                    % only one bounded point so must be connected to 2 points
                    % which can directly be used
                    vPatch = [vPatch(1:idx-1,:)         % Values before inf
                    vUnbounded(iBounded == cPatch(end-1),:)
                    vPatch(idx+1:end,:)];  
                    
                elseif isequal(size(vUnbounded(iBounded == cPatch(end-1),:)),[1,2])...
                        && isequal(size(vUnbounded(iBounded == cPatch(1),:)),[1,2])
                    % only one unbounded point connected to the 2 bounded points
                    % which can directly be used
                    vPatch = [vPatch(1:idx-1,:)         % Values before inf
                        vUnbounded(iBounded == cPatch(end-1),:)
                        vUnbounded(iBounded == cPatch(1),:)
                        vPatch(idx+1:end,:)];           % Values after inf

                else
                    % Must check which are the correct points to use
                    vertecesA = vUnbounded(iBounded == cPatch(end-1),:);
                    vertecesB = vUnbounded(iBounded == cPatch(1),:);
                    
                    closestPointsA = zeros(length(vertecesA(:,1)), 2);
                    closestPointsB = zeros(length(vertecesB(:,1)), 2);
                    for i = 1:length(vertecesA(:,1))
                        norms = sqrt(sum((vertecesA(i,:) - D(:,:)).^2,2));
                        closestPointsA(i,:) = find(ceil(norms*1000) == min(ceil(norms*1000)));
                    end
                    for i = 1:length(vertecesB(:,1))
                        norms = sqrt(sum((vertecesB(i,:) - D(:,:)).^2,2));
                        closestPointsB(i,:) = find(ceil(norms*1000) == min(ceil(norms*1000)));
                    end
                    
                    for i = 1:length(closestPointsA(:,1))
                        for j = 1:length(closestPointsB(:,1))
                            if ~isempty(intersect(closestPointsA(i,:),closestPointsB(j,:)))
                                
                                if intersect(closestPointsA(i,:),closestPointsB(j,:)) == p
                                correctIndexA = i;
                                correctIndexB = j;
                                else
                                % Only get here if length of A and B = 2
                                correctIndexA = rem(i,2)+1;
                                correctIndexB = rem(j,2)+1;    
                                end
                                break
                            end 
                        end
                    end
                    
                    vPatch = [vPatch(1:idx-1,:)         % Values before inf
                        vertecesA(correctIndexA,:)
                        vertecesB(correctIndexB,:)
                        vPatch(idx+1:end,:)]; 
                    
                end
            end
            
        patches{p} = vPatch;
        %patches{p} = patch(ax, vPatch(:,1),vPatch(:,2),colours{p}, 'HitTest', 'off');
    end


end