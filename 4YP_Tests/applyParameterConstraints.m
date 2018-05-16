function [preset] = applyParameterConstraints(preset)

preset{1} = bound(preset{1}, 0, 10);
            preset{2} = mapToFreqCoarse(preset{2});
            preset{3} = bound(preset{3}, 0, 10);
            preset{4} = bound(preset{4}, 0, 10);
            preset{5} = bound(preset{5}, 0, 10);
            preset{6} = bound(preset{6}, 0, 10);
            preset{7} = bound(preset{7}, 0, 10);
            preset{8}(1:2) = bound(preset{8}(1:2), 0.001, 40);
            preset{8}(3) = bound(preset{8}(3), 0, 1);
            preset{9}(1:2) = bound(preset{9}(1:2), 0.001, 40);
            preset{9}(3) = bound(preset{9}(3), 0, 1);
            preset{10}(1:4) = bound(preset{10}(1:4), 0, 40);
            preset{11}(1:4) = bound(preset{11}(1:4), 0, 40);
            preset{12} = bound(preset{12}, 0.001, 40);
            
end