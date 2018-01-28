function [x,y] = triangleWave(rate, amp, plotLength)

period = 1/rate;

if nargin < 4
    plotLength = 1;
end

numPeriodsToPlot = floor(plotLength/period) + 1;

x = (0:2*numPeriodsToPlot)*period/2;


y = (-2*mod((0:2*numPeriodsToPlot), 2) + 1) * amp;
end