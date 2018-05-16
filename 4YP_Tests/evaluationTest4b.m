% a test to simulate a perfect User using Blending Interface

presetRead = matfile('PresetStoreSC.mat');
numPresets = length(presetRead.presetStore(:,1));

preset1 = presetRead.presetStore(1,:);
presetLengths = zeros(1,12);
for j = 1:length(preset1)
    presetLengths(j) = length(preset1{j});
end
presetLengthSum = [0, cumsum(presetLengths)];
totalPresetLength = presetLengthSum(end);

figure(13), clf, hold on,

% Generation Parameters
initialTempOffset = 0.01;
tempOffset = initialTempOffset;
tempScaling = 0.4;
lastValueWeighting = 0.5;
stdExponent = 1.5;
sigmoidCenterRatio = 0.5;
            
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

%% tests
numIterations = 100;
numTests = numPresets;
%numTests =2;
meanCostHistoryPerfectB = zeros(1,numIterations+1);
costHistoryPerfectB = cell(1,numTests);

meanCostHistoryImperfectB = zeros(1,numIterations+1);
costHistoryImperfectB = cell(1,numTests);

meanCostHistoryImperfectB1 = zeros(1,numIterations+1);
costHistoryImperfectB1 = cell(1,numTests);

for p = 1:numTests

% Start and Goal generation
%num = randperm(numPresets, 1);
num = p;

presetGoal  = presetRead.presetStore(num,:);

presetAInitial  = presetRead.presetStore(sortedIndeces(num, 2),:);
presetBInitial  = presetRead.presetStore(sortedIndeces(num, 3),:);
presetCInitial  = presetRead.presetStore(sortedIndeces(num, 4),:);


x0 = 0; y0 = 0;

% Perfect user------------------------
% Generate new presets Setup
presetA = presetAInitial;
presetB = presetBInitial;
presetC = presetCInitial;

presetAHistory = presetA;
tempOffset = initialTempOffset;

costHistoryPerfectB{p} = zeros(1,numIterations+1);
costHistoryPerfectB{p}(1) = sortedCosts(num, 2);

for i = 1:numIterations
    f = @(xy)blendingCost(xy, presetA, presetB, presetC, presetGoal);
    [optimumParams,cost] = patternsearch(f,[x0,y0]);
    costHistoryPerfectB{p}(i+1) = cost;
    
    presetA = blendXY(optimumParams,presetA, presetB, presetC);
    % Iterate Presets
    for j = 1:length(presetA)
        
        if j == 1
            weights = sigmoidWeights(length(presetAHistory{1}(:,1)), sigmoidCenterRatio);
        end
        
        historyArray = presetAHistory{j};
        
        newPresetsMean = (lastValueWeighting*presetA{j} + (1-lastValueWeighting)*weights*historyArray);
        
        % Covariance matrix
        sigma = diag(zeros(1,length(historyArray(1,:)))+std(historyArray).^stdExponent + tempOffset);
        
        sigma = tempScaling * sigma;         %.*randn(1,length(obj.presetA));
        % Multivarite Normal distrubution samples
        presetB{j} = mvnrnd(newPresetsMean,sigma);
        presetC{j} = mvnrnd(newPresetsMean,sigma);
        
        presetAHistory{j} = [presetAHistory{j}; presetA{j}];
    end
    % Decay tempOffset
    tempOffset = tempOffset*0.9;
end


% Imperfect User -------------------
% Generate new presets Setup
imperfectStdDev = 0.5;

presetA = presetAInitial;
presetB = presetBInitial;
presetC = presetCInitial;

presetAHistory = presetA;
tempOffset = initialTempOffset;

costHistoryImperfectB{p} = zeros(1,numIterations+1);
costHistoryImperfectB{p}(1) = sortedCosts(num, 2);


for i = 1:numIterations
    f = @(xy)blendingCost(xy, presetA, presetB, presetC, presetGoal);
    [optimumParams,cost] = patternsearch(f,[x0,y0]);
    %costHistoryImperfectB{p}(i+1) = cost;
    
    imperfectParams = optimumParams.*(ones(1,2) + imperfectStdDev*randn(1,2));
    
    presetA = blendXY(imperfectParams,presetA, presetB, presetC);
    cost = costFunction(presetA, presetGoal);
    costHistoryImperfectB{p}(i+1) = cost;
    
    
    % Iterate Presets
    for j = 1:length(presetA)
        
        if j == 1
            weights = sigmoidWeights(length(presetAHistory{1}(:,1)), sigmoidCenterRatio);
        end
        
        historyArray = presetAHistory{j};
        
        newPresetsMean = (lastValueWeighting*presetA{j} + (1-lastValueWeighting)*weights*historyArray);
        
        % Covariance matrix
        sigma = diag(zeros(1,length(historyArray(1,:)))+std(historyArray).^stdExponent + tempOffset);
        
        sigma = tempScaling * sigma;         %.*randn(1,length(obj.presetA));
        % Multivarite Normal distrubution samples
        presetB{j} = mvnrnd(newPresetsMean,sigma);
        presetC{j} = mvnrnd(newPresetsMean,sigma);
        
        presetAHistory{j} = [presetAHistory{j}; presetA{j}];
    end
    % Decay tempOffset
    tempOffset = tempOffset*0.9;
end

% Imperfect User 2 -------------------
% Generate new presets Setup
imperfectStdDev = 0.8;

presetA = presetAInitial;
presetB = presetBInitial;
presetC = presetCInitial;

presetAHistory = presetA;
tempOffset = initialTempOffset;

costHistoryImperfectB1{p} = zeros(1,numIterations+1);
costHistoryImperfectB1{p}(1) = sortedCosts(num, 2);


for i = 1:numIterations
    f = @(xy)blendingCost(xy, presetA, presetB, presetC, presetGoal);
    [optimumParams,cost] = patternsearch(f,[x0,y0]);
    %costHistoryImperfectB1{p}(i+1) = cost;
    
    imperfectParams = optimumParams.*(ones(1,2) + imperfectStdDev*randn(1,2));
    
    presetA = blendXY(imperfectParams,presetA, presetB, presetC);
    cost = costFunction(presetA, presetGoal);
    costHistoryImperfectB1{p}(i+1) = cost;
    
    % Iterate Presets
    for j = 1:length(presetA)
        
        if j == 1
            weights = sigmoidWeights(length(presetAHistory{1}(:,1)), sigmoidCenterRatio);
        end
        
        historyArray = presetAHistory{j};
        
        newPresetsMean = (lastValueWeighting*presetA{j} + (1-lastValueWeighting)*weights*historyArray);
        
        % Covariance matrix
        sigma = diag(zeros(1,length(historyArray(1,:)))+std(historyArray).^stdExponent + tempOffset);
        
        sigma = tempScaling * sigma;         %.*randn(1,length(obj.presetA));
        % Multivarite Normal distrubution samples
        presetB{j} = mvnrnd(newPresetsMean,sigma);
        presetC{j} = mvnrnd(newPresetsMean,sigma);
        
        presetAHistory{j} = [presetAHistory{j}; presetA{j}];
    end
    % Decay tempOffset
    tempOffset = tempOffset*0.9;
end






meanCostHistoryPerfectB = meanCostHistoryPerfectB + costHistoryPerfectB{p}/numTests;

meanCostHistoryImperfectB = meanCostHistoryImperfectB + costHistoryImperfectB{p}/numTests;

meanCostHistoryImperfectB1 = meanCostHistoryImperfectB1 + costHistoryImperfectB1{p}/numTests;



end

%% Plots
figure(18), clf
for p = 1:numTests
subplot(1,3,1)
plot(0:1:100,costHistoryPerfectB{p}/costHistoryPerfectB{p}(1))
hold on  
    
subplot(1,3,2)
plot(0:1:100,costHistoryImperfectB{p}/costHistoryPerfectB{p}(1))
hold on

subplot(1,3,3)
plot(0:1:100,costHistoryImperfectB1{p}/costHistoryPerfectB{p}(1))
hold on


% subplot(3,2,3)
% plot(0:1:100,costHistoryPerfectB{p}/costHistoryPerfectB{p}(1))
% hold on
% 
% subplot(3,2,4)
% plot(0:1:100,costHistoryImperfectB{p}/costHistoryImperfectB{p}(1))
% hold on


% subplot(3,2,[5,6])
% plot(0:1:100,costHistoryPerfectB{p}/costHistoryPerfectB{p}(1))
% hold on
    
end


% subplot(3,2,1)
% plot(0:1:100,meanCostHistoryPerfectB, 'r', 'LineWidth', 3)
% yLim = get(gca, 'YLim');
% ylim([0,yLim(2)]);

% subplot(3,2,2)
% plot(0:1:100,meanCostHistoryImperfectB, 'r', 'LineWidth', 3)
% yLim = get(gca, 'YLim');
% ylim([0,yLim(2)]);
subplot(1,3,1)
plot(0:1:100,meanCostHistoryPerfectB/meanCostHistoryPerfectB(1), 'r', 'LineWidth', 3)
ylim([0.2,1]);

subplot(1,3,2)
plot(0:1:100,meanCostHistoryImperfectB/meanCostHistoryImperfectB(1), 'r', 'LineWidth', 3)
ylim([0.2,1]);

subplot(1,3,3)
plot(0:1:100,meanCostHistoryImperfectB1/meanCostHistoryImperfectB1(1), 'r', 'LineWidth', 3)
ylim([0.2,1]);

% subplot(3,2,[5,6])
% plot(0:1:100,meanCostHistoryPerfectB/meanCostHistoryPerfectB(1), 'r', 'LineWidth', 3)
% hold on
% plot(0:1:100,meanCostHistoryImperfectB/meanCostHistoryImperfectB(1), 'r:', 'LineWidth', 3)
% ylim([0,1])


subplot(1,3,1)
title('\fontsize{16}Perfect User')
ylabel('\fontsize{16}Normalised Error')
xlabel('\fontsize{16}Interations')

subplot(1,3,2)
title('\fontsize{16}Imperfect User - \sigma = 0.5')
ylabel('\fontsize{16}Normalised Error')
xlabel('\fontsize{16}Interations')

subplot(1,3,3)
title('\fontsize{16}Imperfect User - \sigma = 0.8')
ylabel('\fontsize{16}Normalised Error')
xlabel('\fontsize{16}Interations')

%% Requires evaluationTest3 to have been run and the variables in scope
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect]/meanInitialCost, 'b', 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2]/meanInitialCost, 'b:', 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'g', 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost, 'g:', 'LineWidth', 3)

legend('Blending Interface - Perfect',...
        'Blending Interface - Imerfect',...
        'Trad Interface Imperfect',...
        'Trad Interface Imperfect - Random Order',...
        'Trad Interface Perfect',...
        'Trad Interface Perfect - Random Order')
