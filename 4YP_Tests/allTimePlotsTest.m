
% LFO A - A triangle wave
rateA = 4.1;        % Hz
ampA = 0.5;         % 0 - 1
phaseSpread = 0.1;  % 0 - 1 NOT USED IN PLOT
plotLengthLfo = 1;

[xA,yA] = triangleWave(rateA, ampA, plotLengthLfo);

% LFO B - a square wave
rateB = 4.1;        % Hz
ampB = 0.5;         % 0 - 1
pulseWidth = 0.7;   % 0 - 1

[xB,yB] = squareWave(rateB, ampB, pulseWidth, plotLengthLfo);

% ADSR 

ampA = 0.1;
ampD = 0.5;
ampS = 0.1;
ampR = 0.9;

modA = 0.5;
modD = 0.4;
modS = 0.7;
modR = 8;

[xAmp, yAmp] = ADSR(ampA, ampD, ampS, ampR);
[xMod, yMod] = ADSR(modA, modD, modS, modR);

% VibratoPlot - A sine wave wave changing in amplitude and frequency

startRate = 0.5;   % Hz
endRate = 6;   % Hz

startAmp = 0.9;   % 0 - 1
endAmp = 0.1;   % 0 - 1

envTime = 3;    % seconds

plotLengthVib = 5; % seconds

[xVib,yVib] = vibratoWave(startRate, endRate, startAmp, endAmp, envTime, plotLengthVib);


% Plots
figure(1)

subplot(2,2,1)
ampColour = [70, 130, 220]/256;
modColour = [220, 70, 70]/256;
modFill = fill([xMod,0], [yMod,0], modColour, 'FaceAlpha', 0.5, 'LineWidth', 3, 'EdgeColor', modColour);
hold on
ampfill = fill([xAmp,0], [yAmp,0], ampColour, 'FaceAlpha', 0.5, 'LineWidth', 3, 'EdgeColor', ampColour);
hold off
xlim([0, 8])
ylim([0, 1])
title('ADSR Envelope')
 
subplot(2,2,2)
vibratoWavePlot = plot(xVib,yVib, 'LineWidth', 3);
xlim([0, plotLengthVib])
ylim([-1, 1])
grid on
title('Vibrato Envelope')

subplot(2,2,3)
triWavePlot = plot(xA,yA, 'LineWidth', 3);
xlim([0, plotLengthLfo])
ylim([-1, 1])
grid on
title('LFO A')

subplot(2,2,4)
squareWavePlot = plot(xB,yB, 'LineWidth', 3);
xlim([0, plotLengthLfo])
ylim([-1, 1]) 
grid on
title('LFO B')

%% Change Parameters
% LFO A - A triangle wave
rateA = 2.1;        % Hz
ampA = 0.6;         % 0 - 1
[xA,yA] = triangleWave(rateA, ampA, plotLengthLfo);

% LFO B - a square wave
rateB = 2;        % Hz
ampB = 0.2;         % 0 - 1
pulseWidth = 0.3;   % 0 - 1

[xB,yB] = squareWave(rateB, ampB, pulseWidth, plotLengthLfo);

% ADSR 

ampA = 0.4;
ampD = 0.2;
ampS = 0.4;
ampR = 0.8;

modA = 0.4;
modD = 0.3;
modS = 0.9;
modR = 3;

[xAmp, yAmp] = ADSR(ampA, ampD, ampS, ampR);
[xMod, yMod] = ADSR(modA, modD, modS, modR);

% VibratoPlot - A sine wave wave changing in amplitude and frequency

startRate = 3;   % Hz
endRate = 2;   % Hz

startAmp = 0.3;   % 0 - 1
endAmp = 0.8;   % 0 - 1

envTime = 4;    % seconds

[xVib,yVib] = vibratoWave(startRate, endRate, startAmp, endAmp, envTime, plotLengthVib);

%% Update plots
modFill.Vertices(1:5,1) = xMod';
modFill.Vertices(1:5,2) = yMod';

ampFill.Vertices(1:5,1) = xAmp';
ampFill.Vertices(1:5,2) = yAmp';

vibratoWavePlot.XData = xVib;
vibratoWavePlot.YData = yVib;

triWavePlot.XData = xA;
triWavePlot.YData = yA;

squareWavePlot.XData = xB;
squareWavePlot.YData = yB;

%% Load data prom preset and update plot
presetRead = matfile('PresetStoreSC.mat');
presetStore = presetRead.presetStore;

presetNo = 17

T = timePlotDataFromPreset(presetStore(presetNo,:));

modFill.Vertices(1:5,1) = T.xMod';
modFill.Vertices(1:5,2) = T.yMod';

ampFill.Vertices(1:5,1) = T.xAmp';
ampFill.Vertices(1:5,2) = T.yAmp';

vibratoWavePlot.XData = T.xVib;
vibratoWavePlot.YData = T.yVib;

triWavePlot.XData = T.xA;
triWavePlot.YData = T.yA;

squareWavePlot.XData = T.xB;
squareWavePlot.YData = T.yB;
 