
%% Plot Delaunay Triangulation
% Plot a Delaunay triangulation for 10 randomly generated points.

% Copyright 2015 The MathWorks, Inc.

%P = gallery('uniformdata',10,2,2);
clear all
close all
P = rand(10,2);
colormap summer

for i=1:9
subplot(3,3,i)
DT = delaunayTriangulation(P);
triplot(DT)
hold on
IC = incenter(DT)
plot(IC(:,1),IC(:,2),'r+');
P=IC+rand(size(IC))
P=P(1:10,:)
pause
end
