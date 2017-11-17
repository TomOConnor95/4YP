function [ grid] = HexGrid( nRows, nColumns, gridLength)
%HEXGRID creates equilateral triangular mesh

totalPoints = nRows*nColumns + floor(nRows/2);
gridHeight = gridLength*sqrt(3)/2;

grid = zeros(totalPoints,2);

thinRow = linspace(0,gridLength*(nColumns-1),nColumns) + gridLength/2;
thickRow = linspace(0,gridLength*(nColumns),nColumns+1);

pointCounter = 1;

for i = 1:nRows
    
   if (mod(i,2) ==1)
       grid(pointCounter:pointCounter + nColumns - 1,1) = thinRow';
       grid(pointCounter:pointCounter + nColumns - 1,2) = (i-1)*gridHeight*ones(nColumns,1);
       pointCounter = pointCounter + nColumns;
   else
       grid(pointCounter:pointCounter + nColumns,1) = thickRow';
       grid(pointCounter:pointCounter + nColumns,2) = (i-1)*gridHeight*ones(nColumns+1,1);
       pointCounter = pointCounter + nColumns+1;
   end
end

