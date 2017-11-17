function [squaredErrorSum] = evaluateFitnessUI(img, targetImg, mousePos, presetA, presetB, presetC)

[alpha,beta,gamma] = calculatePresetRatios2(mousePos);

presetMix = mixPresetsF(presetA,presetB,presetC,alpha,beta,gamma);


squaredErrorSum = evaluateFitness(presetMix, img, targetImg);

end