function [squaredErrorSum] = evaluateFitnessUI(img, targetImg, mousePos, presetA, presetB, presetC)

[alpha,beta,gamma] = calculatePresetRatios2(mousePos);

presetMix = mixPresets(presetA,presetB,presetC,alpha,beta,gamma);

presetMix = bound(presetMix,0,1);  % return preset values bounded between 0 and 1

squaredErrorSum = evaluateFitness(presetMix, img, targetImg);

end