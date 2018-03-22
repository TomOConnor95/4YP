% a test to simulate a perfect user using a traditional interface, vs an
% imperfect user with random goal, and starting point as closest preset to
% goal

presetRead = matfile('PresetStoreSC.mat');
numPresets = length(presetRead.presetStore(:,1));

preset1 = presetRead.presetStore(1,:);
presetLengths = zeros(1,12);
for i = 1:length(preset1)
    presetLengths(i) = length(preset1{i});
end
presetLengthSum = [0, cumsum(presetLengths)];
totalPresetLength = presetLengthSum(end);

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

%% Run Tests
figure(12)
clf
subplot(3,2,1)
title('Normalised Cost vs Iteration for Perfect User')
hold on
subplot(3,2,2)
title('Normalised Cost vs Iteration for Perfect User, with random order')
hold on
subplot(3,2,3)
title('Normalised Cost vs Iteration for Imperfect User')
hold on
subplot(3,2,4)
title('Normalised Cost vs Iteration for Imperfect User, with random order')
hold on

meanInitialCost = 0;

plotLength = 100;
costHistoryPerfect = zeros(1,plotLength);
meanCostHistoryPerfect = zeros(1,plotLength);

costHistoryPerfect2 = zeros(1,plotLength);
meanCostHistoryPerfect2 = zeros(1,plotLength);

costHistoryImperfect = zeros(1,plotLength);
meanCostHistoryImperfect = zeros(1,plotLength);

costHistoryImperfect2 = zeros(1,plotLength);
meanCostHistoryImperfect2 = zeros(1,plotLength);


imperectStdDev = 0.3;

numIterations = numPresets;

for p = 1:numIterations

% Start and Goal generation
%num = randperm(numPresets, 1);
num = p;
presetGoal  = presetRead.presetStore(num,:);

presetStart  = presetRead.presetStore(sortedIndeces(num, 2),:);

[initialCost, iMaxInitial, jMaxInitial] = costFunction(presetStart, presetGoal);

meanInitialCost = meanInitialCost + initialCost/numIterations;



presetCurrentPerfect = presetStart;
iMax = iMaxInitial;
jMax = jMaxInitial;
for idx = 1:length(costHistoryPerfect)
    
    presetCurrentPerfect{iMax}(jMax) = presetGoal{iMax}(jMax);
    [cost, iMax, jMax] = costFunction(presetCurrentPerfect, presetGoal);
    
    costHistoryPerfect(idx) = cost;
end

presetCurrentPerfect2 = presetStart;
for idx = 1:length(costHistoryPerfect2)
    
    paramNum = randperm(totalPresetLength,1);
    [i,j] = paramToIJ(paramNum, presetLengthSum);
    
    presetCurrentPerfect2{i}(j) = presetGoal{i}(j);
    
    cost = costFunction(presetCurrentPerfect2, presetGoal);
    
    costHistoryPerfect2(idx) = cost;
end

presetCurrentImperfect = presetStart;
iMax = iMaxInitial;
jMax = jMaxInitial;
for idx = 1:length(costHistoryImperfect)
    presetCurrentImperfect{iMax}(jMax) =...
            presetCurrentImperfect{iMax}(jMax)...
            +(1+imperectStdDev*randn)*(presetGoal{iMax}(jMax) - presetCurrentImperfect{iMax}(jMax));
    [cost, iMax, jMax] = costFunction(presetCurrentImperfect, presetGoal);
    costHistoryImperfect(idx) = cost;
end

presetCurrentImperfect2 = presetStart;
for idx = 1:length(costHistoryImperfect2)
    
    paramNum = randperm(totalPresetLength,1);
    [i,j] = paramToIJ(paramNum, presetLengthSum);
    
    presetCurrentImperfect2{i}(j) =...
            presetCurrentImperfect2{i}(j)...
            +(1+imperectStdDev*randn)*(presetGoal{i}(j) - presetCurrentImperfect2{i}(j));
        
    cost = costFunction(presetCurrentImperfect2, presetGoal);
    
    costHistoryImperfect2(idx) = cost;
end


meanCostHistoryPerfect = meanCostHistoryPerfect + costHistoryPerfect/numIterations;
meanCostHistoryPerfect2 = meanCostHistoryPerfect2 + costHistoryPerfect2/numIterations;

meanCostHistoryImperfect = meanCostHistoryImperfect + costHistoryImperfect/numIterations;
meanCostHistoryImperfect2 = meanCostHistoryImperfect2 + costHistoryImperfect2/numIterations;


subplot(3,2,1)
plot((0:1:plotLength), [initialCost, costHistoryPerfect]/initialCost, 'b')
subplot(3,2,2)
plot((0:1:plotLength), [initialCost, costHistoryPerfect2]/initialCost, 'b')

subplot(3,2,3)
plot((0:1:plotLength), [initialCost, costHistoryImperfect]/initialCost, 'b')
subplot(3,2,4)
plot((0: 1:plotLength), [initialCost, costHistoryImperfect2]/initialCost, 'b')


end

subplot(3,2,1)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'r', 'LineWidth', 3)
ylim([0,1])

subplot(3,2,2)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost, 'r', 'LineWidth', 3)
ylim([0,1])

subplot(3,2,3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect]/meanInitialCost, 'g', 'LineWidth', 3)
ylim([0,1])

subplot(3,2,4)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2]/meanInitialCost, 'g', 'LineWidth', 3)
ylim([0,1])


subplot(3,2,5)
title('Perfect User vs Imperfect User Normalised Cost')
hold on
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'r', 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost, 'r:', 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect]/meanInitialCost, 'g', 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2]/meanInitialCost, 'g:', 'LineWidth', 3)
legend('Perfect', 'Perfect-Rand', ['Imperfect \sigma = ', num2str(imperectStdDev)], 'Imperfect-Rand')

subplot(3,2,6)
title('Perfect User vs Imperfect User Log Normalised Cost')
hold on
plot((0:1:plotLength), log([meanInitialCost, meanCostHistoryPerfect]/meanInitialCost), 'r', 'LineWidth', 3)
plot((0:1:plotLength), log([meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost), 'r:', 'LineWidth', 3)
plot((0:1:plotLength), log([meanInitialCost, meanCostHistoryImperfect]/meanInitialCost), 'g', 'LineWidth', 3)
plot((0:1:plotLength), log([meanInitialCost, meanCostHistoryImperfect2]/meanInitialCost), 'g:', 'LineWidth', 3)
legend('Perfect', 'Perfect-Rand', ['Imperfect \sigma = ', num2str(imperectStdDev)], 'Imperfect-Rand')


