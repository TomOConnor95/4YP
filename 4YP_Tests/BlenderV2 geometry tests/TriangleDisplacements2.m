function [ VertexDisplacements ] = TriangleDisplacements2( Triangle,k,MeanDistance)
%VERTEXDISPLACEMENTS Summary of this function goes here
%   Detailed explanation goes here
 Distances= [sqrt((Triangle(1,1)-Triangle(2,1)).^2+(Triangle(1,2)-Triangle(2,2)).^2)
            sqrt((Triangle(2,1)-Triangle(3,1)).^2+(Triangle(2,2)-Triangle(3,2)).^2)
            sqrt((Triangle(3,1)-Triangle(1,1)).^2+(Triangle(3,2)-Triangle(1,2)).^2)];
        
   offset12 = Triangle(2,:)-Triangle(1,:)     ;
   offset23 = Triangle(3,:)-Triangle(2,:)       ;   
   offset31 = Triangle(1,:)-Triangle(3,:)     ;
   
  % Extension = Distances - mean(Distances);
  Extension = Distances - MeanDistance;
   
Displacement1 = k*Extension(1)*offset12-k*Extension(3)*offset31;
Displacement2 = -k*Extension(1)*offset12+k*Extension(2)*offset23;
Displacement3 = -k*Extension(2)*offset23+k*Extension(3)*offset31;



VertexDisplacements = [Displacement1;Displacement2;Displacement3];
end

