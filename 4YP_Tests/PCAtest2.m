
presetRead = matfile('PresetStoreSC.mat');

presetStore = presetRead.presetStore;
presetStoreFlattened = cell2mat(presetStore);

testPreset = presetStoreFlattened(17,:);
presetStoreFlattened = presetStoreFlattened(1:16,:);


mu = mean(presetStoreFlattened);

presetStoreFlattened = presetStoreFlattened - mu;

[coeff, score, latent] = pca(presetStoreFlattened);


labels = cell(1,length(presetStore(:,1)));
for i = 1:length(score(:,1))
labels{i} = num2str(i);
end


figure(10)
clf
hold on

for i = 1:length(score(:,1))       %length(score(:,1))
    
    % Use PCA colums 3,4,5 for RGB colours
    R = mapRange(score(i,3), min(score(:,3)), max(score(:,3)), 0,1);
    G = mapRange(score(i,4), min(score(:,4)), max(score(:,4)), 0,1);
    B = mapRange(score(i,5), min(score(:,5)), max(score(:,5)), 0,1);
    
    markerPlot = plot(score(i,1), score(i,2), 'ro',...
        'MarkerFaceColor', [R,G,B],...
        'MarkerEdgeColor', [R,G,B],...
        'MarkerSize', 10);
   text(score(i,1) + 0.2, score(i,2) + 0.2, labels{i}); 
end

i = 17;
testScore = testPreset*coeff;
R = bound(mapRange(testScore(3), min(score(:,3)), max(score(:,3)), 0,1), 0, 1);
G = bound(mapRange(testScore(4), min(score(:,4)), max(score(:,4)), 0,1), 0, 1);
B = bound(mapRange(testScore(5), min(score(:,5)), max(score(:,5)), 0,1), 0, 1);

    
    markerPlot = plot(testScore(1), testScore(2), 'ro',...
        'MarkerFaceColor', [R,G,B],...
        'MarkerEdgeColor', [R,G,B],...
        'MarkerSize', 10);
   text(testScore(1) + 0.2, testScore(2) + 0.2, '17 - Test'); 
