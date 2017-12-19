function [x,y] = triangleWave(rate, amp)

period = 1/rate;

plotLength = 1;


numPeriodsToPlot = floor(plotLength/period) + 1;

x = (0:2*numPeriodsToPlot)*period/2;


y = (-2*mod((0:2*numPeriodsToPlot), 2) + 1) * amp;
end