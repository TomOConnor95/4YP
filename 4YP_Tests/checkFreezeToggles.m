function sectionsToFreeze = checkFreezeToggles(G)

sectionsToFreeze = [...
    G.togglePMparams.Value > 0,...
    G.toggleFreqCoarse.Value > 0,...
    G.toggleFreqFine.Value > 0,...
    G.toggleOutputLevels.Value > 0,...
    G.toggleEnvAmt.Value > 0,...
    G.toggleLfoADepth.Value > 0,...
    G.toggleLfoBDepth.Value > 0,...
    G.toggleLfoAParams.Value > 0,...
    G.toggleLfoBParams.Value > 0,...
    G.toggleEnvAmpParams.Value > 0,...
    G.toggleEnv1Params.Value > 0,...
    G.toggleMisc.Value > 0];
end
