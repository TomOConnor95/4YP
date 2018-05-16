function preset = mixPresets2(appData,ratios, presetA, presetB, presetC)
%appData is a ApplicationDataBlendingInterface object

alpha = ratios(1);
beta = ratios(2);
gamma = ratios(3);

preset = presetA;
for i = appData.P.unfrozenIndeces
    preset{i} = mixPresets(presetA{i}, presetB{i}, presetC{i},...
        alpha,beta,gamma);
end

% Apply any necessary parameter constraints
% Should make a function out of this!!!
preset = applyParameterConstraints(preset);
end