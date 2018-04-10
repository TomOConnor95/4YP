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

% subplot(3,1,1)
% title('\fontsize{16}Perfect User')
% xlabel('\fontsize{16}Number of Iterations')
% ylabel('\fontsize{16}Normalised Error')
% 
% hold on
% subplot(3,1,2)
% title('\fontsize{16}Imperfect User, \sigma = 0.3')
% xlabel('\fontsize{16}Number of Iterations')
% ylabel('\fontsize{16}Normalised Error')
% hold on
% 
% subplot(3,1,3)
% title('\fontsize{16}Imperfect User, \sigma = 1.0')
% xlabel('\fontsize{16}Number of Iterations')
% ylabel('\fontsize{16}Normalised Error')
% hold on




plotLength = 100;

costHistoryImperfectC = zeros(1,plotLength);
meanCostHistoryImperfectC = repmat({zeros(1,plotLength)},1,6);

costHistoryImperfect2C = zeros(1,plotLength);
meanCostHistoryImperfect2C = repmat({zeros(1,plotLength)},1,6);

numIterationsB = numPresets;


for index = 1:6
meanInitialCost = 0;
imperfectStdDev = (index-1)/5;

for p = 1:numIterationsB

% Start and Goal generation
%num = randperm(numPresets, 1);
num = p;
presetGoal  = presetRead.presetStore(num,:);

presetStart  = presetRead.presetStore(sortedIndeces(num, 2),:);

[initialCost, iMaxInitial, jMaxInitial] = costFunction(presetStart, presetGoal);

meanInitialCost = meanInitialCost + initialCost/numIterationsB;


% Imperfect  --------------
presetCurrentImperfect = presetStart;
iMax = iMaxInitial;
jMax = jMaxInitial;
for idx = 1:length(costHistoryImperfectC)
    presetCurrentImperfect{iMax}(jMax) =...
            presetCurrentImperfect{iMax}(jMax)...
            +(1+imperfectStdDev*randn)*(presetGoal{iMax}(jMax) - presetCurrentImperfect{iMax}(jMax));
    [cost, iMax, jMax] = costFunction(presetCurrentImperfect, presetGoal);
    costHistoryImperfectC(idx) = cost;
end

presetCurrentImperfect2 = presetStart;
for idx = 1:length(costHistoryImperfect2C)
    
    paramNum = randperm(totalPresetLength,1);
    [i,j] = paramToIJ(paramNum, presetLengthSum);
    
    presetCurrentImperfect2{i}(j) =...
            presetCurrentImperfect2{i}(j)...
            +(1+imperfectStdDev*randn)*(presetGoal{i}(j) - presetCurrentImperfect2{i}(j));
        
    cost = costFunction(presetCurrentImperfect2, presetGoal);
    
    costHistoryImperfect2C(idx) = cost;
end


meanCostHistoryImperfectC{index} = meanCostHistoryImperfectC{index} + costHistoryImperfectC/numIterationsB;
meanCostHistoryImperfect2C{index} = meanCostHistoryImperfect2C{index} + costHistoryImperfect2C/numIterationsB;

end
end

%% Plots
figure(13)
clf, hold on
title('\fontsize{16}Comparison of \sigma values')
xlabel('\fontsize{16}Number of Iterations')
ylabel('\fontsize{16}Normalised Error')
colours = winter(6);

ylim([0,1])

plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectC{6}]/meanInitialCost,'Color', colours(6,:), 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectC{5}]/meanInitialCost,'Color', colours(5,:), 'LineWidth', 2)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectC{4}]/meanInitialCost,'Color', colours(4,:), 'LineWidth', 2)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectC{3}]/meanInitialCost,'Color', colours(3,:), 'LineWidth', 2)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectC{2}]/meanInitialCost,'Color', colours(2,:), 'LineWidth', 2)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfectC{1}]/meanInitialCost,'Color', colours(1,:), 'LineWidth', 2)


plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2C{6}]/meanInitialCost, ':','Color', colours(6,:), 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2C{5}]/meanInitialCost, ':','Color', colours(5,:), 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2C{4}]/meanInitialCost, ':','Color', colours(4,:), 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2C{3}]/meanInitialCost, ':','Color', colours(3,:), 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2C{2}]/meanInitialCost, ':','Color', colours(2,:), 'LineWidth', 3)
plot((0:1:plotLength), [meanInitialCost, meanCostHistoryImperfect2C{1}]/meanInitialCost, ':','Color', colours(1,:), 'LineWidth', 3)


legend( {'\sigma = 1.0',... 
         '\sigma = 0.8',...
         '\sigma = 0.6',...
         '\sigma = 0.4',...
         '\sigma = 0.2',...
         '\sigma = 0.0'},...
         'FontSize', 14)

