function preset = mixPresets2(appData,ratios)
%appData is a ApplicationDataBlendingInterface object

alpha = ratios(1);
beta = ratios(2);
gamma = ratios(3);

preset = cell(1,12);
for i = appData.P.unfrozenIndeces
    preset{i} = mixPresets(appData.P.presetA{i}, appData.P.presetB{i}, appData.P.presetC{i},...
        alpha,beta,gamma);
end

% Apply any necessary parameter constraints
% Should make a function out of this!!!
preset = applyParameterConstraints(preset);
end