function [ VertexDisplacements ] = TriangleDisplacements( Triangle ,IC,k)
%VERTEXDISPLACEMENTS Summary of this function goes here
%   Detailed explanation goes here


offsets = [Triangle(:,1)-IC(1,1),Triangle(:,2)-IC(1,2)];
Distances = sqrt(offsets(:,1).^2+offsets(:,2).^2)      ;

Displacement = k*1./Distances.^1;



VertexDisplacements = Displacement.*offsets;
end

