presetRead = matfile('PresetStoreSC.mat');

presetStore = presetRead.presetStore;
presetStoreFlattened = cell2mat(presetStore);

%testPreset = presetStoreFlattened(17,:);
presetStoreFlattened = presetStoreFlattened(1:16,:);


mu = mean(presetStoreFlattened);

presetStoreCentered = presetStoreFlattened - mu;

[coeff, score, latent] = pca(presetStoreCentered);


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

% Figuring out how to use the coefficients to alter presets
testPresetFlattened = presetStoreFlattened(16,:);

% you can apply the PCAs simply by adding them in a weighted sum to
% original presets
pcaWeights = [1,0.5, -0.2, 0.3,0.4,-2];
alteredPreset = testPresetFlattened + (pcaWeights * coeff(:,1:6)');

% need to do usual mapping and bounds checking of preset values - easier in
% cell structure


% try it in cell structure
coeffCell = cell(1,12);

coeffCell{1} = coeff(1:36,1:8);
coeffCell{2} = coeff(37:42,1:8);
coeffCell{3} = coeff(43:48,1:8);
coeffCell{4} = coeff(49:54,1:8);
coeffCell{5} = coeff(55:60,1:8);
coeffCell{6} = coeff(61:66,1:8);
coeffCell{7} = coeff(67:72,1:8);
coeffCell{8} = coeff(73:75,1:8);
coeffCell{9} = coeff(76:78,1:8);
coeffCell{10} = coeff(79:83,1:8);
coeffCell{11} = coeff(84:88,1:8);
coeffCell{12} = coeff(89:94,1:8);

% alteredCellPreset = cell(1,12);
% for i = 1:12
%    alteredCellPreset{i} = presetStore{17, i} + (pcaWeights * coeffCell{i}');
% end

%% Setup
u = udp('127.0.0.1',57120); 
fopen(u); 

[~, nameStrings, typeStrings] = createPresetAforOSC();

presetToLoad = 5
%% Adjust with PCA
pcaWeights = [0,0,-1,2,0,5,2,1];
alteredCellPreset = adjustPresetWithPCA(presetStore(presetToLoad,:), coeffCell, pcaWeights);
sendAllStructParamsOverOSC(alteredCellPreset, nameStrings, typeStrings, u)


