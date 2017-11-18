function [] = sendAllStructParamsOverOSC(preset, nameStrings, typeStrings, u)

% send OSC message to supercollider to conrtol FM7-MIDI-Synth

 %% Open UDP connection
% u = udp('127.0.0.1',57120); 
% fopen(u); 

%% Probably a good idea to only send parameters whose values have changed?
% but most will ususally change? - willsee how bad lag is :)
%%

startIndex = 1;
for i = 1:length(typeStrings)

oscsend(u,nameStrings{i},typeStrings{i},...
    preset{i}); 
startIndex = startIndex + length(typeStrings{i});

end
 %% Close UDP Connection
% fclose(u);