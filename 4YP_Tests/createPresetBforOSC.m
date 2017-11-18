function [presetB] = createPresetBforOSC()
%% The names of these variables are the same as the names of the corresponding OSC messages

%% Preset B
% PMparams
presetB{1} = [...
    0.0, 1.0, 0.4, 0.5, 0.4, 0.2, ...
    0.0, 0.0, 0.0, 1.0, 0.0, 0.0, ...
    0.0, 0.0, 0.0, 0.0, 4.0, 0.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
    0.0, 0.1, 0.0, 0.1, 0.0, 0.0, ...
    0.0, 0.0, 0.0, 0.2, 0.0, 0.0]; 
% freqCoarse
presetB{2} = [1, 2, 1, 0.5, 4, 3]; 
% freqFine
presetB{3} = [0, 0.0, 0.01, 0.0, 0, 0]; 
% outputLevels
presetB{4} = [0.8, 0.9, 0.5, 0.0, 0.0, 0.0]; 
% envAmt
presetB{5} = [0.0, 0.5, 0.3, 1, 1, 1 ]; 
% lfoADepth
presetB{6} = [0.9, 0.1, 0.2, 0.3, 0.2, 0.1]; 
        %lfo1Rate, lfo1Amp, lfo1PhaseSpread
% lfoAParams 
presetB{7} = [1, 0.4, 0.0]; 

% envAmpParams      %A, D, S, R, curve
presetB{8} = [0.1, 0.1, 0.7, 0.5]; 
% env1Params       %A, D, S, R, curve
presetB{9} = [0.01, 2.0, 0.1, 0.5]; 
% misc
presetB{10} = 0.1; % StereoSpread


end
