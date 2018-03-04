function patches = filledVoronoi(D,ax)
% Colour unbounded cells of voronoi diagram in MATLAB
% https://stackoverflow.com/questions/40932015/color-unbounded-cells-of-voronoi-diagram-in-matlab
    [v,c]=voronoin(D);
        
    %This is needed to find all of the edges, 
    if nargin ==2
    h = voronoi(ax, D(:,1), D(:,2));    %This plots the diagram, so be careful!
    else
    h = voronoi(D(:,1), D(:,2));  
    end
    
    v1 = shiftdim(reshape([h(2).XData;h(2).YData],2,3,[]),2); % Arranged one edge per row, one vertex per slice in the third dimension

    % The unbounded edges are plotted last, so you can isolate these by counting unbounded cells in c:

    nUnbounded = sum(cellfun(@(ic)ismember(1,ic),c));
    v1Unbounded = v1(end-(nUnbounded-1):end,:,:);


    [~,iBounded] = min(pdist2(v,v1Unbounded(:,:,1))); % Index of the bounded vertex
    vUnbounded = v1Unbounded(:,:,2); % Displayed coordinate of the unbounded end of the cell edge


    patches = cell(1,length(c));

    for p=1:length(D(:,1))
        
        for s=1:length(c{p})

            cPatch = c{p}; % List of vertex indices
            vPatch = v(cPatch,:); % Vertex coordinates which may contain Inf
            idx = find(cPatch==1); % Check if cell has unbounded edges
            if idx
                cPatch = circshift(cPatch,-idx); % Move the 1 to the end of the list of vertex indices
                vPatch = [vPatch(1:idx-1,:)
                    vUnbounded(iBounded == cPatch(end-1),:)
                    vUnbounded(iBounded == cPatch(1),:)
                    vPatch(idx+1:end,:)]; % Replace Inf values at idx with coordinates from the unbounded edges that meet the two adjacent finite vertices
            end
        end
        patches{p} = vPatch;
        %patches{p} = patch(ax, vPatch(:,1),vPatch(:,2),colours{p}, 'HitTest', 'off');
    end


end