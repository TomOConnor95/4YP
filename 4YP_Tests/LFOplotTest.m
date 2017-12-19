% LFO A plot - A triangle wave

rate = 4.1;   % Hz
amp = 0.5;   % 0 - 1
phaseSpread = 0.1;   % 0 - 1



[x,y] = triangleWave(rate, amp);

figure(1)
subplot(1,2,1)
triWavePlot = plot(x,y, 'LineWidth', 3);
xlim([0, plotLength])
ylim([-1, 1])
grid on

pulseWidth = 0.7;


[x2,y2] = squareWave(rate, amp, pulseWidth);
subplot(1,2,2)
squareWavePlot = plot(x2,y2, 'LineWidth', 3);
xlim([0, plotLength])
ylim([-1, 1])
 grid on
 





