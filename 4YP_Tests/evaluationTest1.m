% a test to simulate a perfect user using a traditional interface, vs an
% imperfect user using one

presetRead = matfile('PresetStoreSC.mat');
numPresets = 36;

figure(11)
clf
subplot(1,2,1)
hold on
subplot(1,2,2)
hold on

costHistory = zeros(1,100);
meanCostHistory = zeros(1,100);
meanInitialCost = 0;


numIterations = 25;
for p = 1:numIterations
numAB= randperm(36,2);
numA = numAB(1);
numB = numAB(2);

presetStart = presetRead.presetStore(numA,:);
presetGoal  = presetRead.presetStore(numB,:);



[initialCost, iMax, jMax] = costFunction(presetStart, presetGoal);

presetCurrent = presetStart;
for i = 1:100
    presetCurrent{iMax}(jMax) = presetGoal{iMax}(jMax);
    [cost, iMax, jMax] = costFunction(presetCurrent, presetGoal);
    costHistory(i) = cost;
end


meanCostHistory = meanCostHistory + costHistory/numIterations;
meanInitialCost = meanInitialCost + initialCost/numIterations;

subplot(1,2,1)
plot((0:1:100), [initialCost, costHistory], 'b')
subplot(1,2,2)
plot((0:1:100), [initialCost, costHistory]/initialCost, 'b')

end

subplot(1,2,1)
plot((0:1:100), [meanInitialCost, meanCostHistory], 'r', 'LineWidth', 3)
subplot(1,2,2)
plot((0:1:100), [meanInitialCost, meanCostHistory]/meanInitialCost, 'r', 'LineWidth', 3)




function [cost, iMax, jMax] = costFunction(presetA, presetB)
ranges = [
            5
            10
            1
            1
            1
            1
            1
            5
            5
            3
            3
            3
          ]; 

% Weight parameter cells by importance
weights = [
            3       % PMparams
            10      % freqCoarse  
            10      % freqFine
            3       % outputLevels
            1       % envAmt
            1       % lfoADepth
            1       % lfoBDepth
            3       % lfoAParams
            3       % lfoBParams
            10      % envAmpParams
            10      % env1Params
            1       % misc
          ];

cost = 0;
maxCost = 0;
iMax = 1; 
jMax = 1;

for i = 1:12
    cost = cost + weights(i)*sum(abs(presetA{i} - presetB{i}))/ranges(i);
    for j = 1:length(presetA{i})
        if (weights(i)*abs(presetA{i}(j) - presetB{i}(j)))/ranges(i) > maxCost
            maxCost = (weights(i)*abs(presetA{i}(j) - presetB{i}(j)))/ranges(i);
            iMax = i; 
            jMax = j;
        end
    end
        
end

end