% a test to simulate a perfect User using PCA Interface

presetRead = matfile('PresetStoreSC.mat');
numPresets = length(presetRead.presetStore(:,1));

% 
% preset1 = presetRead.presetStore(1,:);
% presetLengths = zeros(1,12);
% for j = 1:length(preset1)
%     presetLengths(j) = length(preset1{j});
% end
% presetLengthSum = [0, cumsum(presetLengths)];
% totalPresetLength = presetLengthSum(end);

figure(14), clf, hold on,


            
%% Compute all costs between combinations of presets
costs = zeros(36);
% Costs are symmetric so exploit symmetry in computation
for j = 1:numPresets
    presetGoal  = presetRead.presetStore(j,:);
    for i = j+1:numPresets
            presetTest = presetRead.presetStore(i,:);
            costs(j,i) = costFunction(presetTest, presetGoal);
    end
end
costs = costs + costs';

[sortedCosts, sortedIndeces] = sort(costs,2);

%% Calculate PCA
presetStoreFlattened = cell2mat(presetRead.presetStore);
mu = mean(presetStoreFlattened);
presetStoreFlattened = presetStoreFlattened - mu;

% Perform PCA on global presets
[coeff, score, latent] = pca(presetStoreFlattened);
globalCoeffCell = createCoeffCell(coeff);

% Perform PCA on presets - timbre parameters
[timbreCoeff, timbreScore, timbreLatent] = pca(presetStoreFlattened(:,1:72));

% Perform PCA on presets - time parameters
[timeCoeff, timeScore, timeLatent] = pca(presetStoreFlattened(:,73:94));

coeffCombined = [timbreCoeff(:,1:4), zeros(size(timbreCoeff(:,1:4)));...
                 zeros(size(timeCoeff(:,1:4))), timeCoeff(:,1:4), ];
coeffCell = createCoeffCell(coeffCombined);

%% tests
numIterations = 100;
numTests = numPresets;
%numTests =2;

%Ordered Test Data
meanCostHistoryPerfectCO = zeros(1,numIterations+1);
costHistoryPerfectCO = cell(1,numTests);

meanCostHistoryPerfectCTTO = zeros(1,numIterations+1);
costHistoryPerfectCTTO = cell(1,numTests);

meanCostHistoryPerfectCGO = zeros(1,numIterations+1);
costHistoryPerfectCGO = cell(1,numTests);

%Random Test Data
meanCostHistoryPerfectCR = zeros(1,numIterations+1);
costHistoryPerfectCR = cell(1,numTests);

meanCostHistoryPerfectCTTR = zeros(1,numIterations+1);
costHistoryPerfectCTTR = cell(1,numTests);

meanCostHistoryPerfectCGR = zeros(1,numIterations+1);
costHistoryPerfectCGR = cell(1,numTests);

for p = 1:numTests

% Start and Goal generation
%num = randperm(numPresets, 1);
num = p;

presetGoal  = presetRead.presetStore(num,:);

presetAInitial  = presetRead.presetStore(sortedIndeces(num, 2),:);

x0 = 0;


% Perfect user------------------------
% Generate new presets Setup

costHistoryPerfectCO{p} = zeros(1,numIterations+1);
costHistoryPerfectCO{p}(1) = sortedCosts(num, 2);

costHistoryPerfectCTTO{p} = zeros(1,numIterations+1);
costHistoryPerfectCTTO{p}(1) = sortedCosts(num, 2);

costHistoryPerfectCGO{p} = zeros(1,numIterations+1);
costHistoryPerfectCGO{p}(1) = sortedCosts(num, 2);


costHistoryPerfectCR{p} = zeros(1,numIterations+1);
costHistoryPerfectCR{p}(1) = sortedCosts(num, 2);

costHistoryPerfectCTTR{p} = zeros(1,numIterations+1);
costHistoryPerfectCTTR{p}(1) = sortedCosts(num, 2);

costHistoryPerfectCGR{p} = zeros(1,numIterations+1);
costHistoryPerfectCGR{p}(1) = sortedCosts(num, 2);

% Iterate Presets - TT & Global
pcaWeightsTT = zeros(1,8);
pcaWeightsGlobal = zeros(1,8);

for i = 1:numIterations
    pcaNumberOrdered = mod(i,16);
    if pcaNumberOrdered == 0
        pcaNumberOrdered = 16;
    end
    
    
    f = @(x)pcaCost(x, presetAInitial, presetGoal, coeffCell, pcaWeightsTT,...
        globalCoeffCell, pcaWeightsGlobal, pcaNumberOrdered);
    [optimumParam,cost] = patternsearch(f,x0);
    
    if pcaNumberOrdered <9
        pcaWeightsTT(pcaNumberOrdered) = optimumParam;
    else
        pcaWeightsGlobal(pcaNumberOrdered - 8) = optimumParam;
    end
    
    costHistoryPerfectCO{p}(i+1) = cost;
end

pcaWeightsTT = zeros(1,8);
pcaWeightsGlobal = zeros(1,8);

for i = 1:numIterations
    pcaNumber = randperm(16, 1);
    
    f = @(x)pcaCost(x, presetAInitial, presetGoal, coeffCell, pcaWeightsTT,...
        globalCoeffCell, pcaWeightsGlobal, pcaNumber);
    [optimumParam,cost] = patternsearch(f,x0);
    
    if pcaNumber <9
        pcaWeightsTT(pcaNumber) = optimumParam;
    else
        pcaWeightsGlobal(pcaNumber - 8) = optimumParam;
    end
    
    costHistoryPerfectCR{p}(i+1) = cost;
end


% Iterate Presets - TT only
pcaWeightsTT = zeros(1,8);
pcaWeightsGlobal = zeros(1,8);

for i = 1:numIterations
    
    %pcaNumber = randperm(16, 1);
    pcaNumberOrdered = mod(i,8);
    if pcaNumberOrdered == 0
        pcaNumberOrdered = 8;
    end
    
    
    f = @(x)pcaCost(x, presetAInitial, presetGoal, coeffCell, pcaWeightsTT,...
        globalCoeffCell, pcaWeightsGlobal, pcaNumberOrdered);
    [optimumParam,cost] = patternsearch(f,x0);
    
    if pcaNumberOrdered <9
        pcaWeightsTT(pcaNumberOrdered) = optimumParam;
    else
        pcaWeightsGlobal(pcaNumberOrdered - 8) = optimumParam;
    end
    
    costHistoryPerfectCTTO{p}(i+1) = cost;
    
end

pcaWeightsTT = zeros(1,8);
pcaWeightsGlobal = zeros(1,8);

for i = 1:numIterations
    
    pcaNumber = randperm(8, 1);
    
    f = @(x)pcaCost(x, presetAInitial, presetGoal, coeffCell, pcaWeightsTT,...
        globalCoeffCell, pcaWeightsGlobal, pcaNumber);
    [optimumParam,cost] = patternsearch(f,x0);
    
    if pcaNumber <9
        pcaWeightsTT(pcaNumber) = optimumParam;
    else
        pcaWeightsGlobal(pcaNumber - 8) = optimumParam;
    end
    
    costHistoryPerfectCTTR{p}(i+1) = cost;
    
end

% Iterate Presets - Global only
pcaWeightsTT = zeros(1,8);
pcaWeightsGlobal = zeros(1,8);

for i = 1:numIterations
    
    %pcaNumber = randperm(16, 1);
    pcaNumberOrdered = mod(i,8) + 8;
    if pcaNumberOrdered == 8
        pcaNumberOrdered = 16;
    end
    
    
    f = @(x)pcaCost(x, presetAInitial, presetGoal, coeffCell, pcaWeightsTT,...
        globalCoeffCell, pcaWeightsGlobal, pcaNumberOrdered);
    [optimumParam,cost] = patternsearch(f,x0);
    
    if pcaNumberOrdered <9
        pcaWeightsTT(pcaNumberOrdered) = optimumParam;
    else
        pcaWeightsGlobal(pcaNumberOrdered - 8) = optimumParam;
    end
    
    costHistoryPerfectCGO{p}(i+1) = cost;
   
end

pcaWeightsTT = zeros(1,8);
pcaWeightsGlobal = zeros(1,8);

for i = 1:numIterations
    
    pcaNumber = randperm(16, 1);
    if pcaNumber == 8
        pcaNumber = 16;
    end
    
    
    f = @(x)pcaCost(x, presetAInitial, presetGoal, coeffCell, pcaWeightsTT,...
        globalCoeffCell, pcaWeightsGlobal, pcaNumber);
    [optimumParam,cost] = patternsearch(f,x0);
    
    if pcaNumber <9
        pcaWeightsTT(pcaNumber) = optimumParam;
    else
        pcaWeightsGlobal(pcaNumber - 8) = optimumParam;
    end
    
    costHistoryPerfectCGR{p}(i+1) = cost;
   
end



meanCostHistoryPerfectCO = meanCostHistoryPerfectCO + costHistoryPerfectCO{p}/numTests;
meanCostHistoryPerfectCTTO = meanCostHistoryPerfectCTTO + costHistoryPerfectCTTO{p}/numTests;
meanCostHistoryPerfectCGO = meanCostHistoryPerfectCGO + costHistoryPerfectCGO{p}/numTests;

meanCostHistoryPerfectCR = meanCostHistoryPerfectCR + costHistoryPerfectCR{p}/numTests;
meanCostHistoryPerfectCTTR = meanCostHistoryPerfectCTTR + costHistoryPerfectCTTR{p}/numTests;
meanCostHistoryPerfectCGR = meanCostHistoryPerfectCGR + costHistoryPerfectCGR{p}/numTests;
end

%% Plots
figure(14), clf
for p = 1:numTests
subplot(4,2,1)
plot(0:1:numIterations,costHistoryPerfectCO{p}/costHistoryPerfectCO{p}(1))
hold on

subplot(4,2,2)
plot(0:1:numIterations,costHistoryPerfectCR{p}/costHistoryPerfectCR{p}(1))
hold on

subplot(4,2,3)
plot(0:1:numIterations,costHistoryPerfectCTTO{p}/costHistoryPerfectCTTO{p}(1))
hold on

subplot(4,2,4)
plot(0:1:numIterations,costHistoryPerfectCTTR{p}/costHistoryPerfectCTTR{p}(1))
hold on

subplot(4,2,5)
plot(0:1:numIterations,costHistoryPerfectCGO{p}/costHistoryPerfectCGO{p}(1))
hold on

subplot(4,2,6)
plot(0:1:numIterations,costHistoryPerfectCGR{p}/costHistoryPerfectCGR{p}(1))
hold on
end


subplot(4,2,1)
plot(0:1:numIterations,meanCostHistoryPerfectCO/meanCostHistoryPerfectCO(1), 'r', 'LineWidth', 3)
ylim([0,1]);

subplot(4,2,2)
plot(0:1:numIterations,meanCostHistoryPerfectCR/meanCostHistoryPerfectCR(1), 'r', 'LineWidth', 3)
ylim([0,1]);


subplot(4,2,3)
plot(0:1:numIterations,meanCostHistoryPerfectCTTO/meanCostHistoryPerfectCTTO(1), 'r', 'LineWidth', 3)
ylim([0,1]);

subplot(4,2,4)
plot(0:1:numIterations,meanCostHistoryPerfectCTTR/meanCostHistoryPerfectCTTR(1), 'r', 'LineWidth', 3)
ylim([0,1]);


subplot(4,2,5)
plot(0:1:numIterations,meanCostHistoryPerfectCGO/meanCostHistoryPerfectCGO(1), 'r', 'LineWidth', 3)
ylim([0,1]);

subplot(4,2,6)
plot(0:1:numIterations,meanCostHistoryPerfectCGR/meanCostHistoryPerfectCGR(1), 'r', 'LineWidth', 3)
ylim([0,1]);

subplot(4,2,[7,8])
plot(0:1:numIterations,meanCostHistoryPerfectCO/meanCostHistoryPerfectCO(1), 'r', 'LineWidth', 3)
hold on
plot(0:1:numIterations,meanCostHistoryPerfectCR/meanCostHistoryPerfectCO(1), 'r:', 'LineWidth', 3)

plot(0:1:numIterations,meanCostHistoryPerfectCTTO/meanCostHistoryPerfectCTTO(1), 'g', 'LineWidth', 3)
plot(0:1:numIterations,meanCostHistoryPerfectCTTR/meanCostHistoryPerfectCTTR(1), 'g:', 'LineWidth', 3)

plot(0:1:numIterations,meanCostHistoryPerfectCGO/meanCostHistoryPerfectCGO(1), 'b', 'LineWidth', 3)
plot(0:1:numIterations,meanCostHistoryPerfectCGR/meanCostHistoryPerfectCGR(1), 'b:', 'LineWidth', 3)

legend('Time/Timbre + Global PCA','... Random','Time/Timbre PCA','... Random', 'Global PCA','... Random');


subplot(4,2,1)
title('Time/Timbre + Global PCA - Ordered')
xlabel('Iterations')
ylabel('Normalised Cost')
subplot(4,2,2)
title('Time/Timbre + Global PCA - Random')
xlabel('Iterations')
ylabel('Normalised Cost')
subplot(4,2,3)
title('Time/Timbre - Ordered')
xlabel('Iterations')
ylabel('Normalised Cost')
subplot(4,2,4)
title('Time/Timbre - Random')
xlabel('Iterations')
ylabel('Normalised Cost')
subplot(4,2,5)
title('Global PCA - Ordered')
xlabel('Iterations')
ylabel('Normalised Cost')
subplot(4,2,6)
title('Global PCA - Random')
xlabel('Iterations')
ylabel('Normalised Cost')

subplot(4,2,[7,8])
title('Mean Normalised Cost vs Iterations comparison')
xlabel('Iterations')
ylabel('Normalised Cost')

%% Plots for report
figure(16)
numIterations = 100;

for p = 1:numTests
subplot(1,2,1)
plot(0:1:numIterations,costHistoryPerfectCO{p}/costHistoryPerfectCO{p}(1))
hold on

subplot(1,2,2)
plot(0:1:numIterations,costHistoryPerfectCR{p}/costHistoryPerfectCR{p}(1))
hold on
end


subplot(1,2,1)
plot(0:1:numIterations,meanCostHistoryPerfectCO/meanCostHistoryPerfectCO(1), 'r', 'LineWidth', 3)
ylim([0.2,1]);
title('\fontsize{16}Time/Timbre + Global PCA - Ordered')
xlabel('\fontsize{16}Iterations')
ylabel('\fontsize{16}Normalised Cost')

subplot(1,2,2)
plot(0:1:numIterations,meanCostHistoryPerfectCR/meanCostHistoryPerfectCR(1), 'r', 'LineWidth', 3)
ylim([0.2,1]);
title('\fontsize{16}Time/Timbre + Global PCA - Random')
xlabel('\fontsize{16}Iterations')
ylabel('\fontsize{16}Normalised Cost')


%% Requires evaluationTest3 and evaluationTest4 to have been run 
figure(15)
clf
numIterations = 100;

% Traditional Interface
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'k', 'LineWidth', 3)
hold on
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost, 'k:', 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect]/meanInitialCost, 'Color', [0.3, 0.3, 0.3], 'LineWidth', 2.5)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2]/meanInitialCost, ':','Color', [0.3, 0.3, 0.3], 'LineWidth', 2.5)

plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectC{5}]/meanInitialCost,'Color', [0.6, 0.6, 0.6], 'LineWidth', 2.5)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2C{5}]/meanInitialCost, ':','Color', [0.6, 0.6, 0.6], 'LineWidth', 2.5)

% PCA Interface
plot(0:1:numIterations,meanCostHistoryPerfectCO/meanCostHistoryPerfectCO(1), 'r', 'LineWidth', 3)
plot(0:1:numIterations,meanCostHistoryPerfectCR/meanCostHistoryPerfectCO(1), 'r:', 'LineWidth', 3)

plot(0:1:numIterations,meanCostHistoryPerfectCTTO/meanCostHistoryPerfectCTTO(1), 'g', 'LineWidth', 3)
plot(0:1:numIterations,meanCostHistoryPerfectCTTR/meanCostHistoryPerfectCTTR(1), 'g:', 'LineWidth', 3)

plot(0:1:numIterations,meanCostHistoryPerfectCGO/meanCostHistoryPerfectCGO(1), 'b', 'LineWidth', 3)
plot(0:1:numIterations,meanCostHistoryPerfectCGR/meanCostHistoryPerfectCGR(1), 'b:', 'LineWidth', 3)

% Blending Interface
plot(0:1:100,meanCostHistoryPerfectB/meanCostHistoryPerfectB(1), 'c', 'LineWidth', 3)
plot(0:1:100,meanCostHistoryImperfectB/meanCostHistoryImperfectB(1), 'c:', 'LineWidth', 2.5)
plot(0:1:100,meanCostHistoryImperfectB1/meanCostHistoryImperfectB1(1), 'c--', 'LineWidth', 2.5)



title('\fontsize{16}Traditional vs Selection vs Blending Interfaces')
xlabel('\fontsize{16}Iterations')
ylabel('\fontsize{16}Normalised Cost')

legend({'Perfect Traditional', '... Random', 'Imperfect Traditional - \sigma = 0.3', '... Random', 'Imperfect Traditional - \sigma = 0.8', '... Random',...
 'Time/Timbre + Global PCA','... Random','Time/Timbre PCA','... Random', 'Global PCA','... Random',...
'Perfect Blending', 'Imperfect Blending - \sigma = 0.3','Imperfect Blending - \sigma = 0.8',...
}, 'FontSize', 14, 'Location','SouthWest')