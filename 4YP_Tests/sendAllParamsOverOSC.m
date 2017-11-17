function [] = sendAllParamsOverOSC(preset, lengths, nameStrings, typeStrings, u)

% send OSC message to supercollider to conrtol FM7-MIDI-Synth

 %% Open UDP connection
% u = udp('127.0.0.1',57120); 
% fopen(u); 

%% Probably a good idea to only send parameters whose values have changed?
% but most will ususally change? - willsee how bad lag is :)
%%
startIndex = 1;
%%

oscsend(u,'/PMparams',typeStrings{1},...
    preset(startIndex:(startIndex + lengths(1) -1))); 
startIndex = startIndex + lengths(1);
%%
oscsend(u,'/freqCoarse',typeStrings{2},... 
mapToFreqCoarse(preset(startIndex:(startIndex + lengths(2) -1)))); 
startIndex = startIndex + lengths(2);
%%
%oscsend(u,'/freqFine',typeStrings{3},... 
%preset(startIndex:(startIndex + lengths(3) -1))); 
oscsend(u,'/freqFine',typeStrings{3},0,0,0,0,0,0);
startIndex = startIndex + lengths(3);
%%
oscsend(u,'/outputLevels',typeStrings{4},... 
preset(startIndex:(startIndex + lengths(4) -1))); 
startIndex = startIndex + lengths(4);
%%
oscsend(u,'/envAmt',typeStrings{5},... 
preset(startIndex:(startIndex + lengths(5) -1))); 
startIndex = startIndex + lengths(5);
%%
oscsend(u,'/lfoADepth',typeStrings{6},... 
preset(startIndex:(startIndex + lengths(6) -1))); 
startIndex = startIndex + lengths(6);
%%          lfo1Rate, lfo1Amp, lfo1PhaseSpread
oscsend(u,'/lfoAParams',typeStrings{7},... 
preset(startIndex:(startIndex + lengths(7) -1))); 
startIndex = startIndex + lengths(7);
%%           A, D, S, R, curve
oscsend(u,'/envAmpParams',typeStrings{8},... 
preset(startIndex:(startIndex + lengths(8) -1))); 
startIndex = startIndex + lengths(8);
%%          A, D, S, R, curve
oscsend(u,'/env1Params',typeStrings{9},... 
preset(startIndex:(startIndex + lengths(9) -1))); 
startIndex = startIndex + lengths(9);
%%
oscsend(u,'/misc',typeStrings{10},... 
preset(startIndex:(startIndex + lengths(10) -1))); 


 %% Close UDP Connection
% fclose(u);