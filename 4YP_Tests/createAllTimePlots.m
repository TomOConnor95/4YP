function [T] = createAllTimePlots(T)

plotLengthLfo = 1;
plotLengthVib = 5;

subplot(2,2,1)
ampColour = [70, 130, 220]/256;
modColour = [220, 70, 70]/256;
T.modFill = fill([T.xMod,0], [T.yMod,0], modColour, 'FaceAlpha', 0.5, 'LineWidth', 3, 'EdgeColor', modColour);
hold on
T.ampFill = fill([T.xAmp,0], [T.yAmp,0], ampColour, 'FaceAlpha', 0.5, 'LineWidth', 3, 'EdgeColor', ampColour);
hold off
xlim([0, 8])
ylim([0, 1])
title('ADSR Envelope')
 
subplot(2,2,2)
T.vibratoWavePlot = plot(T.xVib,T.yVib, 'LineWidth', 3);
xlim([0, plotLengthVib])
ylim([-1, 1])
grid on
title('Vibrato Envelope')

subplot(2,2,3)
T.triWavePlot = plot(T.xA,T.yA, 'LineWidth', 3);
xlim([0, plotLengthLfo])
ylim([-1, 1])
grid on
title('LFO A')

subplot(2,2,4)
T.squareWavePlot = plot(T.xB,T.yB, 'LineWidth', 3);
xlim([0, plotLengthLfo])
ylim([-1, 1]) 
grid on
title('LFO B')

end