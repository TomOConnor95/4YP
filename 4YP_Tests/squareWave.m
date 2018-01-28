function [x,y] = squareWave(rate, amp, pulseWidth, plotLength)

period = 1/rate;

if nargin < 4
    plotLength = 1;
end

numPeriodsToPlot = floor(plotLength/period) + 1;


x = (((0:4*numPeriodsToPlot) - mod((0:4*numPeriodsToPlot), 2))/2);
x = x + (mod((0:4*numPeriodsToPlot) - mod((0:4*numPeriodsToPlot), 2), 4))*(pulseWidth-0.5);
x = x * period/2;

x(1) = [];

y = -1*(mod((0:4*numPeriodsToPlot) - mod((0:4*numPeriodsToPlot), 2), 4) - 1) * amp;
y(length(y)) = [];
end