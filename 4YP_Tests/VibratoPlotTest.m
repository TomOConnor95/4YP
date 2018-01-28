% VibratoPlot plot - A sine wave wave changing in amplitude and frequency

startRate = 0.5;   % Hz
endRate = 6;   % Hz

startAmp = 0.9;   % 0 - 1
endAmp = 0.1;   % 0 - 1

envTime = 3;    % seconds

plotLength = 5; % seconds


[x,y] = vibratoWaveLog(startRate, endRate, startAmp, endAmp, envTime);

figure(3)

vibratoWavePlot = plot(x,y, 'LineWidth', 3);
xlim([0, plotLength])
ylim([-1, 1])
grid on



function [x,y] = vibratoWaveLinear(startRate, endRate, startAmp, endAmp, envTime)
plotLength = 5; % seconds
numPoints = 200;

if envTime < plotLength
    
    numDecayPoints = floor(numPoints*envTime/plotLength);
    
    amp = [linspace(startAmp, endAmp, numDecayPoints),...
        endAmp*ones(1,(numPoints - numDecayPoints))];
    
    rate = [linspace(startRate, endRate, numDecayPoints),...
        endRate*ones(1,(numPoints - numDecayPoints))];
    
else
    amp = linspace(startAmp, (startAmp + (endAmp-startAmp)*plotLength/envTime), numPoints);
    rate = linspace(startRate, (startRate + (endRate-startRate)*plotLength/envTime), numPoints);
    
end

x = linspace(0,5,numPoints);

phase = cumsum(rate*plotLength/numPoints);

y = sin(2*pi*phase).*amp;


end

function [x,y] = vibratoWaveLog(startRate, endRate, startAmp, endAmp, envTime)
plotLength = 5; % seconds
numPoints = 200;

if envTime < plotLength
    numDecayPoints = floor(numPoints*envTime/plotLength);
    decay = ((logspace(0,-1,numDecayPoints)-0.1)/0.9); % exp from 1 to 0
    
    amp = [(endAmp + (startAmp - endAmp)*decay),...
        endAmp*ones(1,(numPoints - numDecayPoints))];
    
    rate = [(endRate + (startRate - endRate)*decay),...
        endRate*ones(1,(numPoints - floor(numPoints*envTime/plotLength)))];
    
else
    numDecayPoints = floor(numPoints*envTime/plotLength);
    decay = ((logspace(0,-1,numDecayPoints)-0.1)/0.9);
    decay = decay(1:numPoints);
    amp = endAmp + (startAmp - endAmp)*decay;
    rate = endRate + (startRate - endRate)*decay;
end

x = linspace(0,5,numPoints);

phase = cumsum(rate*plotLength/numPoints);

y = sin(2*pi*phase).*amp;

end






