function [] = sendParamsOverOSC(params, nameString, typeString, u)

% send OSC message to supercollider to conrtol FM7-MIDI-Synth

 %% Open UDP connection
% u = udp('127.0.0.1',57120); 
% fopen(u); 

%%

assert(length(params) == length(typeString),'Incorrect lengths');


oscsend(u,nameString,typeString,params);

end
 %% Close UDP Connection
% fclose(u);