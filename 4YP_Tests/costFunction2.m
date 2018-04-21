function [cost, iMax, jMax] = costFunction2(presetA, presetB)
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

for i = 1:7
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