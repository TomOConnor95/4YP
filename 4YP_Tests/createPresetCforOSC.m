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
presetC{6} = [0.9, 0.1, 0.2, 0.5, 0.2, 0.8]; 
% lfoBDepth
presetC{7} = [0.6, 0.5, 0.1, 0.2, 0.5, 0.1]; 
% lfoAParams       %lfo1Rate, lfo1Amp, lfo1PhaseSpread
presetC{8} = [10, 0.3, 0.1]; 
% lfoBParams      %lfo2Rate, lfo2Amp, lfo2PulseWidth
presetC{9} = [0.1, 0.2, 0.5]; 
        
% envAmpParams
         %A, D, S, R, curve
presetC{10} = [0.4, 0.1, 0.8, 0.5]; 
% env1Params         %A, D, S, R, curve
presetC{11} = [0.7, 2.0, 0.1, 0.5]; 
% misc         % StereoSpread vibFreqStart/End, %Vib AmtStart/End, VibTime
presetC{12} = [0.7, 15.0, 2.0, 10.0, 1.0, 3.5]; 


end