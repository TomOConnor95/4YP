function [alpha,beta,gamma] = calculatePresetRatios2(P1)

% matrix equation for no orthogonal basis vectors
%https://math.stackexchange.com/questions/148199/
% equation-for-non-orthogonal-projection-of-a-point-onto-two-vectors-representing


sideLength = 10;

%A = [0;0];
B = [-sideLength/2;sideLength*(sqrt(3)/2)];
C = [sideLength/2;sideLength*(sqrt(3)/2)];

M = [B,C];
Y = (M'*M)\M'*P1';
beta = Y(1);
gamma = Y(2);
alpha = 1-beta-gamma;

end