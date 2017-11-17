function [ edgePoints] = HexGridEdge( nRows, nColumns, gridLength)
%HEXGRID creates equilateral triangular mesh

totalPoints = (nRows+nColumns)*2 -4;
gridHeight = gridLength*sqrt(3)/2;

edgePoints = zeros(totalPoints,2);

thinRow = linspace(0,gridLength*(nColumns-1),nColumns) + gridLength/2;
thickRow = linspace(0,gridLength*(nColumns),nColumns+1);

thinInnerRow = linspace(0,gridLength*(nColumns-1),2) + gridLength/2;
thickInnerRow = linspace(0,gridLength*(nColumns),2);



pointCounter = 1;

for i = 1:nRows
    if i == 1 || i == nRows
        if (mod(i,2) ==1)
            edgePoints(pointCounter:pointCounter + nColumns - 1,1) = thinRow';
            edgePoints(pointCounter:pointCounter + nColumns - 1,2) = (i-1)*gridHeight*ones(nColumns,1);
            pointCounter = pointCounter + nColumns;
        else
            edgePoints(pointCounter:pointCounter + nColumns,1) = thickRow';
            edgePoints(pointCounter:pointCounter + nColumns,2) = (i-1)*gridHeight*ones(nColumns+1,1);
            pointCounter = pointCounter + nColumns+1;
        end
    else
        if (mod(i,2) ==1)
            edgePoints(pointCounter:pointCounter + 1,1) = thinInnerRow';
            edgePoints(pointCounter:pointCounter + 1,2) = (i-1)*gridHeight*ones(2,1);
            pointCounter = pointCounter + 2;
        else
            edgePoints(pointCounter:pointCounter + 1,1) = thickInnerRow';
            edgePoints(pointCounter:pointCounter + 1,2) = (i-1)*gridHeight*ones(2,1);
            pointCounter = pointCounter + 2;
        end
        
        
    end
end

end
    
