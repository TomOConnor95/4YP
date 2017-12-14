

figure(1)

numPoints = 20;

D = gallery('uniformdata',[numPoints 2],1);

colours = cell(1,20);
for i = 1:numPoints
        colours{i} = [0.6,0.9+ 0.1*rand,0.6 + 0.4*rand];
end

patches = filledVoronoi(D, colours);


