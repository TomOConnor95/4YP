function cost = pcaCost(x, presetIn, presetGoal, coeffCell, pcaWeightsTT,...
        globalCoeffCell, pcaWeightsGlobal, pcaNumber)
    
    if pcaNumber <9
        pcaWeightsTT(pcaNumber) = x;
    else
        pcaWeightsGlobal(pcaNumber - 8) = x;
    end
   
    % Alter Selected preset
    preset = adjustPresetWithPCA(...
        presetIn,...
        coeffCell, pcaWeightsTT,...
        globalCoeffCell, pcaWeightsGlobal);
    
    cost = costFunction(preset, presetGoal);
end