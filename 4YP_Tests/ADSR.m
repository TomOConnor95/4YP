function [x, y] = ADSR(A, D, S, R, C)
if nargin ==4
    C = 0;
end
x = [0, sqrt(A)/2,   sqrt(A), (sqrt(A) + sqrt(D)/2),    sqrt(A)+sqrt(D), 5, 5 + sqrt(R)/2, 5 + sqrt(R)];
y = [0, (0.5 -C/16), 1,       (1-((1-S)/2) +C*(1-S)/16), S,               S, (S/2 + C*S/16), 0];
end