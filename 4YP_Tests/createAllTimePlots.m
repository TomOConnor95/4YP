function [Tplot] = createAllTimePlots(Tdata)

plotLengthLfo = 1;
plotLengthVib = 5;

subplot(2,2,1)
ampColour = [70, 130, 220]/256;
modColour = [220, 70, 70]/256;
Tplot.modFill = fill([Tdata.xMod,0], [Tdata.yMod,0], modColour, 'FaceAlpha', 0.5, 'LineWidth', 3, 'EdgeColor', modColour);
hold on
Tplot.ampFill = fill([Tdata.xAmp,0], [Tdata.yAmp,0], ampColour, 'FaceAlpha', 0.5, 'LineWidth', 3, 'EdgeColor', ampColour);
hold off
xlim([0, 8])
ylim([0, 1])
title('ADSR Envelope')
 
subplot(2,2,2)
Tplot.vibratoWavePlot = plot(Tdata.xVib,Tdata.yVib, 'LineWidth', 3);
xlim([0, plotLengthVib])
ylim([-1, 1])
grid on
title('Vibrato Envelope')

subplot(2,2,3)
Tplot.triWavePlot = plot(Tdata.xA,Tdata.yA, 'LineWidth', 3);
xlim([0, plotLengthLfo])
ylim([-1, 1])
grid on
title('LFO A')

subplot(2,2,4)
Tplot.squareWavePlot = plot(Tdata.xB,Tdata.yB, 'LineWidth', 3);
xlim([0, plotLengthLfo])
ylim([-1, 1]) 
grid on
title('LFO B')

end