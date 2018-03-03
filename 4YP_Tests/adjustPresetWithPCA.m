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
    adjustedPreset{1} = bound(adjustedPreset{1}, 0, 10);
    adjustedPreset{2} = mapToFreqCoarse(adjustedPreset{2});
    adjustedPreset{3} = bound(adjustedPreset{3}, 0, 10);
    adjustedPreset{4} = bound(adjustedPreset{4}, 0, 10);
    adjustedPreset{5} = bound(adjustedPreset{5}, 0, 10);
    adjustedPreset{6} = bound(adjustedPreset{6}, 0, 10);
    adjustedPreset{7} = bound(adjustedPreset{7}, 0, 10);
    adjustedPreset{8}(1:2) = bound(adjustedPreset{8}(1:2), 0.001, 40);
    adjustedPreset{8}(3) = bound(adjustedPreset{8}(3), 0, 1);
    adjustedPreset{9}(1:2) = bound(adjustedPreset{9}(1:2), 0.001, 40);
    adjustedPreset{9}(3) = bound(adjustedPreset{9}(3), 0, 1);
    adjustedPreset{10}(1:4) = bound(adjustedPreset{10}(1:4), 0, 40);
    adjustedPreset{11}(1:4) = bound(adjustedPreset{11}(1:4), 0, 40);
    adjustedPreset{12} = bound(adjustedPreset{12}, 0.001, 40);
end