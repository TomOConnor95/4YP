function [weights] = sigmoidWeights(numberOfPoints, centerRatio)
% Creates normalised sigmoid weights centered on numberOfPoints*centerRatio
x = 1:numberOfPoints;
y = sigmf(x,[10/numberOfPoints, centerRatio*numberOfPoints]);
weights = y/sum(y);
