% send OSC message to supercollider to conrtol FM7-MIDI-Synth

%% Open UDP connection
u = udp('127.0.0.1',57120); 
fopen(u); 

%% Probably a good idea to only send parameters whose values have changed?

%%
oscsend(u,'/freqCoarse','ffffff', 1, 2, 1, 0.5, 1, 1); 

%%
oscsend(u,'/PMparams','ffffffffffffffffffffffffffffffffffff',...
    0.0, 1.0, 1.0, 1.0, 0.4, 0.0, ...
    0.0, 0.0, 0.0, 1.0, 0.0, 4.0, ...
    0.0, 0.0, 0.0, 0.0, 4.0, 0.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
    0.0, 0.0, 0.0, 0.0, 0.0, 0.0, ...
    0.0, 0.0, 0.0, 0.2, 0.0, 0.0); 

%%
oscsend(u,'/freqFine','ffffff', 0, 0.01, 0.0, 0.0, 0, 0); 

%%
oscsend(u,'/outputLevels','ffffff', 1, 0.5, 0.1, 0.0, 0.0, 0.0 ); 

%%
oscsend(u,'/envAmt','ffffff', 0.0, 0.5, 0.3, 1, 1, 1 ); 

%%
oscsend(u,'/lfoADepth','ffffff', 0.0, 0.5, 0.3, 0.2, 0.6, 0.5 ); 

%%          lfo1Rate, lfo1Amp, lfo1PhaseSpread
oscsend(u,'/lfoAParams','fff', 5.10, 0.8, 0.1); 

%%           A, D, S, R, curve
oscsend(u,'/envAmpParams','fffff', 0.6, 0.1, 0.7, 0.5); 

%%          A, D, S, R, curve
oscsend(u,'/env1Params','fffff', 0.7, 0.9, 1.0, 0.5); 

%%
oscsend(u,'/misc','f', 0.9); % StereoSpread


%% Close UDP Connection
fclose(u);
