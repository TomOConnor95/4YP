function [adjustedPreset] = adjustPresetWithPCA(preset, coeffCell1, pcaWeights1, coeffCell2, pcaWeights2)
    adjustedPreset = cell(1,length(preset));

    if nargin == 3
        for i = 1:length(preset)
            adjustedPreset{i} = preset{i} + (pcaWeights1 * coeffCell1{i}');
        end
    elseif nargin == 5
        for i = 1:length(preset)
            adjustedPreset{i} = preset{i} + (pcaWeights1 * coeffCell1{i}')...
                                          + (pcaWeights2 * coeffCell2{i}');
        end     
    else
        error('Incorrect PCA inputs')
    end
    
     % Should make a function out of this!!!
    adjustedPreset = applyParameterConstraints(adjustedPreset);
end