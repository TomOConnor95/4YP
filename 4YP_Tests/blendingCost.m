function [cost] = blendingCost(xy,presetA, presetB,presetC, presetGoal)

presetMix = blendXY(xy,presetA, presetB,presetC);

% x = xy(1);
% y = xy(2);
% 
% [alpha, beta, gamma] = calculatePresetRatios2([x, y]);
% 
% 
% presetMix = presetA;
% for i = 1:length(presetA)
%     presetMix{i} = mixPresets(presetA{i}, presetB{i}, presetC{i},...
%         alpha,beta,gamma);
% end
% 
% % Apply any necessary parameter constraints
% % Should make a function out of this!!!
% presetMix = applyParameterConstraints(presetMix);

cost = costFunction(presetMix, presetGoal);

end