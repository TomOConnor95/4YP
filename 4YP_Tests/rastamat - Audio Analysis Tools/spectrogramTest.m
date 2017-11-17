[song, fs] = audioread('Pad19.wav');
%[song, fs] = audioread('HazeBass.wav');
song = song(1:fs*1,1);
 soundsc(song,sr)
%spectrogram(song, windowSize, windowOverlap, freqRange, fs, 'yaxis');

%Larger Window Size value increases frequency resolution
%Smaller Window Size value increases time resolution
%Specify a Frequency Range to be calculated for using the Goertzel function
%Specify which axis to put frequency

%%EXAMPLE
figure(1)
spectrogram(song, 256, [], [], fs, 'yaxis');
%Window Size = 256, Window Overlap = Default, Frequency Range = Default
%Feel free to experiment with these values

%%
 [mm,aspc] = melfcc(song*3.3752, sr, 'maxfreq', 8000, 'numcep', 40, 'nbands', 42, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
 % .. then convert the cepstra back to audio (same options)
 [im,ispc] = invmelfcc(mm, sr, 'maxfreq', 8000, 'numcep', 40, 'nbands', 42, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
 % listen to the reconstruction
 soundsc(im,sr)
 
 figure
 subplot(2,1,1)
 surf(mm)
 title('MFCC coefficients over Time')
 subplot(2,1,2)
 surf(log(abs(mm)))
 title('log abs MFCC coefficients over Time')
 
 % compare the spectrograms
%  subplot(3,1,1)
%  specgram(d,512,sr)
%  caxis([-50 30])
%  title('original music')
%  subplot(3,1,2)
%  specgram(im,512,sr)
%  caxis([-40 40])
%  title('noise-excited reconstruction from cepstra')