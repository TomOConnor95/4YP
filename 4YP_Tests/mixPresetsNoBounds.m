function [presetMix] = mixPresetsF(presetA,presetB,presetC,alpha,beta,gamma)

presetMix = (presetA * alpha) + (presetB*beta) + (presetC*gamma);
%presetMix = bound(presetMix,0,1);  % return preset values bounded between 0 and 1
end