function [presetA, nameStrings, typeStrings] = createPresetAforOSC()
%% The names of these variables are the same as the names of the corresponding OSC messages

%% Preset A
% PMparams
presetA{1} = [...
    0.0, 1.0, 1.0, 1.0, 0.4, 0.0, ...
    0.0, 0.0, 0.0, 1.0, 0.0, 4.0, ...
    0.0, 0.0, 0.0, 0.0, 4.0, 0.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
    0.0, 0.0, 0.0, 0.2, 0.0, 0.0]; 
% freqCoarse   
presetA{2} = [1, 0.5, 1, 0.5, 1, 1]; 
% freqFine
presetA{3} = [0, 0.01, 0.0, 0.0, 0, 0]; 
% outputLevels
presetA{4} = [1, 0.5, 0.1, 0.0, 0.0, 0.0]; 
% envAmt
presetA{5} = [0.0, 0.5, 0.3, 1, 1, 1 ]; 
% lfoADepth
presetA{6} = [0.0, 0.5, 0.3, 0.2, 0.6, 0.5]; 
% lfoAParams      %lfo1Rate, lfo1Amp, lfo1PhaseSpread
presetA{7} = [5.10, 0.8, 0.1]; 

% envAmpParams  % A, D, S, R, curve
presetA{8} = [0.6, 0.1, 0.7, 0.5]; 
% env1Params    %A, D, S, R, curve
presetA{9} = [0.7, 0.9, 1.0, 0.5]; 
% misc
presetA{10} = [0.9]; % StereoSpread


nameStrings = {'/PMparams',...
               '/freqCoarse',...
               '/freqFine',...
               '/outputLevels',...
               '/envAmt',...
               '/lfoADepth',...
               '/lfoAParams',...
               '/envAmpParams',...
               '/env1Params',...
               '/misc'...
               };
         
presetComponentLengths = zeros(1,length(presetA));       
for i = 1:length(presetA)    
presetComponentLengths(i)= length(presetA{i});
end
        
typeStrings = cell(1,length(presetComponentLengths));
for i = 1:length(presetComponentLengths)
    typeStrings{i}(1:presetComponentLengths(i))  = 'f';
end

end