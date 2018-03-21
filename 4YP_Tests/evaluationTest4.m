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

numTests = 20;

for p = 1:numTests

% Start and Goal generation
num = randperm(numPresets, 1);
presetGoal  = presetRead.presetStore(num,:);

presetA  = presetRead.presetStore(sortedIndeces(num, 2),:);
presetB  = presetRead.presetStore(sortedIndeces(num, 3),:);
presetC  = presetRead.presetStore(sortedIndeces(num, 4),:);


% Generate new presets Setup
numIterations = 100;
presetAHistory = presetA;
tempOffset = initialTempOffset;

x0 = 0; y0 = 0;
costHistory = zeros(1,numIterations+1);
costHistory(1) = sortedCosts(num, 2);

for i = 1:numIterations
    f = @(xy)blendingCost(xy, presetA, presetB, presetC, presetGoal);
    [optimumParams,cost] = patternsearch(f,[x0,y0]);
    costHistory(i+1) = cost;
    
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

plot(0:1:100,costHistory)
hold on
    
end
