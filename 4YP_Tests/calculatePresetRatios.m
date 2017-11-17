function [alpha,beta,gamma] = calculatePresetRatios(G)

% matrix equation for no orthogonal basis vectors
%https://math.stackexchange.com/questions/148199/
% equation-for-non-orthogonal-projection-of-a-point-onto-two-vectors-representing

M = [G.B,G.C];
Y = (M'*M)\M'*G.P1;
beta = Y(1);
gamma = Y(2);
alpha = 1-beta-gamma;

end