function [x, y] = ADSR(A, D, S, R)
x = [0, sqrt(A), sqrt(A)+sqrt(D), 5, 5 + sqrt(R)];
y = [0, 1, S, S, 0];
end