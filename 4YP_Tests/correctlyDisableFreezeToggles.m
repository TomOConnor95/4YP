function G = correctlyDisableFreezeToggles(G, P)
    % Corretly Colour blending UI Buttons based on frozen state
    
    if P.isTimbreFrozen
        G.togglePMparams.Enable = 'off';
        G.toggleFreqCoarse.Enable = 'off';
        G.toggleFreqFine.Enable = 'off';
        G.toggleOutputLevels.Enable = 'off';
        G.toggleEnvAmt.Enable = 'off';
        G.toggleLfoADepth.Enable = 'off';
        G.toggleLfoBDepth.Enable = 'off';
    else
        G.togglePMparams.Enable = 'on';
        G.toggleFreqCoarse.Enable = 'on';
        G.toggleFreqFine.Enable = 'on';
        G.toggleOutputLevels.Enable = 'on';
        G.toggleEnvAmt.Enable = 'on';
        G.toggleLfoADepth.Enable = 'on';
        G.toggleLfoBDepth.Enable = 'on';
    end

    if P.isTimeFrozen
        G.toggleLfoAParams.Enable = 'off';
        G.toggleLfoBParams.Enable = 'off';
        G.toggleEnvAmpParams.Enable = 'off';
        G.toggleEnv1Params.Enable = 'off';
        G.toggleMisc.Enable = 'off';
    else
        G.toggleLfoAParams.Enable = 'on';
        G.toggleLfoBParams.Enable = 'on';
        G.toggleEnvAmpParams.Enable = 'on';
        G.toggleEnv1Params.Enable = 'on';
        G.toggleMisc.Enable = 'on';
    end
end