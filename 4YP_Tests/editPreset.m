%% Open UDP connection
u = udp('127.0.0.1',57120); 
fopen(u); 

%% Set preset to PresetA
preset = P.presetA;
%% Set preset to PresetA
preset = P.presetB;
%% Set preset to PresetA
preset = P.presetC;

%% PMparams
preset{1} = [...
    0.0, 1.0, 1.0, 2.0, 0.4, 0.0, ...
    0.0, 0.0, 0.0, 1.0, 1.0, 4.0, ...
    0.0, 0.0, 0.0, 2.0, 1.0, 0.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 1.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
    0.0, 0.0, 0.0, 0.2, 0.0, 0.0]; 
sendParamsOverOSC(preset{1}, '/PMparams', 'ffffffffffffffffffffffffffffffffffff', u);
%% freqCoarse   
preset{2} = [1, 0.5, 1, 2, 3, 1]; 
sendParamsOverOSC(preset{2}, '/freqCoarse', 'ffffff', u);
%% freqFine
preset{3} = [0, 0.01, 0.0, 0.0, 0, 0]; 
sendParamsOverOSC(preset{3}, '/freqFine', 'ffffff', u);
%% outputLevels
preset{4} = [1.0, 0.3, 0.1, 0.0, 0.6, 0.0]; 
sendParamsOverOSC(preset{4}, '/outputLevels', 'ffffff', u);
%% envAmt
preset{5} = [0.0, 1.0, 1.0, 1, 1, 1 ]; 
sendParamsOverOSC(preset{5}, '/envAmt', 'ffffff', u);
%% lfoADepth
preset{6} = [0.2, 0.5, 0.7, 0.2, 0.6, 0.5]; 
sendParamsOverOSC(preset{6}, '/lfoADepth', 'ffffff', u);
%% lfoBDepth
preset{7} = [0.9, 0.5, 0.3, 0.3, 0.6, 0.5]; 
sendParamsOverOSC(preset{7}, '/lfoBDepth', 'ffffff', u);
%% lfoAParams      %lfo1Rate, lfo1Amp, lfo1PhaseSpread
preset{8} = [2.10, 0.9, 0.5]; 
sendParamsOverOSC(preset{8}, '/lfoAParams', 'fff', u);
%% lfoBParams      %lfo2Rate, lfo2Amp, lfo2PulseWidth
preset{9} = [1.40, 0.01, 0.5]; 
sendParamsOverOSC(preset{9}, '/lfoBParams', 'fff', u);
%% envAmpParams  % A, D, S, R, curve
preset{10} = [0.02, 0.1, 0.9, 0.5]; 
sendParamsOverOSC(preset{10}, '/envAmpParams', 'ffff', u);
%% env1Params    %A, D, S, R, curve
preset{11} = [0.05, 0.9, 1.0, 0.2]; 
sendParamsOverOSC(preset{11}, '/env1Params', 'ffff', u);
%% misc         % StereoSpread vibFreqStart/End, %Vib AmtStart/End, VibTime
preset{12} = [0.7, 5, 1.0, 0.5, 0.4, 4.5]; 
sendParamsOverOSC(preset{12}, '/misc', 'ffffff', u);
%% Save preset to PresetA
P.presetA = preset;
%% Save preset to PresetA
P.presetB = preset;
%% Save preset to PresetA
P.presetC = preset;
