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
subplot(3,1,1)
title('\fontsize{16}Perfect User')
xlabel('\fontsize{16}Number of Iterations')
ylabel('\fontsize{16}Normalised Error')

hold on
subplot(3,1,2)
title('\fontsize{16}Imperfect User, \sigma = 0.3')
xlabel('\fontsize{16}Number of Iterations')
ylabel('\fontsize{16}Normalised Error')
hold on

subplot(3,1,3)
title('\fontsize{16}Imperfect User, \sigma = 1.0')
xlabel('\fontsize{16}Number of Iterations')
ylabel('\fontsize{16}Normalised Error')
hold on


meanInitialCost = 0;

plotLength = 100;
costHistoryPerfect = zeros(1,plotLength);
meanCostHistoryPerfect = zeros(1,plotLength);

costHistoryPerfect2 = zeros(1,plotLength);
meanCostHistoryPerfect2 = zeros(1,plotLength);

costHistoryImperfectA = zeros(1,plotLength);
meanCostHistoryImperfectA = zeros(1,plotLength);

costHistoryImperfectA2 = zeros(1,plotLength);
meanCostHistoryImperfectA2 = zeros(1,plotLength);

costHistoryImperfectB = zeros(1,plotLength);
meanCostHistoryImperfectB = zeros(1,plotLength);

costHistoryImperfectB2 = zeros(1,plotLength);
meanCostHistoryImperfectB2 = zeros(1,plotLength);

imperfectAStdDev = 0.3;
imperfectBStdDev = 1.0;

numIterations = numPresets;

for p = 1:numIterations

% Start and Goal generation
%num = randperm(numPresets, 1);
num = p;
presetGoal  = presetRead.presetStore(num,:);

presetStart  = presetRead.presetStore(sortedIndeces(num, 2),:);

[initialCost, iMaxInitial, jMaxInitial] = costFunction(presetStart, presetGoal);

meanInitialCost = meanInitialCost + initialCost/numIterations;


% Perfect ------------------
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

% Imperfect A --------------
presetCurrentImperfect = presetStart;
iMax = iMaxInitial;
jMax = jMaxInitial;
for idx = 1:length(costHistoryImperfectA)
    presetCurrentImperfect{iMax}(jMax) =...
            presetCurrentImperfect{iMax}(jMax)...
            +(1+imperfectAStdDev*randn)*(presetGoal{iMax}(jMax) - presetCurrentImperfect{iMax}(jMax));
    [cost, iMax, jMax] = costFunction(presetCurrentImperfect, presetGoal);
    costHistoryImperfectA(idx) = cost;
end

presetCurrentImperfect2 = presetStart;
for idx = 1:length(costHistoryImperfectA2)
    
    paramNum = randperm(totalPresetLength,1);
    [i,j] = paramToIJ(paramNum, presetLengthSum);
    
    presetCurrentImperfect2{i}(j) =...
            presetCurrentImperfect2{i}(j)...
            +(1+imperfectAStdDev*randn)*(presetGoal{i}(j) - presetCurrentImperfect2{i}(j));
        
    cost = costFunction(presetCurrentImperfect2, presetGoal);
    
    costHistoryImperfectA2(idx) = cost;
end

% Imperfect B --------------
presetCurrentImperfect = presetStart;
iMax = iMaxInitial;
jMax = jMaxInitial;
for idx = 1:length(costHistoryImperfectB)
    presetCurrentImperfect{iMax}(jMax) =...
            presetCurrentImperfect{iMax}(jMax)...
            +(1+imperfectBStdDev*randn)*(presetGoal{iMax}(jMax) - presetCurrentImperfect{iMax}(jMax));
    [cost, iMax, jMax] = costFunction(presetCurrentImperfect, presetGoal);
    costHistoryImperfectB(idx) = cost;
end

presetCurrentImperfect2 = presetStart;
for idx = 1:length(costHistoryImperfectB2)
    
    paramNum = randperm(totalPresetLength,1);
    [i,j] = paramToIJ(paramNum, presetLengthSum);
    
    presetCurrentImperfect2{i}(j) =...
            presetCurrentImperfect2{i}(j)...
            +(1+imperfectBStdDev*randn)*(presetGoal{i}(j) - presetCurrentImperfect2{i}(j));
        
    cost = costFunction(presetCurrentImperfect2, presetGoal);
    
    costHistoryImperfectB2(idx) = cost;
end


meanCostHistoryPerfect = meanCostHistoryPerfect + costHistoryPerfect/numIterations;
meanCostHistoryPerfect2 = meanCostHistoryPerfect2 + costHistoryPerfect2/numIterations;

meanCostHistoryImperfectA = meanCostHistoryImperfectA + costHistoryImperfectA/numIterations;
meanCostHistoryImperfectA2 = meanCostHistoryImperfectA2 + costHistoryImperfectA2/numIterations;

meanCostHistoryImperfectB = meanCostHistoryImperfectB + costHistoryImperfectB/numIterations;
meanCostHistoryImperfectB2 = meanCostHistoryImperfectB2 + costHistoryImperfectB2/numIterations;


subplot(3,1,1)
plot((0:1:plotLength), [initialCost, costHistoryPerfect]/initialCost, 'c')
subplot(3,1,1)
plot((0:1:plotLength), [initialCost, costHistoryPerfect2]/initialCost, 'b')

subplot(3,1,2)
plot((0:1:plotLength), [initialCost, costHistoryImperfectA]/initialCost, 'c')
subplot(3,1,2)
plot((0: 1:plotLength), [initialCost, costHistoryImperfectA2]/initialCost, 'b')

subplot(3,1,3)
plot((0:1:plotLength), [initialCost, costHistoryImperfectB]/initialCost, 'c')
subplot(3,1,3)
plot((0: 1:plotLength), [initialCost, costHistoryImperfectB2]/initialCost, 'b')

end

subplot(3,1,1)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'r', 'LineWidth', 3)
ylim([0,1])

subplot(3,1,1)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost, 'r:', 'LineWidth', 3)
ylim([0,1])

subplot(3,1,2)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectA]/meanInitialCost, 'r', 'LineWidth', 3)
ylim([0,1])

subplot(3,1,2)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectA2]/meanInitialCost, 'r:', 'LineWidth', 3)
ylim([0,1])

subplot(3,1,3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectB]/meanInitialCost, 'r', 'LineWidth', 3)
ylim([0,1])

subplot(3,1,3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectB2]/meanInitialCost, 'r:', 'LineWidth', 3)
ylim([0,1])

% 
% subplot(3,2,5)
% title('Perfect User vs Imperfect User Normalised Cost')
% hold on
% plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect]/meanInitialCost, 'r', 'LineWidth', 3)
% plot((0:1:plotLength), [meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost, 'r:', 'LineWidth', 3)
% plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectA]/meanInitialCost, 'g', 'LineWidth', 3)
% plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectA2]/meanInitialCost, 'g:', 'LineWidth', 3)
% legend('Perfect', 'Perfect-Rand', ['Imperfect \sigma = ', num2str(imperectStdDev)], 'Imperfect-Rand')
% 
% subplot(3,2,6)
% title('Perfect User vs Imperfect User Log Normalised Cost')
% hold on
% plot((0:1:plotLength), log([meanInitialCost, meanCostHistoryPerfect]/meanInitialCost), 'r', 'LineWidth', 3)
% plot((0:1:plotLength), log([meanInitialCost, meanCostHistoryPerfect2]/meanInitialCost), 'r:', 'LineWidth', 3)
% plot((0:1:plotLength), log([meanInitialCost, meanCostHistoryImperfectA]/meanInitialCost), 'g', 'LineWidth', 3)
% plot((0:1:plotLength), log([meanInitialCost, meanCostHistoryImperfectA2]/meanInitialCost), 'g:', 'LineWidth', 3)
% legend('Perfect', 'Perfect-Rand', ['Imperfect \sigma = ', num2str(imperectStdDev)], 'Imperfect-Rand')


