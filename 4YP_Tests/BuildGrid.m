function [ CalibrationGrid ] = BuildGrid( GridIncrement,GridWidth )
%BUILDGRID Creates a list of points for all of the corners in the
% calibration grid in the format [x y 0 1]
% Calibration will be defined with [0 0 0 1] at the centre of the grid.
% points will be ordered left to right, bottom to top

TestRemainder(GridIncrement,GridWidth);

% Create list of co-ordinates in [x y 0 1] format, origin at bottom left
CalibrationGrid = CalibrationGridPositive(GridIncrement,GridWidth);

% Shift the origin to the centre of the grid
CalibrationGrid(:,[1 2]) = CalibrationGrid(:,[1 2]) - GridWidth/2;
end

function [CalibrationGrid] = CalibrationGridPositive( GridIncrement,GridWidth )
% Create list of co-ordinates in [x y 0 1] format, origin at bottom left
PointsPerEdge = GridWidth/GridIncrement + 1;

CalibrationGrid = zeros(PointsPerEdge,2);

CounterX = 0;
CounterY = 0;

for j = 1:PointsPerEdge
    for i = 1:PointsPerEdge
        
        CalibrationGrid(CounterX + 1 + PointsPerEdge*CounterY,:) = ...
                [CounterX*GridIncrement, CounterY*GridIncrement];
            
        CounterX = CounterX + 1;
        
    end
    CounterY = CounterY + 1;
    CounterX = 0;
end

end

function [] = TestRemainder( GridIncrement,GridWidth )
Remainder = mod(GridWidth,GridIncrement);
if Remainder ~= 0
     error('GridWidth %i, is not a multiple of GridIncrement %i',GridWidth,GridIncrement)
end
end