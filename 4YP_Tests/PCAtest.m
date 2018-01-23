

presetRead = matfile('PresetStoreSC.mat');

presetStoreFlattened = cell2mat(presetRead.presetStore);

[coeff, score, latent] = pca(presetStoreFlattened);
for i = 1:17
labels{i} = num2str(i);
end
figure(8)
bp = biplot(coeff(:,1:2),'scores',score(:,1:2), 'ObsLabels', labels);
figure(9)
clf
hold on

for i = 1:length(score(:,1))
    
    % Use PCA colums 3,4,5 for RGB colours
    R = mapRange(score(i,3), min(score(:,3)), max(score(:,3)), 0,1);
    G = mapRange(score(i,4), min(score(:,4)), max(score(:,4)), 0,1);
    B = mapRange(score(i,5), min(score(:,5)), max(score(:,5)), 0,1);
    
    markerPlot = plot(score(i,1), score(i,2), 'ro',...
        'MarkerFaceColor', [R,G,B],...
        'MarkerEdgeColor', [R,G,B],...
        'MarkerSize', 10);
    
end


figure(10)
clf
hold on
grid on

for i = 1:length(score(:,1))
    
    % Use PCA colums 4,5,6 for RGB colours
    R = mapRange(score(i,4), min(score(:,4)), max(score(:,4)), 0.1,1);
    G = mapRange(score(i,5), min(score(:,5)), max(score(:,5)), 0.1,1);
    B = mapRange(score(i,6), min(score(:,6)), max(score(:,6)), 0.1,1);
    
    markerPlot = plot3(score(i,1), score(i,2), score(i,3), 'ro',...
        'MarkerFaceColor', [R,G,B],...
        'MarkerEdgeColor', [R,G,B],...
        'MarkerSize', 10);
    
end


