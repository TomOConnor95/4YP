function [presetMix] = mixPresets(presetA,presetB,presetC,alpha,beta,gamma)

presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
end