%Examples

 %% Example 1
 % Load a speech waveform
 [d,sr] = audioread('sm1_cln.wav');
 % Look at its regular spectrogram
 subplot(411)
 specgram(d, 256, sr);
 
 % Calculate basic RASTA-PLP cepstra and spectra
 [cep1, spec1] = rastaplp(d, sr);
 % .. and plot them
 subplot(412)
 imagesc(10*log10(spec1)); % Power spectrum, so dB is 10log10
 axis xy
 subplot(413)
 imagesc(cep1)
 axis xy
 % Notice the auditory warping of the frequency axis to give more 
 % space to low frequencies and the way that RASTA filtering 
 % emphasizes the onsets of static sounds like vowels


 % Calculate 12th order PLP features without RASTA
 [cep2, spec2] = rastaplp(d, sr, 0, 12);
 % .. and plot them
 subplot(414)
 imagesc(10*log10(spec2));
 axis xy
 % Notice the greater level of temporal detail compared to the 
 % RASTA-filtered version.  There is also greater spectral detail 
 % because our PLP model order is larger than the default of 8
 
 % Append deltas and double-deltas onto the cepstral vectors
 del = deltas(cep2);
 % Double deltas are deltas applied twice with a shorter window
 ddel = deltas(deltas(cep2,5),5);
 % Composite, 39-element feature vector, just like we use for speech recognition
 cepDpDD = [cep2;del;ddel];
 
 
 %% Example 2
  % Read in an mp3 file, downsampled to 22 kHz mono
 %[d,sr] = mp3read('thompson_twins--Into_The_Gap--Hold_Me_Now--3.mp3',[1 30*22050],1,2);
% /usr/bin/mpg123 -2 -m -n 1150 -q -w /tmp/tmp950.wav "thompson_twins--Into_The_Gap--Hold_Me_Now--3.mp3"
 soundsc(d,sr)
 % Convert to MFCCs very close to those genrated by feacalc -sr 22050 -nyq 8000 -dith -hpf -opf htk -delta 0 -plp no -dom cep -com yes -frq mel -filt tri -win 32 -step 16 -cep 20
 [mm,aspc] = melfcc(d*3.3752, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
 % .. then convert the cepstra back to audio (same options)
 [im,ispc] = invmelfcc(mm, sr, 'maxfreq', 8000, 'numcep', 20, 'nbands', 22, 'fbtype', 'fcmel', 'dcttype', 1, 'usecmp', 1, 'wintime', 0.032, 'hoptime', 0.016, 'preemph', 0, 'dither', 1);
 % listen to the reconstruction
 soundsc(im,sr)
 % compare the spectrograms
 subplot(3,1,1)
 specgram(d,512,sr)
 caxis([-50 30])
 title('original music')
 subplot(3,1,2)
 specgram(im,512,sr)
 caxis([-40 40])
 title('noise-excited reconstruction from cepstra')
 % Notice how spectral detail is blurred out e.g. the triangle hits around 6 kHz are broadened to a noise bank from 6-8 kHz.
 % save out the reconstruction
 max(abs(im))

 %audiowrite('HoldMeNow.wav',sr, im/4);    %im/4