function [x,y] = vibratoWave(startRate, endRate, startAmp, endAmp, envTime, plotLength);
if nargin < 6
    plotLength = 5; % seconds
end

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