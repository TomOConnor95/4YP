% A test to see how stable the PCA mapping is as more presets are added

presetRead = matfile('PresetStoreSC.mat');

presetStore = presetRead.presetStore;
presetStoreFlattenedOriginal = cell2mat(presetStore);

%presetStoreFlattenedOriginal = rand(36,94);


coeff = cell(1,36);
score = cell(1,36);
latent = cell(1,36);

for idx = 1:length(presetStore)
    presetStoreFlattened = presetStoreFlattenedOriginal([1:idx],:);
    
mu = mean(presetStoreFlattened);

presetStoreFlattened = presetStoreFlattened - mu;

[coeff{idx}, score{idx}, latent{idx}] = pca(presetStoreFlattened);

end

% PCA only

PCA1 = zeros(length(presetStore))*NaN;
PCA2 = zeros(length(presetStore))*NaN;
PCA3 = zeros(length(presetStore))*NaN;
PCA4 = zeros(length(presetStore))*NaN;
PCA5 = zeros(length(presetStore))*NaN;
PCA6 = zeros(length(presetStore))*NaN;

for idx = 2:length(presetStore)
    PCA1(idx, 1:idx) = score{idx}(:,1)';
end

for idx = 3:length(presetStore)
    PCA2(idx, 1:idx) = score{idx}(:,2)';
end

for idx = 4:length(presetStore)
    PCA3(idx, 1:idx) = score{idx}(:,3)';
end

for idx = 5:length(presetStore)
    PCA4(idx, 1:idx) = score{idx}(:,4)';
end

for idx = 6:length(presetStore)
    PCA5(idx, 1:idx) = score{idx}(:,5)';
end

for idx = 7:length(presetStore)
    PCA6(idx, 1:idx) = score{idx}(:,6)';
end


figure(12)
clf, 
subplot(3,2,1), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA1(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 1')

subplot(3,2,2), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA2(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 2')

subplot(3,2,3), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA3(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 3')

subplot(3,2,4), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA4(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 4')

subplot(3,2,5), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA5(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 5')

subplot(3,2,6), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA6(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 6')




% PCA + histogram equalisation
PCA1a = zeros(length(presetStore))*NaN;
PCA2a = zeros(length(presetStore))*NaN;
PCA3a = zeros(length(presetStore))*NaN;
PCA4a = zeros(length(presetStore))*NaN;
PCA5a = zeros(length(presetStore))*NaN;
PCA6a = zeros(length(presetStore))*NaN;

for idx = 2:length(presetStore)
    PCA1a(idx, 1:idx) = mapVectorRange(histogramNormalisation(score{idx}(:,1)'), -0.95,0.95);
end

for idx = 3:length(presetStore)
    PCA2a(idx, 1:idx) = mapVectorRange(histogramNormalisation(score{idx}(:,2)'), -0.95,0.95);
end

for idx = 4:length(presetStore)
    PCA3a(idx, 1:idx) = mapVectorRange(histogramNormalisation(score{idx}(:,3)'), -0.95,0.95);
end

for idx = 5:length(presetStore)
    PCA4a(idx, 1:idx) = mapVectorRange(histogramNormalisation(score{idx}(:,4)'), -0.95,0.95);
end

for idx = 6:length(presetStore)
    PCA5a(idx, 1:idx) = mapVectorRange(histogramNormalisation(score{idx}(:,5)'), -0.95,0.95);
end

for idx = 7:length(presetStore)
    PCA6a(idx, 1:idx) = mapVectorRange(histogramNormalisation(score{idx}(:,6)'), -0.95,0.95);
end


figure(13)
clf, 
subplot(3,2,1), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA1a(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 1')

subplot(3,2,2), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA2a(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 2')

subplot(3,2,3), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA3a(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 3')

subplot(3,2,4), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA4a(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 4')

subplot(3,2,5), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA5a(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 5')

subplot(3,2,6), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA6a(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 6')



% Manually corrected PCs
figure(14)
clf, 
PCA1b = PCA1a;
PCA1b([35:36], :) = -PCA1b([35:36], :);

PCA2b = PCA2a;
PCA2b([6, 9, 13, 15, 28, 31:36], :) = -PCA2b([6, 9, 13, 15, 28, 31:36], :);

PCA3b = PCA3a;
PCA3b([16], :) = -PCA3b([16], :);

PCA4b = PCA4a;
PCA4b([23:36], :) = -PCA4b([23:36], :);

PCA5b = PCA5a;
PCA5b([6:8, 14, 16:17, 19:20], :) = -PCA5b([6:8, 14, 16:17, 19:20], :);

PCA6b = PCA6a;
PCA6b([9, 12:14, 26:36], :) = -PCA6b([9, 12:14, 26:36], :);

subplot(3,2,1), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA1b(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 1 - Corrected')

subplot(3,2,2), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA2b(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 2 - Corrected')

subplot(3,2,3), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA3b(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 3 - Corrected')

subplot(3,2,4), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA4b(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 4 - Corrected')

subplot(3,2,5), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA5b(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 5 - Corrected')

subplot(3,2,6), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA6b(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PCA 6 - Corrected')


% PLot of PCA 1&2 for all 3 versions
figure(15)
clf, 
subplot(3,2,1), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA1(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PC_1')

subplot(3,2,2), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA2(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PC_2')

subplot(3,2,3), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA1a(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PC_1 - Hist. Equalisation')

subplot(3,2,4), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA2a(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PC_2 - Hist. Equalisation')

subplot(3,2,5), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA1b(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PC_1 - Hist. Eq. & Correction')

subplot(3,2,6), hold on,
for idx = 1:length(presetStore)
plot(1:36, PCA2b(:,idx))
end
xlim([0,36])
xlabel('Number of Presets')
ylabel('PC_2 - Hist. Eq. & Correction')


% Automatically switch PCAs test
switchPCAtest(PCA4a);


% Tests of the Latent value vs num of presets
latentArray = zeros(36,length(presetStore)-1);

for j = 1:36
    for idx = (j+1):length(presetStore)
        latentArray(j,idx-1) = latent{idx}(j);
    end
end

figure(20), clf
% subplot(3,1,1)
% plot(2:length(presetStore), latentArray)
% xlim([2,36])
% 
% subplot(3,1,2)
% area(2:length(presetStore), latentArray')
% xlim([2,36])
% 
% subplot(3,1,3)
cumsum11plus = cumsum(latentArray(11:end, :));
latentArray(11,:) = cumsum11plus(end, :);
latentArray(12:end,:) = [];

cumsumArray = cumsum(latentArray);


area(2:length(presetStore), (latentArray./cumsumArray(end,:))')
ylim([0,1])
xlim([2,36])
ylabel('\fontsize{16}Latent Fraction')
xlabel('\fontsize{16}Number of Presets')
legend({'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11+'},'FontSize', 14)


% 
% 
% % labels = cell(1,length(presetStore(:,1)));
% % for i = 1:length(score(:,1))
% % labels{i} = num2str(i);
% % end
% 
% 
% figure(10)
% clf
% hold on
% 
% for i = 1:length(score(:,1))       %length(score(:,1))
%     
%     % Use PCA colums 3,4,5 for RGB colours
%     R = mapRange(score(i,3), min(score(:,3)), max(score(:,3)), 0,1);
%     G = mapRange(score(i,4), min(score(:,4)), max(score(:,4)), 0,1);
%     B = mapRange(score(i,5), min(score(:,5)), max(score(:,5)), 0,1);
%     
%     markerPlot = plot(score(i,1), score(i,2), 'ro',...
%         'MarkerFaceColor', [R,G,B],...
%         'MarkerEdgeColor', [R,G,B],...
%         'MarkerSize', 10);
%    text(score(i,1) + 0.2, score(i,2) + 0.2, labels{i}); 
% end
% 
% i = 17;
% testPreset = testPreset - mu;
% testScore = testPreset*coeff;
% R = bound(mapRange(testScore(3), min(score(:,3)), max(score(:,3)), 0,1), 0, 1);
% G = bound(mapRange(testScore(4), min(score(:,4)), max(score(:,4)), 0,1), 0, 1);
% B = bound(mapRange(testScore(5), min(score(:,5)), max(score(:,5)), 0,1), 0, 1);
% 
%     
%     markerPlot = plot(testScore(1), testScore(2), 'ro',...
%         'MarkerFaceColor', [R,G,B],...
%         'MarkerEdgeColor', [R,G,B],...
%         'MarkerSize', 10);
%    text(testScore(1) + 0.2, testScore(2) + 0.2, '17 - Test'); 
function [xOut, n, edges] = histogramNormalisation(xIn, histBlend, numBins)



if nargin == 1
    histBlend = 1;
    numBins =6;
end

[n, edges] = histcounts(xIn, numBins);

xNorm = xIn;

nSumX = 0;

for i = 1:numBins
    xNorm(xIn >= edges(i) & xIn < edges(i+1)) = ...
    	mapRange(xIn(xIn >= edges(i) & xIn < edges(i+1)),...
        edges(i), edges(i+1), nSumX, nSumX + n(i));
    
    nSumX = nSumX + n(i);
end

%xOut = xNorm;
xOut = histBlend*xNorm + (1-histBlend)*xIn;

end