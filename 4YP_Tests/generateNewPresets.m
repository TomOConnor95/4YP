function  [P,tempOffset] = generateNewPresets(P,tempOffset,tempScaling)

% Move preseMix to new PresetA
P.presetA = P.presetMix;

% Generate new B & C
P.presetB = (2*P.presetA + mean(P.presetAHistory))/3 + tempScaling * (tempOffset + std(P.presetAHistory).^1.5).*randn(1,length(P.presetA));
P.presetC = (2*P.presetA + mean(P.presetAHistory))/3 + tempScaling * (tempOffset + std(P.presetAHistory).^1.5).*randn(1,length(P.presetA));

P.presetB = bound(P.presetB,0,1);
P.presetC = bound(P.presetC,0,1);

% Alternate version is to completely ramdoly generate B & C
%         P.presetB = rand(1,length(P.presetA));
%         P.presetC = rand(1,length(P.presetA));

% Save presets to history
P.presetAHistory = [P.presetAHistory; P.presetA];
P.presetBHistory = [P.presetBHistory; P.presetB];
P.presetCHistory = [P.presetCHistory; P.presetC];

% Decay tempOffset
tempOffset = tempOffset*0.9;
end