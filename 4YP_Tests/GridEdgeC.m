function [ C ] = GridEdgeC( nRows, nColumns)
%GRIDEDGEC finds point numbers for the points on the edge of the mesh
totalGridPoints = nRows*nColumns + floor(nRows/2);
totalEdgePoints = (nRows+nColumns)*2 -3-mod(nRows,2);
edgePointNos = zeros(1,totalEdgePoints);

% Bottom edge
edgePointNos(1:nColumns) = [1:nColumns];

% Right side 
    % Wide rows
edgePointNos((nColumns + 1):2:(nColumns + nRows - 2)) = [(1+2*nColumns):(1+2*nColumns):(totalGridPoints-nColumns-(1-floor(nRows/2)))];
    % Thin rows
edgePointNos((nColumns + 2):2:(nColumns + nRows - 2)) = [(1+3*nColumns):(1+2*nColumns):(totalGridPoints-((1+mod(nRows,2))*nColumns)-1)];

% Top edge
edgePointNos((nColumns + nRows - 1):(2*nColumns + (nRows - 2)+(1-mod(nRows,2)))) = [totalGridPoints:-1:(totalGridPoints-nColumns+mod(nRows,2))];

% Left side ISSUES HERE
    % Wide rows
edgePointNos((totalEdgePoints - nRows + 4):2:totalEdgePoints) = [(totalGridPoints-((3-mod(nRows,2))*nColumns)+(1-mod(nRows,2))):-(1+2*nColumns):(nColumns+1)];
    % Thin rows
edgePointNos((totalEdgePoints - nRows + 3):2:(totalEdgePoints-1)) = [(totalGridPoints-((2+mod(nRows,2))*nColumns)-mod(nRows,2)):-(1+2*nColumns):(2*nColumns+2)];
 


end


