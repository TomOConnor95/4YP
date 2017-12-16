% Voronoi Diagram with Color
% This code uses |voronoin| and |patch| to
% fill the bounded cells of the same Voronoi diagram with color.

% Copyright 2015 The MathWorks, Inc.

figure(1)

numPoints = 20;

x = gallery('uniformdata',[numPoints 2],1);

global MOUSE
global isMouseClicked

MOUSE = [0,0];
isMouseClicked = false;

selectedIndeces = voronoiSelection(x);

disp(['selected indeces: ', mat2str(selectedIndeces)])

