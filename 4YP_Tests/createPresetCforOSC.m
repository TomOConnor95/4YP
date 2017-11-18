function [presetC] = createPresetCforOSC()
%% The names of these variables are the same as the names of the corresponding OSC messages

%% Preset C
% PMparams
presetC{1} = [...
    0.0, 1.0, 1.0, 1.0, 0.4, 0.0, ...
    0.0, 0.0, 0.0, 1.0, 0.0, 4.0, ...
    0.0, 0.0, 0.0, 0.0, 4.0, 0.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
    0.0, 0.0, 0.0, 0.2, 0.0, 0.0]; 

% freqCoarse
presetC{2} = [1, 2, 3, 4, 6, 8]; 
% freqFine
presetC{3} = [0, 0.0, 0.01, 0.0, 0.01, 0]; 
% outputLevels
presetC{4} = [0.8, 0.8, 0.8, 0.8, 0.3, 0.4]; 
% envAmt
presetC{5} = [0.0, 0.5, 0.3, 1, 1, 1 ]; 
% lfoADepth
presetC{6} = [0.9, 0.1, 0.2, 0.3, 0.2, 0.1]; 
        %lfo1Rate, lfo1Amp, lfo1PhaseSpread
% lfoAParams
presetC{7} = [1, 0.4, 0.0]; 
% envAmpParams
         %A, D, S, R, curve
presetC{8} = [0.4, 0.1, 0.8, 0.5]; 
% env1Params         %A, D, S, R, curve
presetC{9} = [0.7, 2.0, 0.1, 0.5]; 
% misc
presetC{10} = 0.1; % StereoSpread


end