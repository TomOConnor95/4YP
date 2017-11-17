clf
load usapolygon
% Define an edge constraint between two successive
% points that make up the polygonal boundary.
nump = numel(uslon);
C = [(1:(nump-1))' (2:nump)'; nump 1];
dt = delaunayTriangulation(uslon, uslat, C);

io = dt.isInterior();
patch('faces',dt(io,:), 'vertices', dt.Points, 'FaceColor','r');
axis equal;
axis([-130 -60 20 55]);
xlabel('Constrained Delaunay Triangulation of usapolygon', 'fontweight','b');