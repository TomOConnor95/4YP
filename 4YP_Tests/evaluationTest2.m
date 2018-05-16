% a test to simulate a perfect user using a traditional interface, vs an
% imperfect user with random start and end point
%% Setup
presetRead = matfile('PresetStoreSC.mat');
numPresets = 36;


preset1 = presetRead.presetStore(1,:);
presetLengths = zeros(1,12);
for i = 1:length(preset1)
    presetLengths(i) = length(preset1{i});
end
presetLengthSum = [0, cumsum(presetLengths)];
totalPresetLength = presetLengthSum(end);

%% tests
figure(11)
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

costHistoryPerfect = zeros(1,100);
meanCostHistoryPerfect = zeros(1,100);

costHistoryPerfect2 = zeros(1,100);
meanCostHistoryPerfect2 = zeros(1,100);

costHistoryImperfect = zeros(1,100);
meanCostHistoryImperfect = zeros(1,100);

costHistoryImperfect2 = zeros(1,100);
meanCostHistoryImperfect2 = zeros(1,100);


imperectStdDev = 0.3;

numIterations = 25;
for p = 1:numIterations
numAB= randperm(36,2);
numA = numAB(1);
numB = numAB(2);

presetStart = presetRead.presetStore(numA,:);
presetGoal  = presetRead.presetStore(numB,:);


[initialCost, iMax, jMax] = costFunction(presetStart, presetGoal);

meanInitialCost = meanInitialCost + initialCost/numIterations;

presetCurrentPerfect = presetStart;
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
plot((0:1:100), [initialCost, costHistoryPerfect]/initialCost, 'b')
subplot(3,2,2)
plot((0:1:100), [initialCost, costHistoryPerfect2]/initialCost, 'b')

subplot(3,2,3)
plot((0:1:100), [initialCost, costHistoryImperfect]/initialCost, 'b')
subplot(3,2,4)
plot((0: 1:100), [initialCost, costHistoryImperfect2]/initialCost, 'b')


end

subplot(3,2,1)
plot((0:1:100), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'r', 'LineWidth', 3)
subplot(3,2,2)
plot((0:1:100), [meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost, 'r', 'LineWidth', 3)

subplot(3,2,3)
plot((0:1:100), [meanInitialCost, meanCostHistoryImperfect]/meanInitialCost, 'g', 'LineWidth', 3)
subplot(3,2,4)
plot((0:1:100), [meanInitialCost, meanCostHistoryImperfect2]/meanInitialCost, 'g', 'LineWidth', 3)


subplot(3,2,5)
title('Perfect User vs Imperfect User Normalised Cost')
hold on
plot((0:1:100), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'r', 'LineWidth', 3)
plot((0:1:100), [meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost, 'r:', 'LineWidth', 3)
plot((0:1:100), [meanInitialCost, meanCostHistoryImperfect]/meanInitialCost, 'g', 'LineWidth', 3)
plot((0:1:100), [meanInitialCost, meanCostHistoryImperfect2]/meanInitialCost, 'g:', 'LineWidth', 3)
legend('Perfect', 'Perfect-Rand', ['Imperfect \sigma = ', num2str(imperectStdDev)], 'Imperfect-Rand')

subplot(3,2,6)
title('Perfect User vs Imperfect User Log Normalised Cost')
hold on
plot((0:1:100), log([meanInitialCost, meanCostHistoryPerfect]/meanInitialCost), 'r', 'LineWidth', 3)
plot((0:1:100), log([meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost), 'r:', 'LineWidth', 3)
plot((0:1:100), log([meanInitialCost, meanCostHistoryImperfect]/meanInitialCost), 'g', 'LineWidth', 3)
plot((0:1:100), log([meanInitialCost, meanCostHistoryImperfect2]/meanInitialCost), 'g:', 'LineWidth', 3)
legend('Perfect', 'Perfect-Rand', ['Imperfect \sigma = ', num2str(imperectStdDev)], 'Imperfect-Rand')

