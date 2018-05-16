% a test to simulate a perfect user using a traditional interface, vs an
% imperfect user 

presetRead = matfile('PresetStoreSC.mat');
numPresets = 36;

figure(11)
clf
subplot(3,2,1)
title('Cost vs Iteration for Perfect User')
hold on
subplot(3,2,2)
title('Normalised Cost vs Iteration for Perfect User')
hold on
subplot(3,2,3)
title('Cost vs Iteration for Imperfect User')
hold on
subplot(3,2,4)
title('Normalised Cost vs Iteration for Imperfect User')
hold on

meanInitialCost = 0;

costHistoryPerfect = zeros(1,100);
meanCostHistoryPerfect = zeros(1,100);

costHistoryImperfect = zeros(1,100);
meanCostHistoryImperfect = zeros(1,100);

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
for i = 1:length(costHistoryPerfect)
    presetCurrentPerfect{iMax}(jMax) = presetGoal{iMax}(jMax);
    [cost, iMax, jMax] = costFunction(presetCurrentPerfect, presetGoal);
    costHistoryPerfect(i) = cost;
end

presetCurrentImperfect = presetStart;
for i = 1:length(costHistoryImperfect)
    presetCurrentImperfect{iMax}(jMax) =...
            presetCurrentImperfect{iMax}(jMax)...
            +(1+imperectStdDev*randn)*(presetGoal{iMax}(jMax) - presetCurrentImperfect{iMax}(jMax));
    [cost, iMax, jMax] = costFunction(presetCurrentImperfect, presetGoal);
    costHistoryImperfect(i) = cost;
end

meanCostHistoryPerfect = meanCostHistoryPerfect + costHistoryPerfect/numIterations;

meanCostHistoryImperfect = meanCostHistoryImperfect + costHistoryImperfect/numIterations;


subplot(3,2,1)
plot((0:1:100), [initialCost, costHistoryPerfect], 'b')
subplot(3,2,2)
plot((0:1:100), [initialCost, costHistoryPerfect]/initialCost, 'b')

subplot(3,2,3)
plot((0:1:100), [initialCost, costHistoryImperfect], 'b')
subplot(3,2,4)
plot((0:1:100), [initialCost, costHistoryImperfect]/initialCost, 'b')


end

subplot(3,2,1)
plot((0:1:100), [meanInitialCost, meanCostHistoryPerfect], 'r', 'LineWidth', 3)
subplot(3,2,2)
plot((0:1:100), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'r', 'LineWidth', 3)

subplot(3,2,3)
plot((0:1:100), [meanInitialCost, meanCostHistoryImperfect], 'g', 'LineWidth', 3)
subplot(3,2,4)
plot((0:1:100), [meanInitialCost, meanCostHistoryImperfect]/meanInitialCost, 'g', 'LineWidth', 3)

subplot(3,2,5)
title('Perfect User vs Imperfect User Normalised Cost')
hold on
plot((0:1:100), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'r', 'LineWidth', 3)
plot((0:1:100), [meanInitialCost, meanCostHistoryImperfect]/meanInitialCost, 'g', 'LineWidth', 3)
legend('Perfect', ['Imperfect \sigma = ', num2str(imperectStdDev)])

subplot(3,2,6)
title('Perfect User vs Imperfect User Log Normalised Cost')
hold on
plot((0:1:100), log([meanInitialCost, meanCostHistoryPerfect]/meanInitialCost), 'r', 'LineWidth', 3)
plot((0:1:100), log([meanInitialCost, meanCostHistoryImperfect]/meanInitialCost), 'g', 'LineWidth', 3)
legend('Perfect', ['Imperfect \sigma = ', num2str(imperectStdDev)])

